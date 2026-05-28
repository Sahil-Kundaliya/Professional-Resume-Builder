import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'pdf_section_style.dart';

pw.Widget buildSectionShell({
  required String title,
  required PdfColor accent,
  required List<pw.Widget> children,
}) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: PdfSectionStyle.sectionTitleSize,
          fontWeight: pw.FontWeight.bold,
          color: accent,
        ),
      ),
      pw.Container(
        height: PdfSectionStyle.sectionDividerHeight,
        color: accent,
        margin: const pw.EdgeInsets.only(
          top: PdfSectionStyle.sectionHeaderTopSpacing,
          bottom: PdfSectionStyle.sectionHeaderBottomSpacing,
        ),
      ),
      ...children,
    ],
  );
}
