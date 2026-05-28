import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'skill_rating_utils.dart';

class SkillRatingRow extends StatelessWidget {
  const SkillRatingRow({
    super.key,
    required this.name,
    required this.rating,
    this.onTap,
    this.onDelete,
  });

  final String name;
  final int rating;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final stars = buildSkillRatingStars(rating, size: 18);
    final label = skillRatingLabel(rating);

    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Expertise: $label ($rating/5)',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Row(children: stars),
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Remove skill',
            ),
          if (onTap != null)
            IconButton(
              onPressed: onTap,
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit skill',
            ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: content,
    );
  }
}
