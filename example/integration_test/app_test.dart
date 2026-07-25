import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_saver_example/main.dart' as app;
import 'package:integration_test/integration_test.dart';

/// Acceptance and Integration test suite for Gallery Saver demonstration app.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Acceptance and UI Structure Verification', () {
    testWidgets('Verify complete application layout and action cards rendering', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify the Application Header is present
      expect(find.text('Gallery Saver Demonstration'), findsOneWidget);

      // Verify all primary functional action cards are present by Key and Title
      expect(find.byKey(const Key('btn_take_photo')), findsOneWidget);
      expect(find.text('Take Photo'), findsOneWidget);

      expect(find.byKey(const Key('btn_record_video')), findsOneWidget);
      expect(find.text('Record Video'), findsOneWidget);

      expect(find.byKey(const Key('btn_screenshot')), findsOneWidget);
      expect(find.text('Save Screenshot'), findsOneWidget);

      expect(find.byKey(const Key('btn_network_image')), findsOneWidget);
      expect(find.text('Save Network Image'), findsOneWidget);

      expect(find.byKey(const Key('btn_network_video')), findsOneWidget);
      expect(find.text('Save Network Video'), findsOneWidget);
    });
  });

  group('Integration and Action Feedback Tests', () {
    testWidgets(
      'Verify interactive feedback when initiating network image download',
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        final Finder btnNetworkImage = find.byKey(
          const Key('btn_network_image'),
        );
        expect(btnNetworkImage, findsOneWidget);

        await tester.tap(btnNetworkImage);
        await tester
            .pump(); // Trigger immediate visual update for notification and modal loader.

        expect(
          find.text('Downloading and saving remote image resource...'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Verify interactive feedback when initiating network video download',
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        final Finder btnNetworkVideo = find.byKey(
          const Key('btn_network_video'),
        );
        expect(btnNetworkVideo, findsOneWidget);

        await tester.tap(btnNetworkVideo);
        await tester
            .pump(); // Trigger immediate visual update for notification and modal loader.

        expect(
          find.text('Downloading and saving remote video resource...'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Verify screenshot capture execution without debugNeedsPaint exceptions',
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        final Finder btnScreenshot = find.byKey(const Key('btn_screenshot'));
        expect(btnScreenshot, findsOneWidget);

        await tester.tap(btnScreenshot);
        // Advance execution slightly to allow RepaintBoundary rasterization
        await tester.pump(const Duration(milliseconds: 50));

        // Ensure no framework assertion or unhandled exceptions occurred and notification appears
        expect(
          find.text('Processing and storing screenshot...'),
          findsOneWidget,
        );
      },
    );
  });
}
