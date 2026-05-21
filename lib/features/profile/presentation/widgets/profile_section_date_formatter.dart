import 'package:intl/intl.dart';

class ProfileSectionDateFormatter {
  const ProfileSectionDateFormatter._();

  static String format(DateTime? date) {
    if (date == null) {
      return '';
    }
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatRange(DateTime? start, DateTime? end) {
    final startLabel = format(start);
    final endLabel = format(end);
    if (startLabel.isEmpty && endLabel.isEmpty) {
      return '';
    }
    if (startLabel.isEmpty) {
      return endLabel;
    }
    if (endLabel.isEmpty) {
      return startLabel;
    }
    return '$startLabel - $endLabel';
  }
}
