import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/resume_profile.dart';
import 'profile_section_card.dart';
import 'profile_section_date_formatter.dart';
import 'profile_section_header.dart';

class ProfileEducationSection extends StatelessWidget {
  const ProfileEducationSection({super.key, required this.educationRecords});

  final List<ProfileEducation> educationRecords;

  @override
  Widget build(BuildContext context) {
    if (educationRecords.isEmpty) return const SizedBox.shrink();

    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(title: 'Education'),
          const SizedBox(height: 12),
          ...educationRecords.map((item) => _EducationTile(item: item)),
        ],
      ),
    );
  }
}

class _EducationTile extends StatelessWidget {
  const _EducationTile({required this.item});

  final ProfileEducation item;

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
            item.degreeName,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.schoolName,
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
        ],
      ),
    );
  }
}
