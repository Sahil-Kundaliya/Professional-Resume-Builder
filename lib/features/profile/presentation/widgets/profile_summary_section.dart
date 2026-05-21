import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/resume_profile.dart';
import 'profile_empty_state.dart';
import 'profile_section_card.dart';

class ProfileSummarySection extends StatelessWidget {
  const ProfileSummarySection({super.key, required this.profile});

  final ResumeProfile profile;

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      child: profile.summary.trim().isEmpty
          ? const ProfileEmptyState(
              title: 'Summary',
              message:
                  'Add a short professional summary to reuse across resumes.',
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summary',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  profile.summary,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
    );
  }
}
