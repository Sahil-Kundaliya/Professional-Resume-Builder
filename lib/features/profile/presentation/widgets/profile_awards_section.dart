import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/resume_profile.dart';
import 'profile_section_card.dart';
import 'profile_section_date_formatter.dart';
import 'profile_section_header.dart';

class ProfileAwardsSection extends StatelessWidget {
  const ProfileAwardsSection({super.key, required this.awards});

  final List<ProfileAward> awards;

  @override
  Widget build(BuildContext context) {
    if (awards.isEmpty) return const SizedBox.shrink();

    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(title: 'Awards'),
          const SizedBox(height: 12),
          ...awards.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (item.date != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      ProfileSectionDateFormatter.format(item.date),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
