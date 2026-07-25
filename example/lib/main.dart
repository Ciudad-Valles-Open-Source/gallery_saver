import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GallerySaverExampleApp());
}

/// The root application widget demonstrating the features of [GallerySaver].
class GallerySaverExampleApp extends StatelessWidget {
  const GallerySaverExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery Saver Demonstration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const GallerySaverDemoScreen(),
    );
  }
}

/// Main stateful widget managing user interactions and media persistence operations.
class GallerySaverDemoScreen extends StatefulWidget {
  const GallerySaverDemoScreen({super.key});

  @override
  State<GallerySaverDemoScreen> createState() => _GallerySaverDemoScreenState();
}

class _GallerySaverDemoScreenState extends State<GallerySaverDemoScreen> {
  static const String _albumName = 'Media';
  bool _isProcessing = false;

  /// Displays a standardized notification snackbar to provide operational feedback.
  void _showNotification(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Wraps asynchronous operations with a modal progress indicator to prevent concurrent interactions.
  Future<void> _processAction(Future<void> Function() action) async {
    setState(() => _isProcessing = true);
    try {
      await action();
    } catch (e) {
      _showNotification('Operation encountered an error: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  /// Captures a photograph using the device camera and persists it into the target album.
  void _takePhoto() {
    _processAction(() async {
      final XFile? recordedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (recordedImage != null) {
        _showNotification('Saving captured photograph...');
        final bool? success = await GallerySaver.saveImage(
          recordedImage.path,
          albumName: _albumName,
        );
        _showNotification(
          success == true
              ? 'Photograph successfully stored in gallery.'
              : 'Failed to save photograph.',
        );
      }
    });
  }

  /// Records a video using the device camera and persists it into the target album.
  void _recordVideo() {
    _processAction(() async {
      final XFile? recordedVideo = await ImagePicker().pickVideo(
        source: ImageSource.camera,
      );
      if (recordedVideo != null) {
        _showNotification('Saving recorded video...');
        final bool? success = await GallerySaver.saveVideo(
          recordedVideo.path,
          albumName: _albumName,
        );
        _showNotification(
          success == true
              ? 'Video successfully stored in gallery.'
              : 'Failed to save video.',
        );
      }
    });
  }

  /// Downloads a remote video asset and saves it directly to local external storage.
  void _saveNetworkVideo() {
    _processAction(() async {
      const String remotePath =
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
      _showNotification('Downloading and saving remote video resource...');
      final bool? success = await GallerySaver.saveVideo(
        remotePath,
        albumName: _albumName,
      );
      _showNotification(
        success == true
            ? 'Remote video successfully stored in gallery.'
            : 'Failed to save remote video.',
      );
    });
  }

  /// Downloads a remote image asset and saves it directly to local external storage.
  void _saveNetworkImage() {
    _processAction(() async {
      const String remotePath =
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg';
      _showNotification('Downloading and saving remote image resource...');
      final bool? success = await GallerySaver.saveImage(
        remotePath,
        albumName: _albumName,
      );
      _showNotification(
        success == true
            ? 'Remote image successfully stored in gallery.'
            : 'Failed to save remote image.',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery Saver Demonstration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 1,
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              ActionCard(
                key: const Key('btn_take_photo'),
                icon: Icons.camera_alt,
                title: 'Take Photo',
                subtitle:
                    'Launch camera, capture a photo, and persist to gallery',
                onTap: _takePhoto,
              ),
              const SizedBox(height: 12),
              ActionCard(
                key: const Key('btn_record_video'),
                icon: Icons.videocam,
                title: 'Record Video',
                subtitle:
                    'Launch camera, record a video, and persist to gallery',
                onTap: _recordVideo,
              ),
              const SizedBox(height: 12),
              const ScreenshotWidget(key: Key('btn_screenshot')),
              const SizedBox(height: 12),
              ActionCard(
                key: const Key('btn_network_image'),
                icon: Icons.image,
                title: 'Save Network Image',
                subtitle:
                    'Download a public sample image over HTTP and save to gallery',
                onTap: _saveNetworkImage,
              ),
              const SizedBox(height: 12),
              ActionCard(
                key: const Key('btn_network_video'),
                icon: Icons.ondemand_video,
                title: 'Save Network Video',
                subtitle:
                    'Download a public sample video over HTTP and save to gallery',
                onTap: _saveNetworkVideo,
              ),
            ],
          ),
          if (_isProcessing)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

/// A standardized interactive card component displaying an icon, title, and action summary.
class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget encapsulating a [RepaintBoundary] to demonstrate generating and persisting screen capture images.
class ScreenshotWidget extends StatefulWidget {
  const ScreenshotWidget({super.key});

  @override
  State<ScreenshotWidget> createState() => _ScreenshotWidgetState();
}

class _ScreenshotWidgetState extends State<ScreenshotWidget> {
  final GlobalKey _boundaryKey = GlobalKey();

  Future<void> _saveScreenshot() async {
    final ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(
      context,
    );

    try {
      final RenderRepaintBoundary? boundary =
          _boundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception(
          'RenderRepaintBoundary could not be resolved from context.',
        );
      }

      // Ensure painting cycle completes before attempting extraction to avoid debugNeedsPaint assertions.
      if (boundary.debugNeedsPaint) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final Uint8List? pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes == null) {
        throw Exception('Failed to encode image raster to PNG buffer.');
      }

      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Processing and storing screenshot...'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String fullPath =
          '$dir/capture_${DateTime.now().millisecondsSinceEpoch}.png';
      final File capturedFile = File(fullPath);
      await capturedFile.writeAsBytes(pngBytes);
      debugPrint('Temporary screenshot stored at: ${capturedFile.path}');

      final bool? success = await GallerySaver.saveImage(capturedFile.path);

      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            success == true
                ? 'Screenshot successfully stored in gallery.'
                : 'Failed to store screenshot in gallery.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint('Screenshot execution failed: $e');
      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Screenshot operation encountered an error: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _boundaryKey,
      child: ActionCard(
        icon: Icons.screenshot,
        title: 'Save Screenshot',
        subtitle:
            'Capture internal widget view hierarchy and persist to gallery',
        onTap: _saveScreenshot,
      ),
    );
  }
}
