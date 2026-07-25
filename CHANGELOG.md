# Changelog

## 2.5.0

* **Plugin Architecture & Logic Enhancements**:
  * Implemented safe HTTP client resource disposal and connection termination after remote media downloads to eliminate connection leaks.
  * Enforced structured `try-finally` cleanup for temporary downloading artifacts on storage exceptions.
  * Enhanced file extension parsing and verification logic in media validation helpers.
  * Added comprehensive formal DartDoc specifications across exported API methods, parameters, and utilities.
* **Testing & Quality Assurance**:
  * Modernized unit test mock implementations using binary messenger overrides, removing deprecated framework calls.
  * Added extensive validation tests covering empty paths, invalid formats, and parameter mappings.
  * Created automated acceptance and integration test suites (`app_test.dart`) for end-to-end interface verification in the example project.
* **Demonstration Application (Example) & Documentation**:
  * Redesigned the example application using Material 3 principles, modular interactive card components, and non-blocking notification feedback.
  * Resolved runtime assertion errors during screenshot image encoding by ensuring view rasterization cycles complete prior to frame capture.
  * Replaced unstable third-party sample network URLs with highly available official Flutter documentation endpoints.
  * Restored required native iOS privacy descriptions (`Info.plist`) and Android camera query intents (`AndroidManifest.xml`).
  * Modernized project readme with updated usage guidelines and Null Safety examples.

## 2.4.1

* Minor configuration updates and stability improvements.

## 2.4.0

* Updated Android Gradle Plugin to 8.5.1
* Updated Kotlin to 1.9.25
* Updated NDK version to 27.0.12077973
* Updated example project to use the latest dependencies
* Added namespace to Android project
* Fixed example project build issues

## 2.3.2

*Fixed - fix url error with query #146

## 2.3.1

*Fixed header for download file method

## 2.3.0

* fixed save video on Android SDK < 29 and ability to save media to DCIM

## 2.2.0

* Merged 3 community fixes

## 2.1.3

* Example project build fix and .3gpp video type supprted

## 2.1.2

* Supported SDK 30 and build fix

## 2.1.1

* Migrated to null safety

## 2.0.3

* Android - Invalid column

## 2.0.2

* Android 11 support

## 2.0.1

* Reverted PR for image validation

## 2.0.0

* Merged all PRs(image validation to native, error if image was selected twice, newest android and ios support)

## 1.0.7

* Fixed issue with improper mime types for video

## 1.0.6

* Ios save image to photos crash fix.

## 1.0.5

* Support saving images in separate folder in gallery
* Android:
* By default image will be saved at "pictures" system folder,
* and video at "movies" system folder.If user set folder name it will be
* at root external storage.
* iOS:
* By default image and video will be saved at photos.
* If user set folder name it will be added as new album at photos.

## 1.0.4

* Fixed bug with mime type on Android 10

## 1.0.3

* Remove deleting temp video after it gets saved into gallery

## 1.0.2

* Saving large video files - fix

## 1.0.1

* Changed description

## 1.0.0

* Support saving network images and videos to gallery

## 0.0.5

* Fix for colliding permission request with image_picker plugin

## 0.0.4

* Return type changed to bool(true for success and false for everything else)

## 0.0.3

* Fixed crash when requesting storage access on Android.

## 0.0.2

* Added swift version and changed description.

## 0.0.1

* Initial release. Image and video from provided temp path get saved to device(Gallery and Photos).
