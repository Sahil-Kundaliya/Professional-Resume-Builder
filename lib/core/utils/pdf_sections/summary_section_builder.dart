import 'package:pdf/widgets.dart' as pw;

import 'pdf_section_context.dart';
import 'pdf_section_visibility.dart';

pw.Widget? buildSummarySection(PdfSectionContext context) {
  if (!context.isSectionVisible(PdfSectionKeys.summary)) {
    return null;
  }
  final summary = context.data.careerGoals.trim();
  if (PdfSectionVisibility.isBlank(summary)) {
    return null;
  }
  return pw.Text(summary, style: context.summaryTextStyle);
}
