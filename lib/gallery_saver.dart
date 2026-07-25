import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:gallery_saver/files.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/// Provides capabilities to persist images and videos to local device storage,
/// specifically the Android Gallery and iOS Photos albums.
class GallerySaver {
  /// Name of the primary method channel communicating with native platform implementations.
  static const String channelName = 'gallery_saver';
  static const String methodSaveImage = 'saveImage';
  static const String methodSaveVideo = 'saveVideo';

  static const String pleaseProvidePath = 'Please provide a valid file path.';
  static const String fileIsNotVideo =
      'The file at the provided path is not a recognized video format.';
  static const String fileIsNotImage =
      'The file at the provided path is not a recognized image format.';

  static const MethodChannel _channel = MethodChannel(channelName);

  /// Saves a video from the specified [path] to the device gallery or media store.
  ///
  /// The [path] parameter can be either a local filesystem path or an HTTP/HTTPS URL.
  /// When an album name is specified via [albumName], the file will be placed inside that album or directory.
  /// If [toDcim] is set to true on Android, the media is written directly to the DCIM system folder.
  /// Optional HTTP [headers] may be provided if downloading a network resource requiring custom authentication or routing.
  ///
  /// Returns a [Future] completing with [true] upon successful storage, or [false] otherwise.
  /// Throws an [ArgumentError] if the path is empty or does not correspond to a valid video format.
  static Future<bool?> saveVideo(
    String path, {
    String? albumName,
    bool toDcim = false,
    Map<String, String>? headers,
  }) async {
    if (path.isEmpty) {
      throw ArgumentError(pleaseProvidePath);
    }
    if (!isVideo(path)) {
      throw ArgumentError(fileIsNotVideo);
    }

    File? tempFile;
    String targetPath = path;
    try {
      if (!isLocalFilePath(path)) {
        tempFile = await _downloadFile(path, headers: headers);
        targetPath = tempFile.path;
      }
      final bool? result = await _channel.invokeMethod<bool>(
        methodSaveVideo,
        <String, dynamic>{
          'path': targetPath,
          'albumName': albumName,
          'toDcim': toDcim,
        },
      );
      return result;
    } finally {
      if (tempFile != null && await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }

  /// Saves an image from the specified [path] to the device gallery or media store.
  ///
  /// The [path] parameter can be either a local filesystem path or an HTTP/HTTPS URL.
  /// When an album name is specified via [albumName], the file will be placed inside that album or directory.
  /// If [toDcim] is set to true on Android, the media is written directly to the DCIM system folder.
  /// Optional HTTP [headers] may be provided if downloading a network resource requiring custom authentication or routing.
  ///
  /// Returns a [Future] completing with [true] upon successful storage, or [false] otherwise.
  /// Throws an [ArgumentError] if the path is empty or does not correspond to a valid image format.
  static Future<bool?> saveImage(
    String path, {
    String? albumName,
    bool toDcim = false,
    Map<String, String>? headers,
  }) async {
    if (path.isEmpty) {
      throw ArgumentError(pleaseProvidePath);
    }
    if (!isImage(path)) {
      throw ArgumentError(fileIsNotImage);
    }

    File? tempFile;
    String targetPath = path;
    try {
      if (!isLocalFilePath(path)) {
        tempFile = await _downloadFile(path, headers: headers);
        targetPath = tempFile.path;
      }

      final bool? result = await _channel.invokeMethod<bool>(
        methodSaveImage,
        <String, dynamic>{
          'path': targetPath,
          'albumName': albumName,
          'toDcim': toDcim,
        },
      );
      return result;
    } finally {
      if (tempFile != null && await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }

  /// Downloads a file from the remote network [url] into a temporary directory on the host device.
  ///
  /// Throws an [HttpException] if the network response indicates an HTTP error code (400 or higher).
  static Future<File> _downloadFile(
    String url, {
    Map<String, String>? headers,
  }) async {
    final http.Client client = http.Client();
    try {
      final Uri uri = Uri.parse(url);
      final http.Response req = await client.get(uri, headers: headers);
      if (req.statusCode >= 400) {
        throw HttpException(
          'Failed to download media: HTTP ${req.statusCode}',
          uri: uri,
        );
      }
      final Uint8List bytes = req.bodyBytes;
      final String dir = (await getTemporaryDirectory()).path;

      String fileName = uri.pathSegments.isNotEmpty
          ? uri.pathSegments.last
          : 'downloaded_media';
      if (fileName.isEmpty || !fileName.contains('.')) {
        fileName = basename(url).split('?').first;
      }

      final File file = File('$dir/$fileName');
      await file.writeAsBytes(bytes);
      return file;
    } finally {
      client.close();
    }
  }
}
