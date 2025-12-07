package com.squadronteam.rukunin

import ai.onnxruntime.OnnxTensor
import ai.onnxruntime.OrtEnvironment
import ai.onnxruntime.OrtSession
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.nio.ByteBuffer
import java.nio.ByteOrder

class MainActivity : FlutterFragmentActivity() {
    private companion object {
        const val CHANNEL = "onnx_runtime"
    }

    private lateinit var ortEnv: OrtEnvironment
    private var session: OrtSession? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        setupMethodChannel(flutterEngine)
    }

    private fun setupMethodChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call,
                result ->
            when (call.method) {
                "loadModel" -> handleLoadModel(call, result)
                "runInference" -> handleRunInference(call, result)
                else -> result.notImplemented()
            }
        }
    }

    private fun handleLoadModel(call: MethodCall, result: MethodChannel.Result) {
        try {
            val modelBytes =
                    call.argument<ByteArray>("modelBytes")
                            ?: throw IllegalArgumentException("Model bytes cannot be null")

            loadOnnxModel(modelBytes)
            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.error("LOAD_ERROR", e.message, null)
        }
    }

    private fun handleRunInference(call: MethodCall, result: MethodChannel.Result) {
        try {
            val currentSession = session
            if (currentSession == null) {
                result.error("NO_MODEL", "Model not loaded", null)
                return
            }

            val bytes =
                    call.argument<ByteArray>("input_bytes")
                            ?: throw IllegalArgumentException("input_bytes is null")
            val length =
                    call.argument<Int>("length") ?: throw IllegalArgumentException("length is null")

            val byteBuffer = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN)

            val inputArray = FloatArray(length)
            for (i in 0 until length) {
                inputArray[i] = byteBuffer.getFloat(i * 4)
            }

            if (inputArray.size != 1764) {
                throw IllegalArgumentException(
                        "Expected 1764 features but received ${inputArray.size}"
                )
            }

            val outputList = runInference(currentSession, inputArray)
            result.success(outputList)
        } catch (e: Exception) {
            e.printStackTrace()
            result.error("INFERENCE_ERROR", e.message, null)
        }
    }

    private fun runInference(session: OrtSession, inputArray: FloatArray): List<Double> {
        val inputName = session.inputNames.iterator().next()
        val shape = longArrayOf(1, inputArray.size.toLong())

        val byteBuffer =
                java.nio.ByteBuffer.allocateDirect(4 * inputArray.size)
                        .order(java.nio.ByteOrder.nativeOrder())

        // Write floats into direct buffer
        for (f in inputArray) {
            byteBuffer.putFloat(f)
        }
        byteBuffer.rewind()

        val tensor = OnnxTensor.createTensor(ortEnv, byteBuffer, shape)

        // Run inference
        val outputs = session.run(mapOf(inputName to tensor))
        val output = outputs[0].value

        return when (output) {
            is FloatArray -> output.map { it.toDouble() }
            is Array<*> -> (output[0] as FloatArray).map { it.toDouble() }
            else ->
                    throw IllegalStateException(
                            "Unexpected ONNX output type: ${output::class.java}"
                    )
        }
    }

    private fun loadOnnxModel(modelBytes: ByteArray) {
        ortEnv = OrtEnvironment.getEnvironment()
        session = ortEnv.createSession(modelBytes)
    }
}
