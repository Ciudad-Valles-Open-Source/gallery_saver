import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gallery_saver_example/main.dart';

void main() {
  testWidgets(
    'Verify presentation of all demonstration actions in widget tree',
    (WidgetTester tester) async {
      await tester.pumpWidget(const GallerySaverExampleApp());

      expect(find.text('Gallery Saver Demonstration'), findsOneWidget);

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
    },
  );
}
