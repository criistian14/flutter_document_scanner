package com.christian.flutterDocumentScanner.opencv

import org.opencv.core.Mat
import org.opencv.core.MatOfByte
import org.opencv.imgcodecs.Imgcodecs

object ImgUtils {
    fun decodeImage(byteData: ByteArray): Mat {
        return Imgcodecs.imdecode(MatOfByte(*byteData), Imgcodecs.IMREAD_COLOR)
    }

    fun encodeImage(image: Mat): ByteArray {
        val matOfByte = MatOfByte()
        Imgcodecs.imencode(".jpg", image, matOfByte)

        return matOfByte.toArray()
    }
}
