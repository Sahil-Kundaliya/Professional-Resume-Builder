import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_profile.freezed.dart';

@freezed
class ResumeProfile with _$ResumeProfile {
  const factory ResumeProfile({
    @Default('default-profile') String id,
    @Default('') String profileImagePath,
    @Default('Your Name') String fullName,
    @Default('Your Job Title') String jobTitle,
    @Default('') String summary,
    @Default('') String email,
    @Default('') String address,
    @Default('+1') String phoneCountryCode,
    @Default('') String phoneNumber,
    DateTime? birthDate,
    @Default('') String portfolioLink,
    @Default(<ProfileSkill>[]) List<ProfileSkill> skills,
    @Default(<ProfileHobby>[]) List<ProfileHobby> hobbies,
    @Default(<ProfileExperience>[]) List<ProfileExperience> experiences,
    @Default(<ProfileEducation>[]) List<ProfileEducation> educationRecords,
    @Default(<ProfileAward>[]) List<ProfileAward> awards,
    @Default(<ProfileCertification>[])
    List<ProfileCertification> certifications,
    DateTime? updatedAt,
  }) = _ResumeProfile;

  factory ResumeProfile.initial() => ResumeProfile(
        skills: const [ProfileSkill()],
        hobbies: const [ProfileHobby()],
      );
}

@freezed
class ProfileSkill with _$ProfileSkill {
  const factory ProfileSkill({
    @Default('') String name,
    @Default(1) int rating,
  }) = _ProfileSkill;
}

@freezed
class ProfileHobby with _$ProfileHobby {
  const factory ProfileHobby({
    @Default('') String name,
  }) = _ProfileHobby;
}

@freezed
class ProfileExperience with _$ProfileExperience {
  const factory ProfileExperience({
    @Default('') String companyName,
    @Default('') String position,
    DateTime? startDate,
    DateTime? endDate,
    @Default(<String>['']) List<String> detailLines,
  }) = _ProfileExperience;
}

@freezed
class ProfileEducation with _$ProfileEducation {
  const factory ProfileEducation({
    @Default('') String schoolName,
    @Default('') String degreeName,
    DateTime? startDate,
    DateTime? endDate,
  }) = _ProfileEducation;
}

@freezed
class ProfileAward with _$ProfileAward {
  const factory ProfileAward({
    @Default('') String title,
    DateTime? date,
  }) = _ProfileAward;
}

@freezed
class ProfileCertification with _$ProfileCertification {
  const factory ProfileCertification({
    @Default('') String title,
    DateTime? date,
  }) = _ProfileCertification;
}

@freezed
class ProfileValidationErrors with _$ProfileValidationErrors {
  const factory ProfileValidationErrors({
    @Default(<String, String>{}) Map<String, String> fieldErrors,
    @Default(<String, String>{}) Map<String, String> recordErrors,
  }) = _ProfileValidationErrors;
}

@freezed
class ProfileEditDraft with _$ProfileEditDraft {
  const factory ProfileEditDraft({
    required ResumeProfile profile,
    @Default(ProfileValidationErrors())
    ProfileValidationErrors validationErrors,
    @Default(false) bool hasUnsavedChanges,
  }) = _ProfileEditDraft;

  factory ProfileEditDraft.initial() => ProfileEditDraft(
        profile: ResumeProfile.initial(),
      );
}
