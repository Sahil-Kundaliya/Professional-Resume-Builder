import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/resume_document.dart';
import '../../domain/entities/resume_template.dart';

part 'resume_state.freezed.dart';

@freezed
class ResumeState with _$ResumeState {
  const factory ResumeState.initial() = _Initial;
  const factory ResumeState.loading() = _Loading;
  const factory ResumeState.loaded({
    required ResumeDocument document,
    required String? selectedFieldId,
    ResumeTemplate? template,
  }) = _Loaded;
  const factory ResumeState.saving() = _Saving;
  const factory ResumeState.saved({
    required ResumeDocument document,
    required String? selectedFieldId,
    ResumeTemplate? template,
  }) = _Saved;
  const factory ResumeState.error(String message) = _Error;
}
