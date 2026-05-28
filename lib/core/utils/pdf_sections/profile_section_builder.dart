import 'package:pdf/widgets.dart' as pw;

import 'pdf_section_context.dart';
import 'pdf_section_primitives.dart';
import 'pdf_section_shell.dart';
import 'pdf_section_visibility.dart';

pw.Widget? buildProfileSection(PdfSectionContext context) {
  if (!context.isSectionVisible(PdfSectionKeys.profile)) {
    return null;
  }

  final values = [
    context.data.email,
    context.data.phone,
    context.data.address,
    context.data.birthday,
    context.data.website,
  ]
      .where(PdfSectionVisibility.isNotBlank)
      .map((value) => value.trim())
      .toList();

  if (values.isEmpty) {
    return null;
  }

  final title = context.sectionTitle(PdfSectionKeys.profile, 'Profile');
  return buildSectionShell(
    title: title,
    accent: context.accent,
    children:
        values.map((value) => buildProfileRow(value, context.accent)).toList(),
  );
}
