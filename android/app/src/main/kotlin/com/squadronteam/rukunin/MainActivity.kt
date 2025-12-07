package com.squadronteam.rukunin

import ai.onnxruntime.OnnxTensor
import ai.onnxruntime.OrtEnvironment
import ai.onnxruntime.OrtSession
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.nio.FloatBuffer

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

                        val inputArray = call.argument<FloatArray>("input")!!
                        val floatArray = inputArray

                        val inputName = sess.inputNames.iterator().next()
                        val shape = longArrayOf(1, floatArray.size.toLong())

                        // Create tensor
                        val floatBuffer = FloatBuffer.wrap(floatArray)
                        val tensor = OnnxTensor.createTensor(ortEnv, floatBuffer, shape)

                        // Run inference
                        val outputs = sess.run(mapOf(inputName to tensor))

                        val output = outputs[0].value

                        val resultList: List<Double> =
                                when (output) {
                                    is FloatArray -> output.map { it.toDouble() }
                                    is Array<*> -> (output[0] as FloatArray).map { it.toDouble() }
                                    else ->
                                            throw IllegalStateException(
                                                    "Unexpected ONNX output type: ${output::class.java}"
                                            )
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
