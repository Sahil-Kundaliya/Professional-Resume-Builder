import 'package:flutter/material.dart';
import '../../domain/entities/resume_template.dart';
import 'template_thumbnail.dart';

class TemplateGrid extends StatelessWidget {
  final List<ResumeTemplate> templates;
  final Function(ResumeTemplate) onTemplateSelected;
  final Function(String) onFavoriteToggled;

  const TemplateGrid({
    super.key,
    required this.templates,
    required this.onTemplateSelected,
    required this.onFavoriteToggled,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return TemplateThumbnail(
          template: template,
          onTap: () => onTemplateSelected(template),
          onFavoriteTap: () => onFavoriteToggled(template.id),
        );
      },
    );
  }
}
