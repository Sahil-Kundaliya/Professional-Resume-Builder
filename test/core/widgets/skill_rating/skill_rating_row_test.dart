import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:resume_builder/core/widgets/skill_rating/skill_rating.dart';

void main() {
  testWidgets('SkillRatingRow renders skill name, rating text, and stars',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SkillRatingRow(
            name: 'Dart',
            rating: 4,
          ),
        ),
      ),
    );

    expect(find.text('Dart'), findsOneWidget);
    expect(find.text('Expertise: Advanced (4/5)'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(4));
    expect(find.byIcon(Icons.star_border_rounded), findsOneWidget);
  });
}
