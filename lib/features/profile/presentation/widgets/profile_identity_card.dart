import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/resume_profile.dart';
import 'profile_section_card.dart';

class ProfileIdentityCard extends StatelessWidget {
  const ProfileIdentityCard({super.key, required this.profile});

  final ResumeProfile profile;

  @override
  Widget build(BuildContext context) {
    final hasImage = profile.profileImagePath.isNotEmpty &&
        File(profile.profileImagePath).existsSync();

    return ProfileSectionCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: const Color(0xFFE7F6EF),
            backgroundImage:
                hasImage ? FileImage(File(profile.profileImagePath)) : null,
            child: hasImage
                ? null
                : Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.green.shade700,
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.fullName,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            profile.jobTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
