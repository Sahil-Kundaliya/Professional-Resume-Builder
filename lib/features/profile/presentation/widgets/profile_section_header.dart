import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSectionHeader extends StatelessWidget {
  const ProfileSectionHeader({
    super.key,
    required this.title,
    this.onAdd,
    this.addLabel = 'Add',
  });

  final String title;
  final VoidCallback? onAdd;
  final String addLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
              color: const Color(0xFF080D32),
            ),
          ),
        ),
        if (onAdd != null)
          IconButton.filledTonal(
            onPressed: onAdd,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF1EAFF),
              foregroundColor: const Color(0xFF5B2ECC),
              minimumSize: const Size.square(40),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(Icons.add_rounded, size: 22),
            tooltip: addLabel,
          ),
      ],
    );
  }
}
