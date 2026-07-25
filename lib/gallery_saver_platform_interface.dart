import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gallery_saver_method_channel.dart';

abstract class GallerySaverPlatform extends PlatformInterface {
  /// Constructs a GallerySaverPlatform.
  GallerySaverPlatform() : super(token: _token);

  static final Object _token = Object();

  static GallerySaverPlatform _instance = MethodChannelGallerySaver();

  /// The default instance of [GallerySaverPlatform] to use.
  ///
  /// Defaults to [MethodChannelGallerySaver].
  static GallerySaverPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GallerySaverPlatform] when
  /// they register themselves.
  static set instance(GallerySaverPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
