package com.christian.flutter_document_scanner

import android.util.Log
import io.flutter.plugin.common.MethodChannel
import org.opencv.core.*
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc


class OpenCVPlugin {
    companion object {
        fun findContourPhoto(byteData: ByteArray, result: MethodChannel.Result) {
            try {
                val src = Imgcodecs.imdecode(MatOfByte(*byteData), Imgcodecs.IMREAD_UNCHANGED)

                val documentContour = findBiggestContour(src)


                // Scalar -> RGB(235, 228, 44)
                Imgproc.drawContours(src, listOf(documentContour), -1, Scalar(44.0, 228.0, 235.0), 10)
//                val imgWithPerspective = warpPerspective(src, documentContour)


                // Instantiating an empty MatOfByte class
                val matOfByte = MatOfByte()

                // Converting the Mat object to MatOfByte
//                Imgcodecs.imencode(".jpg", dstEnd, matOfByte)
                Imgcodecs.imencode(".jpg", src, matOfByte)
//                Imgcodecs.imencode(".jpg", imgWithPerspective, matOfByte)
                val byteArray: ByteArray = matOfByte.toArray()


                val points = mutableListOf<Map<String, Any>>()
                points.add(
                    mapOf(
                        "x" to documentContour.toList()[0].x,
                        "y" to documentContour.toList()[0].y
                    )
                )
                points.add(
                    mapOf(
                        "x" to documentContour.toList()[3].x,
                        "y" to documentContour.toList()[3].y
                    )
                )
                points.add(
                    mapOf(
                        "x" to documentContour.toList()[2].x,
                        "y" to documentContour.toList()[2].y
                    )
                )
                points.add(
                    mapOf(
                        "x" to documentContour.toList()[1].x,
                        "y" to documentContour.toList()[1].y
                    )
                )

                val resultEnd = mapOf(
                    "height" to documentContour.height(),
                    "width" to documentContour.width(),
                    "points" to points,
                    "image" to byteArray
                )

                result.success(resultEnd)

            } catch (e: java.lang.Exception) {
                result.error("FlutterDocumentScanner-Error", "Android: " + e.message, e)
            }
        }

        private fun findBiggestContour(src: Mat): MatOfPoint {
            // Converting to RGB from BGR
            val dstColor = Mat()
            Imgproc.cvtColor(src, dstColor, Imgproc.COLOR_BGR2RGB)

            // Converting to gray
            Imgproc.cvtColor(dstColor, dstColor, Imgproc.COLOR_BGR2GRAY)

            // Applying blur and threshold
            val dstBilateral = Mat()
            Imgproc.bilateralFilter(dstColor, dstBilateral, 9, 75.0, 75.0, Core.BORDER_DEFAULT)
            Imgproc.adaptiveThreshold(
                dstBilateral,
                dstBilateral,
                255.0,
                Imgproc.ADAPTIVE_THRESH_GAUSSIAN_C,
                Imgproc.THRESH_BINARY,
                115,
                4.0
            )

            // Median blur replace center pixel by median of pixels under kernel
            val dstBlur = Mat()
            Imgproc.GaussianBlur(dstBilateral, dstBlur, Size(5.0, 5.0), 0.0)
            Imgproc.medianBlur(dstBlur, dstBlur, 11)


            val dstBorder = Mat()
            Core.copyMakeBorder(dstBlur, dstBorder, 5, 5, 5, 5, Core.BORDER_CONSTANT)


            val dstCanny = Mat()
            Imgproc.Canny(dstBorder, dstCanny, 75.0, 200.0)

            // Close gaps between edges (double page clouse => rectangle kernel)
            val dstEnd = Mat()
            Imgproc.morphologyEx(
                dstCanny,
                dstEnd,
                Imgproc.MORPH_CLOSE,
                Mat.ones(intArrayOf(5, 11), CvType.CV_32F)
            )


            // Getting contours
            val contours = mutableListOf<MatOfPoint>()
            val hierarchy = Mat()
            Imgproc.findContours(
                dstEnd,
                contours,
                hierarchy,
                Imgproc.RETR_TREE,
                Imgproc.CHAIN_APPROX_SIMPLE
            )
            hierarchy.release()

            // Finding the biggest rectangle otherwise return original corners
            val height = dstEnd.height()
            val width = dstEnd.width()
            val maxContourArea = (width - 10) * (height - 10)

            var maxArea = 0.0
            var documentContour = MatOfPoint()

            for (contour in contours) {
                val contour2f = MatOfPoint2f()
                contour.convertTo(contour2f, CvType.CV_32FC2)
                val perimeter = Imgproc.arcLength(contour2f, true)

                val approx2f = MatOfPoint2f()
                Imgproc.approxPolyDP(contour2f, approx2f, 0.03 * perimeter, true)

                // Page has 4 corners and it is convex
                val approx = MatOfPoint()
                approx2f.convertTo(approx, CvType.CV_32S)
                val isContour = Imgproc.isContourConvex(approx)
                val isLessCurrentArea = Imgproc.contourArea(approx) > maxArea
                val isLessMaxArea = maxArea < maxContourArea

                //
                Log.i(FlutterDocumentScannerPlugin.TAG, "---------------------")
                Log.i(FlutterDocumentScannerPlugin.TAG, "Max Area: $maxArea")
                Log.i(FlutterDocumentScannerPlugin.TAG, "ESQUINAS: ${approx.total().toInt()}")
                Log.i(FlutterDocumentScannerPlugin.TAG, "---------------------")




                if (approx.total().toInt() == 4 && isContour && isLessCurrentArea && isLessMaxArea) {
                    maxArea = Imgproc.contourArea(approx)
                    documentContour = approx
                }
            }

            return documentContour
        }

        private fun warpPerspective(src: Mat, documentContour: MatOfPoint): Mat {
            val srcContour = MatOfPoint2f(
                Point(0.0, 0.0),
                Point((src.width() - 1).toDouble(), 0.0),
                Point((src.width() - 1).toDouble(), (src.height() - 1).toDouble()),
                Point(0.0, (src.height() - 1).toDouble())
            )


            val dstContour = MatOfPoint2f(
                documentContour.toList()[0],
                documentContour.toList()[3],
                documentContour.toList()[2],
                documentContour.toList()[1]
            )
            val warpMat = Imgproc.getPerspectiveTransform(dstContour, srcContour)

            val dstWarPerspective = Mat()
            Imgproc.warpPerspective(src, dstWarPerspective, warpMat, src.size())

            return dstWarPerspective
        }
    }
}