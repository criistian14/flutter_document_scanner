package com.christian.flutterDocumentScanner

import android.util.Log
import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.opencv.android.OpenCVLoader


class FlutterDocumentScannerPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var openCVFLag = false

    companion object {
        const val TAG = "com.christian.Log.Tag"
        const val PLUGIN_ID = "flutter_document_scanner_android"
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, PLUGIN_ID)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (!openCVFLag) {
            if (!OpenCVLoader.initDebug()) {
                Log.i(TAG, "Unable to load OpenCV")
            } else {
                openCVFLag = true
                Log.i(TAG, "OpenCV loaded Successfully")
            }
        }


        when (call.method) {
            "findContourPhoto" -> {
                try {
                    OpenCVPlugin.findContourPhoto(
                        result,
                        call.argument<ByteArray>("byteData") as ByteArray,
                        call.argument<Double>("minContourArea") as Double
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
                        call.argument<Int>("filter") as Int
                    )
                } catch (e: Exception) {
                    result.error("FlutterDocumentScanner-Error", "Android: " + e.message, e)
                }
            }


            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }
}
