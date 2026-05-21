import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/resume_profile.dart';
import 'profile_section_card.dart';
import 'profile_section_date_formatter.dart';
import 'profile_section_header.dart';

class ProfileExperienceSection extends StatelessWidget {
  const ProfileExperienceSection({super.key, required this.experiences});

  final List<ProfileExperience> experiences;

  @override
  Widget build(BuildContext context) {
    if (experiences.isEmpty) return const SizedBox.shrink();

    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(title: 'Experience'),
          const SizedBox(height: 12),
          ...experiences.map((item) => _ExperienceTile(item: item)),
        ],
      ),
    );
  }
}

class _ExperienceTile extends StatelessWidget {
  const _ExperienceTile({required this.item});

  final ProfileExperience item;

  @override
  Widget build(BuildContext context) {
    final dateRange =
        ProfileSectionDateFormatter.formatRange(item.startDate, item.endDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.position,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.companyName,
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade700),
          ),
          if (dateRange.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              dateRange,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
          if (item.detailLines.isNotEmpty) ...[
            const SizedBox(height: 6),
            ...item.detailLines.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, right: 6),
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        line,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
