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
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.5,
            color: Colors.grey.shade700,
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
