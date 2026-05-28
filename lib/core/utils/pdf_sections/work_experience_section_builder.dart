import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../features/resume/domain/entities/resume_document.dart';
import 'pdf_section_context.dart';
import 'pdf_section_shell.dart';
import 'pdf_section_style.dart';
import 'pdf_section_visibility.dart';

pw.Widget? buildWorkExperienceSection(PdfSectionContext context) {
  if (!context.isSectionVisible(PdfSectionKeys.workExperience)) {
    return null;
  }
  final entries = context.data.workExperience.where(_isRenderable).toList();
  if (entries.isEmpty) {
    return null;
  }

  final title =
      context.sectionTitle(PdfSectionKeys.workExperience, 'Work experience');
  return buildSectionShell(
    title: title,
    accent: context.accent,
    children: entries.map(_buildItem).toList(),
  );
}

bool _isRenderable(WorkExperienceEntry entry) {
  return [
    entry.dateRange,
    entry.position,
    entry.companyName,
    entry.description,
  ].any(PdfSectionVisibility.isNotBlank);
}

pw.Widget _buildItem(WorkExperienceEntry entry) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 10),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: PdfSectionStyle.workDateWidth,
          child: pw.Text(
            entry.dateRange,
            style: const pw.TextStyle(
              fontSize: PdfSectionStyle.metadataSize,
              color: PdfColors.grey600,
            ),
          ),
        ),
        pw.SizedBox(width: PdfSectionStyle.itemGap),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                entry.position,
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                entry.companyName,
                style: const pw.TextStyle(
                  fontSize: PdfSectionStyle.bodySize,
                  color: PdfColors.grey500,
                ),
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                entry.description,
                style: const pw.TextStyle(
                  fontSize: PdfSectionStyle.bodySize,
                  lineSpacing: PdfSectionStyle.bodyLineSpacing,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
