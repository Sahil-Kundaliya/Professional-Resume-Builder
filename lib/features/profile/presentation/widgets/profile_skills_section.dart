import 'package:flutter/material.dart';

import '../../../../core/widgets/skill_rating/skill_rating.dart';
import '../../domain/entities/resume_profile.dart';
import 'profile_section_card.dart';
import 'profile_section_header.dart';

class ProfileSkillsSection extends StatelessWidget {
  const ProfileSkillsSection({super.key, required this.skills});

  final List<ProfileSkill> skills;

  @override
  Widget build(BuildContext context) {
    final items = skills.where((item) => item.name.trim().isNotEmpty).toList();
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(title: 'Skills'),
          const SizedBox(height: 12),
          ...items.map(
            (item) => SkillRatingRow(
              name: item.name,
              rating: item.rating,
            ),
          ),
        ],
      ),
    );
  }
}
