package com.christian.flutterDocumentScanner.opencv

import com.christian.flutterDocumentScanner.FilterType
import org.opencv.core.*
import org.opencv.imgproc.Imgproc

object FilterUtils {
    fun applyFilter(src: Mat, filterType: FilterType): Mat {
        val dst = Mat()

        when (filterType) {
            FilterType.NATURAL -> src.copyTo(dst)

            FilterType.GRAY -> Imgproc.cvtColor(src, dst, Imgproc.COLOR_BGR2GRAY)

            FilterType.ECO -> {
                val gray = Mat()
                Imgproc.cvtColor(src, gray, Imgproc.COLOR_BGR2GRAY)

                val dstGaussian = Mat()
                Imgproc.GaussianBlur(gray, dstGaussian, Size(3.0, 3.0), 0.0)

                val dstThreshold = Mat()
                Imgproc.adaptiveThreshold(
                    dstGaussian,
                    dstThreshold,
                    255.0,
                    Imgproc.ADAPTIVE_THRESH_GAUSSIAN_C,
                    Imgproc.THRESH_BINARY,
                    7,
                    2.0
                )

                Imgproc.medianBlur(dstThreshold, dst, 3)
            }
        }

        return dst
    }
}
