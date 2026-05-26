import 'package:flutter_test/flutter_test.dart';

Future<void> pumpEditorFrame(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 16));
}
