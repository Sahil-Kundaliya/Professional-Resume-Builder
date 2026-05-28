import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'pdf_sections/pdf_sections.dart';
import '../../features/resume/domain/entities/resume_document.dart';
import '../../features/resume/domain/entities/resume_template.dart';

class PdfGenerator {
  PdfGenerator._();

  static Future<Uint8List> generate(
    ResumeTemplate? template,
    ResumeDocument data,
  ) async {
    final pdf = pw.Document();
    final accentHex = template?.accentColor.toARGB32() ?? 0xFF444444;
    final r = ((accentHex >> 16) & 0xFF) / 255.0;
    final g = ((accentHex >> 8) & 0xFF) / 255.0;
    final b = (accentHex & 0xFF) / 255.0;
    final accent = PdfColor(r, g, b);
    final headerColor =
        _pdfColorFromInt(template?.headerBgColor.toARGB32() ?? 0xFFFFFFFF);
    final photoWidget = await _buildPhotoWidget(data.photoPath);
    final sectionContext = PdfSectionContext(
      data: data,
      accent: accent,
      summaryTextStyle: _resolveHeaderTextStyle(
        data.headerStyles.careerGoalsStyle,
        fontSize: 9,
        lineSpacing: 3,
      ),
    );
    final summaryWidget = PdfSectionRegistry.buildHeaderSummary(sectionContext);
    final leftColumnSections =
        PdfSectionRegistry.buildLeftColumn(sectionContext);
    final rightColumnSections =
        PdfSectionRegistry.buildRightColumn(sectionContext);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (ctx) => [
          // Header
          pw.Container(
            color: headerColor,
            padding:
                const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                photoWidget,
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
                      if (summaryWidget != null) ...[
                        pw.SizedBox(height: 6),
                        summaryWidget,
                      ],
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
                    children: leftColumnSections,
                  ),
                ),
                pw.SizedBox(width: 14),
                // Right sidebar
                pw.Expanded(
                  flex: 45,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: rightColumnSections,
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
        if (style.isBold && style.isItalic) {
          return pw.Font.helveticaBoldOblique();
        }
        if (style.isBold) return pw.Font.helveticaBold();
        if (style.isItalic) return pw.Font.helveticaOblique();
        return pw.Font.helvetica();
    }
  }

  static Future<pw.Widget> _buildPhotoWidget(String photoPath) async {
    final imageProvider = await _resolvePhotoImage(photoPath);

    return pw.Container(
      width: 60,
      height: 60,
      decoration: pw.BoxDecoration(
        color: PdfColors.grey300,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: imageProvider == null
          ? null
          : pw.ClipRRect(
              horizontalRadius: 4,
              verticalRadius: 4,
              child: pw.Image(imageProvider, fit: pw.BoxFit.cover),
            ),
    );
  }

  static Future<pw.ImageProvider?> _resolvePhotoImage(String photoPath) async {
    if (photoPath.isEmpty) {
      return null;
    }

    try {
      if (photoPath.startsWith('base64:')) {
        final bytes = base64Decode(photoPath.substring('base64:'.length));
        return pw.MemoryImage(bytes);
      }

      if (_isLocalImagePath(photoPath)) {
        final path = photoPath.startsWith('file://')
            ? Uri.parse(photoPath).toFilePath()
            : photoPath;
        final bytes = await File(path).readAsBytes();
        return pw.MemoryImage(bytes);
      }

      final uri = Uri.tryParse(photoPath);
      if (uri == null) {
        return null;
      }

      final client = HttpClient();
      try {
        final request = await client.getUrl(uri);
        final response = await request.close();
        if (response.statusCode != HttpStatus.ok) {
          return null;
        }
        final bytes = await consolidateHttpClientResponseBytes(response);
        return pw.MemoryImage(bytes);
      } finally {
        client.close(force: true);
      }
    } catch (_) {
      return null;
    }
  }

  static bool _isLocalImagePath(String value) {
    return value.startsWith('/') ||
        value.startsWith('file://') ||
        RegExp(r'^[a-zA-Z]:\\').hasMatch(value);
  }
}
