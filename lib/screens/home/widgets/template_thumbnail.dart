import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/resume_template_model.dart';

class TemplateThumbnail extends StatelessWidget {
  final ResumeTemplateModel template;
  final VoidCallback onTap;

  const TemplateThumbnail({
    super.key,
    required this.template,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildMiniResume(template),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            template.name,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniResume(ResumeTemplateModel t) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth / 200;
        return Transform.scale(
          scale: scale,
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 200,
            child: _MiniResumeContent(template: t),
          ),
        );
      },
    );
  }
}

class _MiniResumeContent extends StatelessWidget {
  final ResumeTemplateModel template;
  const _MiniResumeContent({required this.template});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mini header
        Container(
          color: template.headerBgColor,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              if (template.hasPhoto)
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 18, color: Colors.white),
                ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 5,
                      width: 80,
                      decoration: BoxDecoration(
                        color: template.accentColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      height: 3,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Mini body
        Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _miniSection('Work experience', template.accentColor),
                    _miniLines(3),
                    const SizedBox(height: 6),
                    _miniSection('Education', template.accentColor),
                    _miniLines(2),
                    const SizedBox(height: 6),
                    _miniSection('References', template.accentColor),
                    _miniLines(1),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              // Right sidebar
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _miniSection('Profile', template.accentColor),
                    _miniLines(4),
                    const SizedBox(height: 6),
                    _miniSection('Skills', template.accentColor),
                    _miniLines(3),
                    const SizedBox(height: 6),
                    _miniSection('Awards', template.accentColor),
                    _miniLines(2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _miniSection(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 5,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _miniLines(int count) {
    return Column(
      children: List.generate(
        count,
        (i) => Container(
          margin: const EdgeInsets.only(bottom: 2),
          height: 2.5,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ),
    );
  }
}
