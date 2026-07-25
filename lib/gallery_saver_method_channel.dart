import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gallery_saver_platform_interface.dart';

/// An implementation of [GallerySaverPlatform] that uses method channels.
class MethodChannelGallerySaver extends GallerySaverPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('gallery_saver');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
