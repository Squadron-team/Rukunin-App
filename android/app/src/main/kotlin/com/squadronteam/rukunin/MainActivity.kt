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
import java.nio.FloatBuffer

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

            val byteBuffer = ByteBuffer.wrap(bytes).order(ByteOrder.nativeOrder())
            val floatBuffer = byteBuffer.asFloatBuffer()

            if (floatBuffer.remaining() != 1764) {
                throw IllegalArgumentException(
                        "Expected 1764 features but received ${floatBuffer.remaining()}"
                )
            }

            val outputList = runInference(currentSession, floatBuffer, length.toLong())
            result.success(outputList)
        } catch (e: Exception) {
            e.printStackTrace()
            result.error("INFERENCE_ERROR", "Failed to run inference: ${e.message}", e.stackTraceToString())
        }
    }

    private fun runInference(session: OrtSession, inputBuffer: FloatBuffer, length: Long): List<Double> {
        try {
            val inputName = session.inputNames.iterator().next()
            val shape = longArrayOf(1, length)

            OnnxTensor.createTensor(ortEnv, inputBuffer, shape).use { tensor ->
                session.run(mapOf(inputName to tensor)).use { outputs ->
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
            }
        } catch (e: Exception) {
            // Re-throw the exception to be caught by the handler
            throw Exception("Error during ONNX inference: ${e.message}", e)
        }
    }

    private fun loadOnnxModel(modelBytes: ByteArray) {
        ortEnv = OrtEnvironment.getEnvironment()
        session = ortEnv.createSession(modelBytes)
    }
}
