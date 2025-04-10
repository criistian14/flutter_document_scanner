package com.christian.flutterDocumentScanner

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.christian.flutterDocumentScanner.opencv.OpenCVPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.opencv.android.OpenCVLoader


class FlutterDocumentScannerPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var openCVInitialized = false

    companion object {
        const val TAG = "com.christian.Log.Tag"
        const val PLUGIN_ID = "flutter_document_scanner_android"
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, PLUGIN_ID)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext

        // Initialize OpenCV
        if (!openCVInitialized && OpenCVLoader.initDebug()) {
            openCVInitialized = true
            Log.i(TAG, "OpenCV loaded successfully")
        } else {
            Log.e(TAG, "Failed to initialize OpenCV")
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (!openCVInitialized) {
            result.error("OPENCV_INIT_ERROR", "OpenCV is not initialized.", null)
            return
        }

        try {
            when (call.method) {
                "findContourPhoto" -> handleFindContourPhoto(call, result)
                "adjustingPerspective" -> handleAdjustingPerspective(call, result)
                "applyFilter" -> handleApplyFilter(call, result)
                
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error in method ${call.method}: ${e.message}", e)
            result.error("METHOD_CALL_ERROR", "Error during '${call.method}': ${e.message}", null)
        }
    }

    private fun handleFindContourPhoto(call: MethodCall, result: Result) {
        val byteData = call.argument<ByteArray>("byteData")
        val minContourArea = call.argument<Double>("minContourArea") ?: 0.0

        if (byteData == null || byteData.isEmpty()) {
            result.error("INVALID_BYTE_DATA", "Byte data is null or empty.", null)
            return
        }

        OpenCVPlugin.findContourPhoto(result, byteData, minContourArea)
    }

    private fun handleAdjustingPerspective(call: MethodCall, result: Result) {
        val byteData = call.argument<ByteArray>("byteData")
        val points = call.argument<List<Map<String, Any>>>("points")

        if (byteData == null || byteData.isEmpty() || points == null || points.size != 4) {
            result.error(
                "INVALID_PARAMETERS",
                "Byte data is null or empty, or points are invalid. Ensure byte data is not empty and points contain exactly 4 items.",
                null
            )
            return
        }

        OpenCVPlugin.adjustingPerspective(byteData, points, result)
    }

    private fun handleApplyFilter(call: MethodCall, result: Result) {
        val byteData = call.argument<ByteArray>("byteData")
        val filter = call.argument<String>("filter")

        if (byteData == null || byteData.isEmpty()) {
            result.error("INVALID_BYTE_DATA", "Byte data is null or empty.", null)
            return
        }

        if (filter.isNullOrBlank()) {
            result.error("UNSUPPORTED_FILTER_TYPE", "The provided filter type is null or unsupported.", null)
            return
        }

        OpenCVPlugin.applyFilter(result, byteData, filter)
    }
}
