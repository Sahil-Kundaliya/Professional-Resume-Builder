import '../../domain/entities/resume_document.dart';

class ResumeFormMappers {
  const ResumeFormMappers._();

  static String toMonthYearRange(DateTime start, DateTime end) {
    return '${_monthYear(start)} • ${_monthYear(end)}';
  }

  static String monthYear(DateTime value) => _monthYear(value);

  static (DateTime?, DateTime?) parseMonthYearRange(String value) {
    final segments = value.split('•');
    if (segments.length != 2) {
      return (null, null);
    }

    final start = _parseMonthYear(segments[0].trim());
    final end = _parseMonthYear(segments[1].trim());
    return (start, end);
  }

  static WorkExperienceEntry toWorkExperienceEntry({
    required String company,
    required String position,
    required DateTime startDate,
    required DateTime endDate,
    required String description,
  }) {
    return WorkExperienceEntry(
      dateRange: toMonthYearRange(startDate, endDate),
      position: position.trim(),
      companyName: company.trim(),
      description: description.trim(),
    );
  }

  static EducationEntry toEducationEntry({
    required String title,
    required String school,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return EducationEntry(
      dateRange: toMonthYearRange(startDate, endDate),
      coursesSubjects: title.trim(),
      schoolName: school.trim(),
      description: description.trim(),
    );
  }

  static String _monthYear(DateTime value) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[value.month - 1]} ${value.year}';
  }

  static DateTime? _parseMonthYear(String value) {
    const months = <String, int>{
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };

    final parts = value.split(' ');
    if (parts.length != 2) {
      return null;
    }

    final month = months[parts[0]];
    final year = int.tryParse(parts[1]);
    if (month == null || year == null) {
      return null;
    }

    return DateTime(year, month);
  }
}
