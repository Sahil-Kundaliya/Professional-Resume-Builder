import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../features/resume/domain/entities/resume_document.dart';
import 'pdf_section_context.dart';
import 'pdf_section_shell.dart';
import 'pdf_section_style.dart';
import 'pdf_section_visibility.dart';

pw.Widget? buildEducationSection(PdfSectionContext context) {
  if (!context.isSectionVisible(PdfSectionKeys.education)) {
    return null;
  }
  final entries = context.data.education.where(_isRenderable).toList();
  if (entries.isEmpty) {
    return null;
  }

  final title = context.sectionTitle(PdfSectionKeys.education, 'Education');
  return buildSectionShell(
    title: title,
    accent: context.accent,
    children: entries.map(_buildItem).toList(),
  );
}

bool _isRenderable(EducationEntry entry) {
  return [
    entry.dateRange,
    entry.coursesSubjects,
    entry.schoolName,
    entry.description,
  ].any(PdfSectionVisibility.isNotBlank);
}

pw.Widget _buildItem(EducationEntry entry) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 8),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: PdfSectionStyle.educationDateWidth,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                entry.dateRange,
                style: const pw.TextStyle(
                  fontSize: PdfSectionStyle.metadataSize,
                  color: PdfColors.grey600,
                ),
              ),
              pw.Text(
                entry.coursesSubjects,
                style: const pw.TextStyle(
                  fontSize: PdfSectionStyle.metadataSize,
                  color: PdfColors.grey500,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(width: PdfSectionStyle.itemGap),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                entry.schoolName,
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
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
