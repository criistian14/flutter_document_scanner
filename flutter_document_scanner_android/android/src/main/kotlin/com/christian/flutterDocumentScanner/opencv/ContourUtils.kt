package com.christian.flutterDocumentScanner.opencv

import org.opencv.core.*
import org.opencv.imgproc.Imgproc

object ContourUtils {
    fun findBiggestContour(src: Mat, minContourArea: Double): MatOfPoint? {
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

            if (approx.total()
                    .toInt() == 4 && isContour && isLessCurrentArea && isLessMaxArea
            ) {
                maxArea = Imgproc.contourArea(approx)
                documentContour = approx
            }
        }

        if (Imgproc.contourArea(documentContour) < minContourArea) {
            return null
        }

        return documentContour
    }

    fun getContourPoints(contour: MatOfPoint): List<Map<String, Any>> {
        val points = mutableListOf<Map<String, Any>>()

        points.add(
            mapOf(
                "x" to contour.toList()[0].x,
                "y" to contour.toList()[0].y
            )
        )
        points.add(
            mapOf(
                "x" to contour.toList()[3].x,
                "y" to contour.toList()[3].y
            )
        )
        points.add(
            mapOf(
                "x" to contour.toList()[2].x,
                "y" to contour.toList()[2].y
            )
        )
        points.add(
            mapOf(
                "x" to contour.toList()[1].x,
                "y" to contour.toList()[1].y
            )
        )

        return points
    }

    fun mapPointsToContour(points: List<Map<String, Any>>): MatOfPoint {
        return MatOfPoint(
            Point(points[0]["x"] as Double, points[0]["y"] as Double),
            Point(points[1]["x"] as Double, points[1]["y"] as Double),
            Point(points[2]["x"] as Double, points[2]["y"] as Double),
            Point(points[3]["x"] as Double, points[3]["y"] as Double)
        )
    }
}
