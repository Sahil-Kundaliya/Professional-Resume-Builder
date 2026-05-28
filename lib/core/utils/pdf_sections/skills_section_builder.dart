import 'package:pdf/widgets.dart' as pw;

import '../../../features/resume/domain/entities/resume_document.dart';
import 'pdf_section_context.dart';
import 'pdf_section_primitives.dart';
import 'pdf_section_shell.dart';
import 'pdf_section_style.dart';
import 'pdf_section_visibility.dart';

pw.Widget? buildSkillsSection(PdfSectionContext context) {
  if (!context.isSectionVisible(PdfSectionKeys.skills)) {
    return null;
  }

  final skills = context.data.skills.where(_isRenderable).toList();
  if (skills.isEmpty) {
    return null;
  }

  final title = context.sectionTitle(PdfSectionKeys.skills, 'Skills');
  return buildSectionShell(
    title: title,
    accent: context.accent,
    children: skills
        .map(
          (entry) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 5),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  entry.name.trim(),
                  style:
                      const pw.TextStyle(fontSize: PdfSectionStyle.bodyAltSize),
                ),
                pw.SizedBox(height: 2),
                buildSkillDots(entry.rating, context.accent),
              ],
            ),
          ),
        )
        .toList(),
  );
}

bool _isRenderable(SkillEntry entry) {
  return PdfSectionVisibility.isNotBlank(entry.name);
}
