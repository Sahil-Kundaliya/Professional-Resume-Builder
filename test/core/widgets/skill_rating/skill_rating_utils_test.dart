import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:resume_builder/core/widgets/skill_rating/skill_rating.dart';

void main() {
  test('clampSkillRating keeps ratings within the supported range', () {
    expect(clampSkillRating(null), kDefaultSkillRating);
    expect(clampSkillRating(0), kMinSkillRating);
    expect(clampSkillRating(1), 1);
    expect(clampSkillRating(3), 3);
    expect(clampSkillRating(5), 5);
    expect(clampSkillRating(9), kMaxSkillRating);
  });

  test('skillRatingLabel maps ratings to readable expertise labels', () {
    expect(skillRatingLabel(1), 'Beginner');
    expect(skillRatingLabel(2), 'Beginner+');
    expect(skillRatingLabel(3), 'Intermediate');
    expect(skillRatingLabel(4), 'Advanced');
    expect(skillRatingLabel(5), 'Expert');
  });

  test('buildSkillRatingStars returns five icons', () {
    final stars = buildSkillRatingStars(4);

    expect(stars, hasLength(5));
    expect(
        stars.where((icon) => icon.icon == Icons.star_rounded), hasLength(4));
    expect(
      stars.where((icon) => icon.icon == Icons.star_border_rounded),
      hasLength(1),
    );
  });
}
