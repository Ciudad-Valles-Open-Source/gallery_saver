# Gallery Saver for Flutter

A Flutter plugin designed to save images and videos from remote network sources or local temporary filesystem paths directly to internal external storage. Once saved, media items are immediately visible in the standard Android Gallery and iOS Photos application.

## Overview

- **Local & Network Support**: Accepts both local filesystem paths and HTTP/HTTPS network URLs.
- **Custom Album Management**: Optionally create and target customized albums or folders in system galleries.
- **Android DCIM Storage**: Support for directing stored media straight to the system DCIM directory on Android devices.
- **Custom Headers**: Ability to pass authorization or custom HTTP routing headers during remote media downloading.

---

## Installation

Add `gallery_saver` as a dependency in your project's `pubspec.yaml` file:

```yaml
dependencies:
  gallery_saver: ^2.5.0
```

---

## Platform Configuration

### iOS Configuration

Add the required privacy usage keys to your property list file located at `<project root>/ios/Runner/Info.plist`. Failure to declare these permissions will result in operating system exceptions when accessing media services:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>This application requires access to your photo library to save media items.</string>
<key>NSCameraUsageDescription</key>
<string>This application requires camera access to capture photos and videos.</string>
<key>NSMicrophoneUsageDescription</key>
<string>This application requires microphone access for audio recording during video capture.</string>
```

### Android Configuration

1. **Storage Permissions**:
For Android target SDKs requiring explicit external storage writes, ensure the appropriate permissions exist in `<project root>/android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

2. **Camera Intent Queries** *(Required for applications launching external cameras on Android 11+)*:
Add the following `<queries>` block inside your root `<manifest>` tag to enable interaction with system cameras:

```xml
<queries>
    <intent>
        <action android:name="android.media.action.IMAGE_CAPTURE" />
    </intent>
</queries>
```

---

## Usage Example

Below is a complete, modern Flutter application example demonstrating local camera capturing, screenshot generation, and network media downloading using Material 3 design and Null Safety.

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MediaSaverApp());

class MediaSaverApp extends StatelessWidget {
  const MediaSaverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery Saver Example',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blueGrey),
      home: const MediaSaverHomeScreen(),
    );
  }
}

class MediaSaverHomeScreen extends StatefulWidget {
  const MediaSaverHomeScreen({super.key});

  @override
  State<MediaSaverHomeScreen> createState() => _MediaSaverHomeScreenState();
}

class _MediaSaverHomeScreenState extends State<MediaSaverHomeScreen> {
  final String _targetAlbum = 'MediaDemo';

  void _showNotice(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _captureAndSavePhoto() async {
    final XFile? photo = await ImagePicker().pickImage(source: ImageSource.camera);
    if (photo != null) {
      _showNotice('Saving photograph to gallery...');
      final bool? success = await GallerySaver.saveImage(photo.path, albumName: _targetAlbum);
      _showNotice(success == true ? 'Photograph saved successfully.' : 'Failed to save photograph.');
    }
  }

  Future<void> _downloadNetworkVideo() async {
    const String remoteUrl = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
    _showNotice('Downloading and saving remote video...');
    final bool? success = await GallerySaver.saveVideo(remoteUrl, albumName: _targetAlbum);
    _showNotice(success == true ? 'Video saved successfully.' : 'Failed to save video.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery Saver Implementation')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.camera),
              label: const Text('Capture and Save Photo'),
              onPressed: _captureAndSavePhoto,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.cloud_download),
              label: const Text('Download Network Video'),
              onPressed: _downloadNetworkVideo,
            ),
          ],
        ),
      ),
    );
  }
}
```