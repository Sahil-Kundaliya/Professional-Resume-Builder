import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileListEmptyState extends StatelessWidget {
  const ProfileListEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.onAdd,
    this.addLabel = 'Add',
  });

  final String title;
  final String message;
  final VoidCallback? onAdd;
  final String addLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.trim().isNotEmpty) ...[
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF10142F),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFBFBFE),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE7E8F1)),
          ),
          child: Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.45,
              color: const Color(0xFF5B6078),
            ),
          ),
        ),
        if (onAdd != null) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(addLabel),
          ),
        ],
      ],
    );
  }
}
