import '../../domain/entities/resume_document.dart';

class ResumeFormValidators {
  const ResumeFormValidators._();

  static const Set<String> _defaultPlaceholders = <String>{
    'Full name',
    'Job position',
    'Career goals: short-term, long-term',
    'Information',
  };

  static String? requiredText(
    String value, {
    String fieldName = 'Field',
  }) {
    if (value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  static String? optionalEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailPattern.hasMatch(trimmed)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? requiredEmail(String value) {
    final required = requiredText(value, fieldName: 'Email');
    if (required != null) {
      return required;
    }
    return optionalEmail(value);
  }

  static String? optionalPhone(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final digits = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 7) {
      return 'Enter a valid phone number.';
    }
    return null;
  }

  static String? requiredPhone(String value) {
    final required = requiredText(value, fieldName: 'Phone');
    if (required != null) {
      return required;
    }
    return optionalPhone(value);
  }

  static bool hasMeaningfulValue(
    String value, {
    Set<String> placeholderValues = _defaultPlaceholders,
  }) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return false;
    }
    return !placeholderValues.contains(trimmed);
  }

  static String? optionalDateRange({
    DateTime? start,
    DateTime? end,
    String startLabel = 'Start date',
    String endLabel = 'End date',
  }) {
    if (start == null || end == null) {
      return '$startLabel and $endLabel are required.';
    }
    if (end.isBefore(start)) {
      return '$endLabel must be after $startLabel.';
    }
    return null;
  }

  static List<String> sanitizeTextItems(List<String> source) {
    return source
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  static List<WorkExperienceEntry> sanitizeWorkExperienceItems(
    List<WorkExperienceEntry> source,
  ) {
    return source
        .map(
          (entry) => entry.copyWith(
            dateRange: entry.dateRange.trim(),
            position: entry.position.trim(),
            companyName: entry.companyName.trim(),
            description: entry.description.trim(),
          ),
        )
        .where(
          (entry) =>
              hasMeaningfulValue(entry.dateRange) ||
              hasMeaningfulValue(entry.position) ||
              hasMeaningfulValue(entry.companyName) ||
              hasMeaningfulValue(entry.description),
        )
        .toList(growable: false);
  }

  static List<EducationEntry> sanitizeEducationItems(
    List<EducationEntry> source,
  ) {
    return source
        .map(
          (entry) => entry.copyWith(
            dateRange: entry.dateRange.trim(),
            coursesSubjects: entry.coursesSubjects.trim(),
            schoolName: entry.schoolName.trim(),
            description: entry.description.trim(),
          ),
        )
        .where(
          (entry) =>
              hasMeaningfulValue(entry.dateRange) ||
              hasMeaningfulValue(entry.coursesSubjects) ||
              hasMeaningfulValue(entry.schoolName) ||
              hasMeaningfulValue(entry.description),
        )
        .toList(growable: false);
  }

  static List<SkillEntry> sanitizeSkillItems(List<SkillEntry> source) {
    return source
        .map(
          (entry) => entry.copyWith(name: entry.name.trim()),
        )
        .where((entry) => hasMeaningfulValue(entry.name))
        .toList(growable: false);
  }

  static List<AwardEntry> sanitizeAwardItems(List<AwardEntry> source) {
    return source
        .map(
          (entry) => entry.copyWith(
            year: entry.year.trim(),
            name: entry.name.trim(),
          ),
        )
        .where((entry) =>
            hasMeaningfulValue(entry.year) || hasMeaningfulValue(entry.name))
        .toList(growable: false);
  }

  static List<CertEntry> sanitizeCertificationItems(List<CertEntry> source) {
    return source
        .map(
          (entry) => entry.copyWith(
            year: entry.year.trim(),
            name: entry.name.trim(),
          ),
        )
        .where((entry) =>
            hasMeaningfulValue(entry.year) || hasMeaningfulValue(entry.name))
        .toList(growable: false);
  }

  static bool hasAnyMeaningfulText(List<String> values) {
    return values.any((value) => value.trim().isNotEmpty);
  }
}
