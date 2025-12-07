package com.squadronteam.rukunin

import ai.onnxruntime.OnnxTensor
import ai.onnxruntime.OrtEnvironment
import ai.onnxruntime.OrtSession
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.nio.ByteBuffer
import java.nio.ByteOrder

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "onnx_runtime"

    private lateinit var ortEnv: OrtEnvironment
    private var session: OrtSession? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call,
                result ->
            when (call.method) {

                // LOAD ONNX MODEL
                "loadModel" -> {
                    try {
                        val modelBytes = call.argument<ByteArray>("modelBytes")!!
                        loadOnnxModel(modelBytes)
                        result.success(true)
                    } catch (e: Exception) {
                        e.printStackTrace()
                        result.error("LOAD_ERROR", e.message, null)
                    }
                }

                // RUN INFERENCE
                "runInference" -> {
                    try {
                        val sess = session
                        if (sess == null) {
                            result.error("NO_MODEL", "Model not loaded", null)
                            return@setMethodCallHandler
                        }

                        val inputArray = call.argument<List<Double>>("input")!!
                        val floatArray =
                                FloatArray(inputArray.size) { i -> inputArray[i].toFloat() }

                        val shape = longArrayOf(1, inputArray.size.toLong())

                        // Build ByteBuffer for ORT Mobile
                        val byteBuffer = ByteBuffer.allocateDirect(4 * floatArray.size)
                        byteBuffer.order(ByteOrder.nativeOrder())
                        for (f in floatArray) {
                            byteBuffer.putFloat(f)
                        }
                        byteBuffer.rewind()

                        // Create tensor using ByteBuffer
                        val tensor = OnnxTensor.createTensor(ortEnv, byteBuffer, shape)

                        // Run inference
                        val outputs = sess.run(mapOf("input" to tensor))

                        // Extract results
                        val outputVal = outputs[0].value

                        val resultList: List<Double> =
                                when (outputVal) {
                                    is FloatArray -> {
                                        // ONNX model outputs [N]
                                        outputVal.map { it.toDouble() }
                                    }
                                    is Array<*> -> {
                                        if (outputVal.isNotEmpty()) {
                                            when (val first = outputVal[0]) {
                                                is FloatArray -> {
                                                    // 2D: float[][]
                                                    first.map { it.toDouble() }
                                                }
                                                is Array<*> -> {
                                                    // 3D (rare): Float[][]
                                                    (first as Array<*>).map {
                                                        (it as Float).toDouble()
                                                    }
                                                }
                                                is Float -> {
                                                    // 1D boxed Float[]
                                                    outputVal.map { (it as Float).toDouble() }
                                                }
                                                else ->
                                                        throw IllegalStateException(
                                                                "Unsupported inner type: ${first!!::class.java}"
                                                        )
                                            }
                                        } else {
                                            emptyList()
                                        }
                                    }
                                    else -> {
                                        throw IllegalStateException(
                                                "Unexpected ONNX output type: ${outputVal!!::class.java}"
                                        )
                                    }
                                }

                        result.success(resultList)
                    } catch (e: Exception) {
                        e.printStackTrace()
                        result.error("INFERENCE_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun loadOnnxModel(modelBytes: ByteArray) {
        ortEnv = OrtEnvironment.getEnvironment()
        session = ortEnv.createSession(modelBytes)
    }
}
