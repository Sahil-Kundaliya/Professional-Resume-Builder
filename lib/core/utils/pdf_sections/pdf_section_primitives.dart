import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'pdf_section_style.dart';

pw.Widget buildProfileRow(String text, PdfColor accent) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 4),
    child: pw.Row(
      children: [
        pw.Container(
          width: PdfSectionStyle.profileBulletSize,
          height: PdfSectionStyle.profileBulletSize,
          decoration: pw.BoxDecoration(
            shape: pw.BoxShape.circle,
            color: accent,
          ),
        ),
        pw.SizedBox(width: PdfSectionStyle.profileBulletGap),
        pw.Expanded(
          child: pw.Text(
            text,
            style: const pw.TextStyle(fontSize: PdfSectionStyle.bodyAltSize),
          ),
        ),
      ],
    ),
  );
}

pw.Widget buildSkillDots(int rating, PdfColor accent) {
  return pw.Row(
    children: List.generate(
      7,
      (index) => pw.Container(
        width: 7,
        height: 7,
        margin: const pw.EdgeInsets.only(right: 3),
        decoration: pw.BoxDecoration(
          shape: pw.BoxShape.circle,
          color: index < rating + 1 ? accent : PdfColors.grey300,
        ),
      ),
    ),
  );
}
