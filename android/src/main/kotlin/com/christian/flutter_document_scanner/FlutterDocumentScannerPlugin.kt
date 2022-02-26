package com.christian.flutter_document_scanner

import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.opencv.android.OpenCVLoader

/** FlutterDocumentScannerPlugin */
class FlutterDocumentScannerPlugin : FlutterPlugin, MethodCallHandler {
    private var OpenCVFLag = false

    companion object {
        const val TAG = "com.christian.Log.Tag"
        const val PLUGIN_ID = "christian.com/flutter_document_scanner"
    }

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            FlutterDocumentScannerPlugin.PLUGIN_ID
        )
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (!OpenCVFLag) {
            if (!OpenCVLoader.initDebug()) {
                Log.i(FlutterDocumentScannerPlugin.TAG, "Unable to load OpenCV")
            } else {
                OpenCVFLag = true
                Log.i(FlutterDocumentScannerPlugin.TAG, "OpenCV loaded Successfully")
            }
        }


        when (call.method) {
            "findContourPhoto" -> {
                try {
                    OpenCVPlugin.findContourPhoto(
                        result,
                        call.argument<ByteArray>("byteData") as ByteArray,
                        call.argument<ByteArray>("minContourArea") as Double
                    )
                } catch (e: Exception) {
                    result.error("FlutterDocumentScanner-Error", "Android: " + e.message, e)
                }
            }

            "adjustingPerspective" -> {
                try {
                    OpenCVPlugin.adjustingPerspective(
                        call.argument<ByteArray>("byteData") as ByteArray,
                        call.argument<List<Map<String, Any>>>("points") as List<Map<String, Any>>,
                        result
                    )
                } catch (e: Exception) {
                    result.error("FlutterDocumentScanner-Error", "Android: " + e.message, e)
                }
            }

            "applyFilter" -> {
                try {
                    OpenCVPlugin.applyFilter(
                        result,
                        call.argument<ByteArray>("byteData") as ByteArray,
                        call.argument<List<Map<String, Any>>>("filter") as String
                    )
                } catch (e: Exception) {
                    result.error("FlutterDocumentScanner-Error", "Android: " + e.message, e)
                }
            }


            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
