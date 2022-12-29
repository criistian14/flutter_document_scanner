import 'dart:io';
import 'dart:typed_data';

import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/opencv_4.dart';
import 'package:path_provider/path_provider.dart';

class DocumentUtils {
  static Future<Uint8List?> grayScale(Uint8List picture) async {
    final appDir = await getTemporaryDirectory();
    File pictureFile = File('${appDir.path}/${DateTime.now()}.jpg');
    await pictureFile.writeAsBytes(picture);

    var res = await Cv2.cvtColor(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: pictureFile.path,
      outputType: Cv2.COLOR_BGR2GRAY,
    );

    return res;
  }

  static Future<Uint8List?> eco(Uint8List picture) async {
    final appDir = await getTemporaryDirectory();
    File pictureFile = File('${appDir.path}/${DateTime.now()}.jpg');
    await pictureFile.writeAsBytes(picture);

    var res = await Cv2.gaussianBlur(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: pictureFile.path,
      kernelSize: [3, 3],
      sigmaX: 0,
    );

    if (res == null) return null;
    await pictureFile.writeAsBytes(res);

    res = await Cv2.adaptiveThreshold(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: pictureFile.path,
      maxValue: 255,
      adaptiveMethod: Cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
      thresholdType: Cv2.THRESH_BINARY,
      blockSize: 7,
      constantValue: 2,
    );

    if (res == null) return null;
    await pictureFile.writeAsBytes(res);

    res = await Cv2.medianBlur(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: pictureFile.path,
      kernelSize: 3,
    );

    return res;
  }
}
