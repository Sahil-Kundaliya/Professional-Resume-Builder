class ResumeFormValidators {
  const ResumeFormValidators._();

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
}
