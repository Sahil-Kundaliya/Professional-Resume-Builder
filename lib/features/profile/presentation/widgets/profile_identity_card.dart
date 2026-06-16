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
      padding: const EdgeInsets.all(0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFEDF1FF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF5D7CFF), Color(0xFF8E9CFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 54,
                backgroundColor: Colors.white,
                backgroundImage:
                    hasImage ? FileImage(File(profile.profileImagePath)) : null,
                child: hasImage
                    ? null
                    : Icon(
                        Icons.person,
                        size: 44,
                        color: Theme.of(context).colorScheme.primary,
                      ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              profile.fullName,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              profile.jobTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
