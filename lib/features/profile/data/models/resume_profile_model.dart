import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_profile_model.freezed.dart';
part 'resume_profile_model.g.dart';

@freezed
class ResumeProfileModel with _$ResumeProfileModel {
  const factory ResumeProfileModel({
    required String id,
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
    @Default(<ProfileSkillModel>[]) List<ProfileSkillModel> skills,
    @Default(<ProfileHobbyModel>[]) List<ProfileHobbyModel> hobbies,
    @Default(<ProfileExperienceModel>[])
    List<ProfileExperienceModel> experiences,
    @Default(<ProfileEducationModel>[])
    List<ProfileEducationModel> educationRecords,
    @Default(<ProfileAwardModel>[]) List<ProfileAwardModel> awards,
    @Default(<ProfileCertificationModel>[])
    List<ProfileCertificationModel> certifications,
    DateTime? updatedAt,
  }) = _ResumeProfileModel;

  factory ResumeProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ResumeProfileModelFromJson(json);
}

@freezed
class ProfileSkillModel with _$ProfileSkillModel {
  const factory ProfileSkillModel({
    @Default('') String name,
    @Default(1) int rating,
  }) = _ProfileSkillModel;

  factory ProfileSkillModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileSkillModelFromJson(json);
}

@freezed
class ProfileHobbyModel with _$ProfileHobbyModel {
  const factory ProfileHobbyModel({
    @Default('') String name,
  }) = _ProfileHobbyModel;

  factory ProfileHobbyModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileHobbyModelFromJson(json);
}

@freezed
class ProfileExperienceModel with _$ProfileExperienceModel {
  const factory ProfileExperienceModel({
    @Default('') String companyName,
    @Default('') String position,
    DateTime? startDate,
    DateTime? endDate,
    @Default(<String>['']) List<String> detailLines,
  }) = _ProfileExperienceModel;

  factory ProfileExperienceModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileExperienceModelFromJson(json);
}

@freezed
class ProfileEducationModel with _$ProfileEducationModel {
  const factory ProfileEducationModel({
    @Default('') String schoolName,
    @Default('') String degreeName,
    DateTime? startDate,
    DateTime? endDate,
  }) = _ProfileEducationModel;

  factory ProfileEducationModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileEducationModelFromJson(json);
}

@freezed
class ProfileAwardModel with _$ProfileAwardModel {
  const factory ProfileAwardModel({
    @Default('') String title,
    DateTime? date,
  }) = _ProfileAwardModel;

  factory ProfileAwardModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileAwardModelFromJson(json);
}

@freezed
class ProfileCertificationModel with _$ProfileCertificationModel {
  const factory ProfileCertificationModel({
    @Default('') String title,
    DateTime? date,
  }) = _ProfileCertificationModel;

  factory ProfileCertificationModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileCertificationModelFromJson(json);
}
