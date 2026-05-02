import 'package:flutter_test/flutter_test.dart';

import 'package:fintrack/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FinTrackApp());

    // Verify that the title is present.
    expect(find.text('FinTrack'), findsWidgets);
  });
}
