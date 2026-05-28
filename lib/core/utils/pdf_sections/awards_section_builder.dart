import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../features/resume/domain/entities/resume_document.dart';
import 'pdf_section_context.dart';
import 'pdf_section_shell.dart';
import 'pdf_section_style.dart';
import 'pdf_section_visibility.dart';

pw.Widget? buildAwardsSection(PdfSectionContext context) {
  if (!context.isSectionVisible(PdfSectionKeys.awards)) {
    return null;
  }

  final awards = context.data.awards.where(_isRenderable).toList();
  if (awards.isEmpty) {
    return null;
  }

  final title = context.sectionTitle(PdfSectionKeys.awards, 'Awards');
  return buildSectionShell(
    title: title,
    accent: context.accent,
    children: awards
        .map(
          (entry) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  entry.year,
                  style: const pw.TextStyle(
                    fontSize: PdfSectionStyle.metadataSize,
                    color: PdfColors.grey500,
                  ),
                ),
                pw.Text(
                  entry.name,
                  style:
                      const pw.TextStyle(fontSize: PdfSectionStyle.bodyAltSize),
                ),
              ],
            ),
          ),
        )
        .toList(),
  );
}

bool _isRenderable(AwardEntry entry) {
  return [entry.year, entry.name].any(PdfSectionVisibility.isNotBlank);
}
