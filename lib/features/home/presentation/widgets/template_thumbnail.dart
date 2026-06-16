import 'package:flutter/material.dart';
import 'package:resume_builder/core/constants/app_colors.dart';
import 'package:resume_builder/core/constants/app_text_styles.dart';
import '../../domain/entities/resume_template.dart';

class TemplateThumbnail extends StatelessWidget {
  final ResumeTemplate template;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;

  const TemplateThumbnail({
    super.key,
    required this.template,
    required this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1),
            color: AppColors.surface,
          ),
          child: AspectRatio(
            aspectRatio: 0.70,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              template.accentColor.withOpacity(0.14),
                              template.accentColor.withOpacity(0.04),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: template.accentColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      child: Text(
                        template.name,
                        style: AppTextStyles.heading3.copyWith(
                          color: template.accentColor,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        template.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: template.accentColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
