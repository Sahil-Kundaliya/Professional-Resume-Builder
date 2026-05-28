import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../features/resume/domain/entities/resume_document.dart';

class PdfSectionKeys {
  static const String profile = 'profile';
  static const String summary = 'summary';
  static const String workExperience = 'work_experience';
  static const String education = 'education';
  static const String skills = 'skills';
  static const String references = 'references';
  static const String awards = 'awards';
  static const String certifications = 'certifications';
  static const String hobbies = 'hobbies';
}

class PdfSectionContext {
  const PdfSectionContext({
    required this.data,
    required this.accent,
    required this.summaryTextStyle,
  });

  final ResumeDocument data;
  final PdfColor accent;
  final pw.TextStyle summaryTextStyle;

  bool isSectionVisible(String sectionKey) => data.isSectionVisible(sectionKey);

  String sectionTitle(String sectionKey, String fallback) {
    final resolved = data.resolvedSectionTitle(sectionKey).trim();
    return resolved.isEmpty ? fallback : resolved;
  }
}
