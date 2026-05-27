enum ResumeFormMessageType {
  missingRequired,
  validationFailed,
  previewFailed,
  unexpectedError,
}

class ResumeFormMessage {
  final ResumeFormMessageType type;
  final String title;
  final String message;
  final String resolutionHint;

  const ResumeFormMessage({
    required this.type,
    required this.title,
    required this.message,
    required this.resolutionHint,
  });

  String get fullText => '$title\n$message\n$resolutionHint';
}

class ResumeFormMessages {
  const ResumeFormMessages._();

  static ResumeFormMessage missingRequired(List<String> fieldLabels) {
    final labels = fieldLabels
        .map((label) => label.trim())
        .where((label) => label.isNotEmpty)
        .toList(growable: false);
    final readable =
        labels.isEmpty ? 'Required information' : labels.join(', ');
    return ResumeFormMessage(
      type: ResumeFormMessageType.missingRequired,
      title: 'Missing required details',
      message: 'Please complete: $readable.',
      resolutionHint: 'Fill the missing fields, then tap Preview again.',
    );
  }

  static ResumeFormMessage validationFailed(List<String> issues) {
    final cleaned = issues
        .map((issue) => issue.trim())
        .where((issue) => issue.isNotEmpty)
        .toList(growable: false);
    final details =
        cleaned.isEmpty ? 'Some values are invalid.' : cleaned.join(' ');
    return ResumeFormMessage(
      type: ResumeFormMessageType.validationFailed,
      title: 'Please review your entries',
      message: details,
      resolutionHint: 'Correct the highlighted values and try Preview again.',
    );
  }

  static ResumeFormMessage previewFailed() {
    return const ResumeFormMessage(
      type: ResumeFormMessageType.previewFailed,
      title: 'Preview could not be generated',
      message: 'We were unable to prepare your preview right now.',
      resolutionHint:
          'Try again in a moment. If the issue continues, review your form data.',
    );
  }

  static ResumeFormMessage unexpectedError() {
    return const ResumeFormMessage(
      type: ResumeFormMessageType.unexpectedError,
      title: 'Something went wrong',
      message: 'An unexpected error occurred while processing your resume.',
      resolutionHint: 'Please try again.',
    );
  }
}
