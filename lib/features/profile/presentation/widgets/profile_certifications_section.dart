import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/resume_profile.dart';
import 'profile_section_card.dart';
import 'profile_section_date_formatter.dart';
import 'profile_section_header.dart';

class ProfileCertificationsSection extends StatelessWidget {
  const ProfileCertificationsSection({super.key, required this.certifications});

  final List<ProfileCertification> certifications;

  @override
  Widget build(BuildContext context) {
    if (certifications.isEmpty) return const SizedBox.shrink();

    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(title: 'Certifications'),
          const SizedBox(height: 12),
          ...certifications.map(
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
