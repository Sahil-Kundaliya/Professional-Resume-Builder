import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/resume_profile.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = _Loading;
  const factory ProfileState.loaded({
    required ResumeProfile profile,
    required ProfileEditDraft draft,
    @Default(false) bool isEditing,
    @Default(false) bool isSaving,
  }) = _Loaded;
  const factory ProfileState.error(String message) = _Error;
}
