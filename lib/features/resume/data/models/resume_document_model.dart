import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_document_model.freezed.dart';
part 'resume_document_model.g.dart';

@freezed
class ResumeDocumentDto with _$ResumeDocumentDto {
  const factory ResumeDocumentDto({
    required String id,
    required String photoPath,
    required String fullName,
    required String jobPosition,
    required String careerGoals,
    required String email,
    required String phone,
    required String address,
    required String birthday,
    required String website,
    @Default(ResumeHeaderStylesDto()) ResumeHeaderStylesDto headerStyles,
    required List<WorkExperienceEntryDto> workExperience,
    required List<EducationEntryDto> education,
    required List<String> references,
    required List<String> hobbies,
    required List<SkillEntryDto> skills,
    required List<AwardEntryDto> awards,
    required List<CertEntryDto> certifications,
  }) = _ResumeDocumentDto;

  factory ResumeDocumentDto.fromJson(Map<String, dynamic> json) =>
      _$ResumeDocumentDtoFromJson(json);
}

@freezed
class ResumeTextStyleSpecDto with _$ResumeTextStyleSpecDto {
  const factory ResumeTextStyleSpecDto({
    @Default(false) bool isBold,
    @Default(false) bool isItalic,
    @Default(false) bool isUnderline,
    @Default('Inter') String fontFamily,
    @Default(0xDD000000) int textColorValue,
  }) = _ResumeTextStyleSpecDto;

  factory ResumeTextStyleSpecDto.fromJson(Map<String, dynamic> json) =>
      _$ResumeTextStyleSpecDtoFromJson(json);
}

@freezed
class ResumeHeaderStylesDto with _$ResumeHeaderStylesDto {
  const factory ResumeHeaderStylesDto({
    @Default(ResumeTextStyleSpecDto(
      isBold: true,
      fontFamily: 'Inter',
      textColorValue: 0xDD000000,
    ))
    ResumeTextStyleSpecDto fullNameStyle,
    @Default(ResumeTextStyleSpecDto(
      fontFamily: 'Inter',
      textColorValue: 0xFF757575,
    ))
    ResumeTextStyleSpecDto jobPositionStyle,
    @Default(ResumeTextStyleSpecDto(
      fontFamily: 'Inter',
      textColorValue: 0xDD000000,
    ))
    ResumeTextStyleSpecDto careerGoalsStyle,
  }) = _ResumeHeaderStylesDto;

  factory ResumeHeaderStylesDto.fromJson(Map<String, dynamic> json) =>
      _$ResumeHeaderStylesDtoFromJson(json);
}

@freezed
class WorkExperienceEntryDto with _$WorkExperienceEntryDto {
  const factory WorkExperienceEntryDto({
    required String dateRange,
    required String position,
    required String companyName,
    required String description,
  }) = _WorkExperienceEntryDto;

  factory WorkExperienceEntryDto.fromJson(Map<String, dynamic> json) =>
      _$WorkExperienceEntryDtoFromJson(json);
}

@freezed
class EducationEntryDto with _$EducationEntryDto {
  const factory EducationEntryDto({
    required String dateRange,
    required String coursesSubjects,
    required String schoolName,
    required String description,
  }) = _EducationEntryDto;

  factory EducationEntryDto.fromJson(Map<String, dynamic> json) =>
      _$EducationEntryDtoFromJson(json);
}

@freezed
class SkillEntryDto with _$SkillEntryDto {
  const factory SkillEntryDto({
    required String name,
    required int rating,
  }) = _SkillEntryDto;

  factory SkillEntryDto.fromJson(Map<String, dynamic> json) =>
      _$SkillEntryDtoFromJson(json);
}

@freezed
class AwardEntryDto with _$AwardEntryDto {
  const factory AwardEntryDto({
    required String year,
    required String name,
  }) = _AwardEntryDto;

  factory AwardEntryDto.fromJson(Map<String, dynamic> json) =>
      _$AwardEntryDtoFromJson(json);
}

@freezed
class CertEntryDto with _$CertEntryDto {
  const factory CertEntryDto({
    required String year,
    required String name,
  }) = _CertEntryDto;

  factory CertEntryDto.fromJson(Map<String, dynamic> json) =>
      _$CertEntryDtoFromJson(json);
}
