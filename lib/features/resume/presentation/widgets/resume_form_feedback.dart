import 'package:flutter/material.dart';

import '../constants/resume_form_messages.dart';

class ResumeFormFeedback {
  const ResumeFormFeedback._();

  static void show(BuildContext context, ResumeFormMessage message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message.fullText),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
