import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../features/resume/domain/entities/resume_document.dart';
import '../../features/resume/domain/entities/resume_template.dart';

class PdfGenerator {
  PdfGenerator._();

  static Future<Uint8List> generate(
    ResumeTemplate? template,
    ResumeDocument data,
  ) async {
    final pdf = pw.Document();
    final accentHex = template?.accentColor.value ?? 0xFF444444;
    final r = ((accentHex >> 16) & 0xFF) / 255.0;
    final g = ((accentHex >> 8) & 0xFF) / 255.0;
    final b = (accentHex & 0xFF) / 255.0;
    final accent = PdfColor(r, g, b);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (ctx) => [
          // Header
          pw.Container(
            color: PdfColors.white,
            padding:
                const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 60,
                  height: 60,
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey300,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                ),
                pw.SizedBox(width: 14),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(data.fullName,
                          style: _resolveHeaderTextStyle(
                            data.headerStyles.fullNameStyle,
                            fontSize: 20,
                            defaultBold: true,
                          )),
                      pw.SizedBox(height: 3),
                      pw.Text(data.jobPosition,
                          style: _resolveHeaderTextStyle(
                            data.headerStyles.jobPositionStyle,
                            fontSize: 11,
                            defaultColor: PdfColors.grey600,
                          )),
                      pw.SizedBox(height: 6),
                      pw.Text(data.careerGoals,
                          style: _resolveHeaderTextStyle(
                            data.headerStyles.careerGoalsStyle,
                            fontSize: 9,
                            lineSpacing: 3,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.Container(height: 1, color: PdfColors.grey300),
          // Body
          pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Left column
                pw.Expanded(
                  flex: 55,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _section('Work experience', accent),
                      ...data.workExperience.map((e) => pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 10),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: 65,
                                  child: pw.Text(e.dateRange,
                                      style: pw.TextStyle(
                                          fontSize: 7.5,
                                          color: PdfColors.grey600)),
                                ),
                                pw.SizedBox(width: 6),
                                pw.Expanded(
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(e.position,
                                          style: pw.TextStyle(
                                              fontSize: 9,
                                              fontWeight: pw.FontWeight.bold)),
                                      pw.Text(e.companyName,
                                          style: pw.TextStyle(
                                              fontSize: 8,
                                              color: PdfColors.grey500)),
                                      pw.SizedBox(height: 3),
                                      pw.Text(e.description,
                                          style: pw.TextStyle(
                                              fontSize: 8, lineSpacing: 3)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      pw.SizedBox(height: 10),
                      _section('Education', accent),
                      ...data.education.map((e) => pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 8),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: 65,
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(e.dateRange,
                                          style: pw.TextStyle(
                                              fontSize: 7.5,
                                              color: PdfColors.grey600)),
                                      pw.Text(e.coursesSubjects,
                                          style: pw.TextStyle(
                                              fontSize: 7.5,
                                              color: PdfColors.grey500)),
                                    ],
                                  ),
                                ),
                                pw.SizedBox(width: 6),
                                pw.Expanded(
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(e.schoolName,
                                          style: pw.TextStyle(
                                              fontSize: 9,
                                              fontWeight: pw.FontWeight.bold)),
                                      pw.Text(e.description,
                                          style: pw.TextStyle(
                                              fontSize: 8, lineSpacing: 3)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      pw.SizedBox(height: 10),
                      _section('References', accent),
                      ...data.references.map((r) => pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 3),
                            child: pw.Text(r,
                                style: pw.TextStyle(
                                    fontSize: 8.5, lineSpacing: 2)),
                          )),
                    ],
                  ),
                ),
                pw.SizedBox(width: 14),
                // Right sidebar
                pw.Expanded(
                  flex: 45,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _section('Profile', accent),
                      _profileRow(data.email, accent),
                      _profileRow(data.phone, accent),
                      _profileRow(data.address, accent),
                      _profileRow(data.birthday, accent),
                      _profileRow(data.website, accent),
                      pw.SizedBox(height: 10),
                      _section('Hobbies', accent),
                      ...data.hobbies.map((h) => pw.Text(h,
                          style: pw.TextStyle(fontSize: 8.5, lineSpacing: 3))),
                      pw.SizedBox(height: 10),
                      _section('Skills', accent),
                      ...data.skills.map((s) => pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 5),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(s.name,
                                    style: pw.TextStyle(fontSize: 8.5)),
                                pw.SizedBox(height: 2),
                                pw.Row(
                                  children: List.generate(
                                      7,
                                      (i) => pw.Container(
                                            width: 7,
                                            height: 7,
                                            margin: const pw.EdgeInsets.only(
                                                right: 3),
                                            decoration: pw.BoxDecoration(
                                              shape: pw.BoxShape.circle,
                                              color: i < s.rating + 1
                                                  ? accent
                                                  : PdfColors.grey300,
                                            ),
                                          )),
                                ),
                              ],
                            ),
                          )),
                      pw.SizedBox(height: 10),
                      _section('Awards', accent),
                      ...data.awards.map((a) => pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 4),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(a.year,
                                    style: pw.TextStyle(
                                        fontSize: 7.5,
                                        color: PdfColors.grey500)),
                                pw.Text(a.name,
                                    style: pw.TextStyle(fontSize: 8.5)),
                              ],
                            ),
                          )),
                      pw.SizedBox(height: 10),
                      _section('Certifications', accent),
                      ...data.certifications.map((c) => pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 4),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(c.year,
                                    style: pw.TextStyle(
                                        fontSize: 7.5,
                                        color: PdfColors.grey500)),
                                pw.Text(c.name,
                                    style: pw.TextStyle(fontSize: 8.5)),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return pdf.save();
  }

  static pw.TextStyle _resolveHeaderTextStyle(
    ResumeTextStyleSpec style, {
    required double fontSize,
    PdfColor? defaultColor,
    double? lineSpacing,
    bool defaultBold = false,
  }) {
    final font = _resolvePdfFont(style);
    return pw.TextStyle(
      font: font,
      fontSize: fontSize,
      color: _pdfColorFromInt(style.textColorValue, fallback: defaultColor),
      lineSpacing: lineSpacing,
      decoration: style.isUnderline
          ? pw.TextDecoration.underline
          : pw.TextDecoration.none,
      fontWeight: style.isBold || defaultBold
          ? pw.FontWeight.bold
          : pw.FontWeight.normal,
      fontStyle: style.isItalic ? pw.FontStyle.italic : pw.FontStyle.normal,
    );
  }

  static PdfColor _pdfColorFromInt(int colorValue, {PdfColor? fallback}) {
    final value = colorValue == 0 ? null : colorValue;
    if (value == null) {
      return fallback ?? PdfColors.black;
    }
    final r = ((value >> 16) & 0xFF) / 255.0;
    final g = ((value >> 8) & 0xFF) / 255.0;
    final b = (value & 0xFF) / 255.0;
    return PdfColor(r, g, b);
  }

  static pw.Font _resolvePdfFont(ResumeTextStyleSpec style) {
    switch (style.fontFamily) {
      case 'Monospace':
        if (style.isBold && style.isItalic) return pw.Font.courierBoldOblique();
        if (style.isBold) return pw.Font.courierBold();
        if (style.isItalic) return pw.Font.courierOblique();
        return pw.Font.courier();
      case 'Serif':
      case 'Georgia':
        if (style.isBold && style.isItalic) return pw.Font.timesBoldItalic();
        if (style.isBold) return pw.Font.timesBold();
        if (style.isItalic) return pw.Font.timesItalic();
        return pw.Font.times();
      default:
        if (style.isBold && style.isItalic)
          return pw.Font.helveticaBoldOblique();
        if (style.isBold) return pw.Font.helveticaBold();
        if (style.isItalic) return pw.Font.helveticaOblique();
        return pw.Font.helvetica();
    }
  }

  static pw.Widget _section(String title, PdfColor accent) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: accent,
            )),
        pw.Container(
          height: 0.8,
          color: accent,
          margin: const pw.EdgeInsets.only(top: 2, bottom: 5),
        ),
      ],
    );
  }

  static pw.Widget _profileRow(String text, PdfColor accent) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.Container(
            width: 8,
            height: 8,
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              color: accent,
            ),
          ),
          pw.SizedBox(width: 5),
          pw.Expanded(
            child: pw.Text(text, style: pw.TextStyle(fontSize: 8.5)),
          ),
        ],
      ),
    );
  }
}
