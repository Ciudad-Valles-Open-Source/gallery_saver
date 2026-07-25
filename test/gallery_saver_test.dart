import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_saver/gallery_saver.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('gallery_saver');
  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);
          switch (methodCall.method) {
            case 'saveImage':
              return true;
            case 'saveVideo':
              return false;
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('Input Validation Tests', () {
    test('throws ArgumentError when saving image with empty path', () async {
      expect(
        () => GallerySaver.saveImage(''),
        throwsA(
          isA<ArgumentError>().having(
            (ArgumentError e) => e.message,
            'message',
            GallerySaver.pleaseProvidePath,
          ),
        ),
      );
    });

    test('throws ArgumentError when saving video with empty path', () async {
      expect(
        () => GallerySaver.saveVideo(''),
        throwsA(
          isA<ArgumentError>().having(
            (ArgumentError e) => e.message,
            'message',
            GallerySaver.pleaseProvidePath,
          ),
        ),
      );
    });

    test(
      'throws ArgumentError when saveImage path lacks valid image extension',
      () async {
        expect(
          () => GallerySaver.saveImage('/storage/emulated/0/file.txt'),
          throwsA(
            isA<ArgumentError>().having(
              (ArgumentError e) => e.message,
              'message',
              GallerySaver.fileIsNotImage,
            ),
          ),
        );
      },
    );

    test(
      'throws ArgumentError when saveVideo path lacks valid video extension',
      () async {
        expect(
          () => GallerySaver.saveVideo('/storage/emulated/0/file.pdf'),
          throwsA(
            isA<ArgumentError>().having(
              (ArgumentError e) => e.message,
              'message',
              GallerySaver.fileIsNotVideo,
            ),
          ),
        );
      },
    );
  });

  group('MethodChannel Invocation Tests', () {
    test('saveImage calls correct method and passes parameters', () async {
      final bool? result = await GallerySaver.saveImage(
        '/storage/emulated/image.jpg',
        albumName: 'TestAlbum',
        toDcim: true,
      );

      expect(result, isTrue);
      expect(log, hasLength(1));
      expect(log.first.method, 'saveImage');
      expect(log.first.arguments, <String, dynamic>{
        'path': '/storage/emulated/image.jpg',
        'albumName': 'TestAlbum',
        'toDcim': true,
      });
    });

    test('saveVideo calls correct method and passes parameters', () async {
      final bool? result = await GallerySaver.saveVideo(
        '/storage/emulated/video.mov',
        albumName: 'MyVideos',
        toDcim: false,
      );

      expect(result, isFalse);
      expect(log, hasLength(1));
      expect(log.first.method, 'saveVideo');
      expect(log.first.arguments, <String, dynamic>{
        'path': '/storage/emulated/video.mov',
        'albumName': 'MyVideos',
        'toDcim': false,
      });
    });
  });
}
