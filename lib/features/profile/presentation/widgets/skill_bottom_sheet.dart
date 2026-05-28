import 'package:flutter/material.dart';

import '../../../../core/widgets/skill_rating/skill_rating.dart';
import '../../domain/entities/resume_profile.dart';

class SkillBottomSheet {
  static Future<ProfileSkill?> show(
    BuildContext context, {
    ProfileSkill? initialSkill,
  }) {
    return SkillRatingBottomSheet.show(
      context,
      initialName: initialSkill?.name ?? '',
      initialRating: initialSkill?.rating ?? kDefaultSkillRating,
      title: initialSkill == null ? 'Add skill' : 'Edit skill',
      nameLabel: 'Skill title',
      saveLabel: initialSkill == null ? 'Add skill' : 'Save skill',
    ).then(
      (result) => result == null
          ? null
          : ProfileSkill(name: result.name, rating: result.rating),
    );
  }
}
