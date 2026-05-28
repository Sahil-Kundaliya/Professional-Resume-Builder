import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:resume_builder/core/widgets/skill_rating/skill_rating.dart';

void main() {
  testWidgets('SkillRatingBottomSheet returns the entered skill and rating',
      (tester) async {
    SkillRatingDraft? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () async {
                  result = await SkillRatingBottomSheet.show(context);
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Flutter');
    await tester.tap(find.text('5').last);
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton).last);
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.name, 'Flutter');
    expect(result!.rating, 5);
  });
}
