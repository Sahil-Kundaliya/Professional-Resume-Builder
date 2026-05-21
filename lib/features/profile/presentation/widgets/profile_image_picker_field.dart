import 'dart:io';

import 'package:flutter/material.dart';

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
          radius: 34,
          backgroundColor: const Color(0xFFE7F6EF),
          backgroundImage: hasImage ? FileImage(File(imagePath)) : null,
          child: hasImage
              ? null
              : Icon(
                  Icons.person,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onPickImage,
            icon: const Icon(Icons.photo_library_outlined),
            label: Text(
                hasImage ? 'Change profile image' : 'Choose profile image'),
          ),
        ),
      ],
    );
  }
}
