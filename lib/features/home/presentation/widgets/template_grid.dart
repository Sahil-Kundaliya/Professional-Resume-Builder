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
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 600
            ? 2
            : constraints.maxWidth < 900
                ? 3
                : 4;

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.68,
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
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
      },
    );
  }
}
