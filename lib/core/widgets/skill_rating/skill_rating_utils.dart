import 'package:flutter/material.dart';

const int kMinSkillRating = 1;
const int kMaxSkillRating = 5;
const int kDefaultSkillRating = 3;

class SkillRatingDraft {
  const SkillRatingDraft({
    required this.name,
    required this.rating,
  });

  final String name;
  final int rating;
}

int clampSkillRating(int? rating) {
  final value = rating ?? kDefaultSkillRating;
  if (value < kMinSkillRating) {
    return kMinSkillRating;
  }
  if (value > kMaxSkillRating) {
    return kMaxSkillRating;
  }
  return value;
}

String skillRatingLabel(int rating) {
  final normalized = clampSkillRating(rating);
  if (normalized <= 1) {
    return 'Beginner';
  }
  if (normalized == 2) {
    return 'Beginner+';
  }
  if (normalized == 3) {
    return 'Intermediate';
  }
  if (normalized == 4) {
    return 'Advanced';
  }
  return 'Expert';
}

List<Icon> buildSkillRatingStars(
  int rating, {
  double size = 18,
  Color? filledColor,
  Color? emptyColor,
}) {
  final normalized = clampSkillRating(rating);
  final activeColor = filledColor ?? Colors.amber.shade700;
  final inactiveColor = emptyColor ?? Colors.grey.shade400;

  return List.generate(
    kMaxSkillRating,
    (index) => Icon(
      index < normalized ? Icons.star_rounded : Icons.star_border_rounded,
      color: index < normalized ? activeColor : inactiveColor,
      size: size,
    ),
  );
}
