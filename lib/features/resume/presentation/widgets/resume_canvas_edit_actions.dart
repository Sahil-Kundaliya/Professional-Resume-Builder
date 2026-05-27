enum ResumeCanvasEditActionType {
  deleteSelectedItem,
  toggleSectionVisibility,
  updateSectionTitle,
  launchImageEditor,
  applyImageEdit,
}

enum ResumeCanvasActionFeedbackKind {
  info,
  warning,
  error,
}

class ResumeCanvasEditActionFeedback {
  const ResumeCanvasEditActionFeedback({
    required this.message,
    this.kind = ResumeCanvasActionFeedbackKind.info,
  });

  final String message;
  final ResumeCanvasActionFeedbackKind kind;
}
