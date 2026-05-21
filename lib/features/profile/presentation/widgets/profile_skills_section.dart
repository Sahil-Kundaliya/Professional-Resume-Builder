import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < item.rating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: Colors.amber.shade700,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
