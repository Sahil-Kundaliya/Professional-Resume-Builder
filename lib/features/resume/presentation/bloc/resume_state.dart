import 'package:freezed_annotation/freezed_annotation.dart';
import '../constants/resume_form_messages.dart';
import '../../domain/entities/resume_document.dart';
import '../../domain/entities/resume_template.dart';

part 'resume_state.freezed.dart';

@freezed
class ResumeState with _$ResumeState {
  const factory ResumeState.initial() = _Initial;
  const factory ResumeState.loading() = _Loading;
  const factory ResumeState.loaded({
    required ResumeDocument document,
    ResumeTemplate? template,
    @Default(<String, String>{}) Map<String, String> fieldErrors,
    @Default(<String>{}) Set<String> missingRequiredFields,
    @Default(false) bool canPreview,
    ResumeFormMessage? feedbackMessage,
    @Default(false) bool previewRequested,
    @Default(false) bool isPreviewValidationInProgress,
  }) = _Loaded;
  const factory ResumeState.saving() = _Saving;
  const factory ResumeState.saved({
    required ResumeDocument document,
    ResumeTemplate? template,
    @Default(<String, String>{}) Map<String, String> fieldErrors,
    @Default(<String>{}) Set<String> missingRequiredFields,
    @Default(false) bool canPreview,
    ResumeFormMessage? feedbackMessage,
    @Default(false) bool previewRequested,
    @Default(false) bool isPreviewValidationInProgress,
  }) = _Saved;
  const factory ResumeState.error(String message) = _Error;
}
