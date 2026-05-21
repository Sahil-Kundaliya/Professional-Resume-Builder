import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/resume_profile.dart';
import 'profile_section_card.dart';
import 'profile_section_header.dart';

class ProfileHobbiesSection extends StatelessWidget {
  const ProfileHobbiesSection({super.key, required this.hobbies});

  final List<ProfileHobby> hobbies;

  @override
  Widget build(BuildContext context) {
    final items = hobbies.where((h) => h.name.trim().isNotEmpty).toList();
    if (items.isEmpty) return const SizedBox.shrink();

    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(title: 'Hobbies'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: items
                .map(
                  (h) => Chip(
                    label: Text(
                      h.name,
                      style: GoogleFonts.inter(fontSize: 13),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
