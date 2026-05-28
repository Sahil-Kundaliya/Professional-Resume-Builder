import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../features/resume/domain/entities/resume_document.dart';
import 'pdf_section_context.dart';
import 'pdf_section_shell.dart';
import 'pdf_section_style.dart';
import 'pdf_section_visibility.dart';

pw.Widget? buildCertificationsSection(PdfSectionContext context) {
  if (!context.isSectionVisible(PdfSectionKeys.certifications)) {
    return null;
  }

  final certs = context.data.certifications.where(_isRenderable).toList();
  if (certs.isEmpty) {
    return null;
  }

  final title =
      context.sectionTitle(PdfSectionKeys.certifications, 'Certifications');
  return buildSectionShell(
    title: title,
    accent: context.accent,
    children: certs
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

bool _isRenderable(CertEntry entry) {
  return [entry.year, entry.name].any(PdfSectionVisibility.isNotBlank);
}
