import 'package:pdf/widgets.dart' as pw;

import 'pdf_section_context.dart';
import 'pdf_section_shell.dart';
import 'pdf_section_style.dart';
import 'pdf_section_visibility.dart';

pw.Widget? buildHobbiesSection(PdfSectionContext context) {
  if (!context.isSectionVisible(PdfSectionKeys.hobbies)) {
    return null;
  }

  final hobbies = PdfSectionVisibility.nonBlankValues(context.data.hobbies);
  if (hobbies.isEmpty) {
    return null;
  }

  final title = context.sectionTitle(PdfSectionKeys.hobbies, 'Hobbies');
  return buildSectionShell(
    title: title,
    accent: context.accent,
    children: hobbies
        .map(
          (value) => pw.Text(
            value,
            style: const pw.TextStyle(
              fontSize: PdfSectionStyle.bodyAltSize,
              lineSpacing: PdfSectionStyle.bodyAltLineSpacing,
            ),
          ),
        )
        .toList(),
  );
}
