import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileImagePickerField extends StatelessWidget {
  const ProfileImagePickerField({
    super.key,
    required this.imagePath,
    required this.onPickImage,
  });

  final String imagePath;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath.isNotEmpty && File(imagePath).existsSync();

    return Row(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: const Color(0xFFF1EAFF),
          backgroundImage: hasImage ? FileImage(File(imagePath)) : null,
          child: hasImage
              ? null
              : const Icon(
                  Icons.person_rounded,
                  size: 38,
                  color: Color(0xFF5B2ECC),
                ),
        ),
        const SizedBox(width: 22),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onPickImage,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF5B2ECC),
              side: const BorderSide(color: Color(0xFF5B2ECC), width: 1.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              textStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            icon: const Icon(Icons.image_outlined, size: 26),
            label: Text(
                hasImage ? 'Change profile image' : 'Choose profile image'),
          ),
        ),
      ],
    );
  }
}
