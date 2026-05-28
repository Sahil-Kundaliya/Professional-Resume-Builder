import 'package:pdf/widgets.dart' as pw;

import 'pdf_section_context.dart';
import 'pdf_section_shell.dart';
import 'pdf_section_style.dart';
import 'pdf_section_visibility.dart';

pw.Widget? buildReferencesSection(PdfSectionContext context) {
  if (!context.isSectionVisible(PdfSectionKeys.references)) {
    return null;
  }
  final references =
      PdfSectionVisibility.nonBlankValues(context.data.references);
  if (references.isEmpty) {
    return null;
  }

  final title = context.sectionTitle(PdfSectionKeys.references, 'References');
  return buildSectionShell(
    title: title,
    accent: context.accent,
    children: references
        .map(
          (value) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 3),
            child: pw.Text(
              value,
              style: const pw.TextStyle(
                fontSize: PdfSectionStyle.bodyAltSize,
                lineSpacing: PdfSectionStyle.metadataLineSpacing,
              ),
            ),
          ),
        )
        .toList(),
  );
}
