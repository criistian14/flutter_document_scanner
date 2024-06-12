## 1.1.2
* Adds compatibility with Android Gradle Plugin 8.0, by adding a namespace to the build.gradle. (thanks [@mvanbeusekom](https://github.com/mvanbeusekom) [#11](https://github.com/criistian14/flutter_document_scanner/pull/11))

## 1.1.1
* Fix error when initializing the camera in the build, so now it is initialized in the initState to only call it once.
* Prevent streams from reporting repeated data consecutively.
* Increased default dot size from 18 to 24.

## 1.1.0
* Added `findContoursFromExternalImage` and example to use it
* Added `dispose` method to `DocumentScannerController` to close cameraController
* Upgrade Android SDK to 33, gradle to 7.3.0 and kotlin to 1.8.20

## 1.0.0
* Stable version with basic functionality and new structure 

## 0.1.0

* Removing packages and adjusting opencv functionality (findContours)

## 0.0.1

* Initial release.