import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/resume_profile.dart';

part 'profile_event.freezed.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.loadProfile() = LoadProfile;
  const factory ProfileEvent.startEditing() = StartEditing;
  const factory ProfileEvent.updateDraft(ProfileEditDraft draft) = UpdateDraft;
  const factory ProfileEvent.saveProfile() = SaveProfile;
}
