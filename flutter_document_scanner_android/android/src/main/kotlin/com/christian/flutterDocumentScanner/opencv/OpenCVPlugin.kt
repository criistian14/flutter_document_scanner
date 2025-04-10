package com.christian.flutterDocumentScanner.opencv

import com.christian.flutterDocumentScanner.FilterType
import io.flutter.plugin.common.MethodChannel

class OpenCVPlugin {
    companion object {

        fun findContourPhoto(
            result: MethodChannel.Result,
            byteData: ByteArray,
            minContourArea: Double
        ) {
            try {
                // Decode the image
                val src = ImgUtils.decodeImage(byteData)

                if (src.empty()) {
                    result.error("DECODE_ERROR", "Failed to decode the byte data.", null)
                    return
                }

                // Find the biggest contour
                val documentContour = ContourUtils.findBiggestContour(src, minContourArea)

                if (documentContour == null) {
                    result.success(null)
                    return
                }

                // TODO: Use for when to use real time transmission
                // Scalar -> RGB(235, 228, 44)
                // Imgproc.drawContours(src, listOf(documentContour), -1, Scalar(44.0, 228.0, 235.0), 10)

                // Encode the resulting image and points
                val encodedImage = ImgUtils.encodeImage(src)
                val points = ContourUtils.getContourPoints(documentContour)

                val resultEnd = mapOf(
                    "height" to src.height(),
                    "width" to src.width(),
                    "points" to points,
                    "image" to encodedImage
                )

                result.success(resultEnd)
            } catch (e: Exception) {
                result.error("CONTOUR_ERROR", "Error finding contour: ${e.message}", e)
            }
        }

        fun adjustingPerspective(
            byteData: ByteArray,
            points: List<Map<String, Any>>,
            result: MethodChannel.Result
        ) {
            try {
                // Decode the image
                val src = ImgUtils.decodeImage(byteData)

                if (src.empty()) {
                    result.error("DECODE_ERROR", "Failed to decode the byte data.", null)
                    return
                }

                // Map the points to MatOfPoint
                val documentContour = ContourUtils.mapPointsToContour(points)

                // Adjust the perspective
                val adjustedImage = PerspectiveUtils.warpPerspective(src, documentContour)

                // Encode the resulting image
                val encodedImage = ImgUtils.encodeImage(adjustedImage)

                result.success(encodedImage)
            } catch (e: Exception) {
                result.error("PERSPECTIVE_ERROR", "Error adjusting perspective: ${e.message}", e)
            }
        }

        fun applyFilter(
            result: MethodChannel.Result,
            byteData: ByteArray,
            filter: String
        ) {
            try {
                // Decode the image
                val src = ImgUtils.decodeImage(byteData)

                if (src.empty()) {
                    result.error("DECODE_ERROR", "Failed to decode the byte data.", null)
                    return
                }

                // Validate and apply the filter
                val filterType = FilterType.from(filter)
                val filteredImage = FilterUtils.applyFilter(src, filterType)

                // Encode the resulting image
                val encodedImage = ImgUtils.encodeImage(filteredImage)

                result.success(encodedImage)
            } catch (e: IllegalArgumentException) {
                result.error("UNSUPPORTED_FILTER_TYPE", "The filter type is unsupported: $filter", null)
            } catch (e: Exception) {
                result.error("FILTER_ERROR", "Error applying filter: ${e.message}", e)
            }
        }
    }
}
