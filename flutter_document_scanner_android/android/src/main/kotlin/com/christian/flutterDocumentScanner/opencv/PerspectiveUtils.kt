package com.christian.flutterDocumentScanner.opencv

import org.opencv.core.*
import org.opencv.imgproc.Imgproc

object PerspectiveUtils {
    fun warpPerspective(src: Mat, contour: MatOfPoint): Mat {
        val srcContour = MatOfPoint2f(
            Point(0.0, 0.0),
            Point((src.width() - 1).toDouble(), 0.0),
            Point((src.width() - 1).toDouble(), (src.height() - 1).toDouble()),
            Point(0.0, (src.height() - 1).toDouble())
        )

        val dstContour = MatOfPoint2f(
            contour.toList()[0],
            contour.toList()[1],
            contour.toList()[2],
            contour.toList()[3]
        )
        val warpMat = Imgproc.getPerspectiveTransform(dstContour, srcContour)

        val dst = Mat()
        Imgproc.warpPerspective(src, dst, warpMat, src.size())

        return dst
    }
}
