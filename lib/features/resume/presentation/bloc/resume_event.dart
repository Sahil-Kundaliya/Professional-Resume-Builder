import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../profile/domain/entities/resume_profile.dart';
import '../../domain/entities/resume_document.dart';
import '../../domain/entities/resume_template.dart';

part 'resume_event.freezed.dart';

@freezed
class ResumeEvent with _$ResumeEvent {
  const factory ResumeEvent.loadResume(String resumeId) = LoadResume;
  const factory ResumeEvent.createResume(
    ResumeTemplate template, {
    ResumeProfile? prefillProfile,
  }) = CreateResume;

  const factory ResumeEvent.updateFullName(String value) = UpdateFullName;
  const factory ResumeEvent.updateJobPosition(String value) = UpdateJobPosition;
  const factory ResumeEvent.updateCareerGoals(String value) = UpdateCareerGoals;
  const factory ResumeEvent.updateEmail(String value) = UpdateEmail;
  const factory ResumeEvent.updatePhone(String value) = UpdatePhone;
  const factory ResumeEvent.updateAddress(String value) = UpdateAddress;
  const factory ResumeEvent.updateBirthday(String value) = UpdateBirthday;
  const factory ResumeEvent.updateWebsite(String value) = UpdateWebsite;
  const factory ResumeEvent.updatePhoto(String path) = UpdatePhoto;
  const factory ResumeEvent.updateWorkExperience(
    List<WorkExperienceEntry> value,
  ) = UpdateWorkExperience;
  const factory ResumeEvent.updateEducation(
    List<EducationEntry> value,
  ) = UpdateEducation;
  const factory ResumeEvent.updateSkills(List<SkillEntry> value) = UpdateSkills;
  const factory ResumeEvent.updateHobbies(List<String> value) = UpdateHobbies;
  const factory ResumeEvent.updateAwards(List<AwardEntry> value) = UpdateAwards;
  const factory ResumeEvent.updateCertifications(
    List<CertEntry> value,
  ) = UpdateCertifications;
  const factory ResumeEvent.updateReferences(List<String> value) =
      UpdateReferences;
  const factory ResumeEvent.validateForPreview() = ValidateForPreview;
  const factory ResumeEvent.clearFieldError(String fieldKey) = ClearFieldError;
  const factory ResumeEvent.consumeFeedback() = ConsumeFeedback;
  const factory ResumeEvent.consumePreviewRequest() = ConsumePreviewRequest;
  const factory ResumeEvent.saveResume() = SaveResume;
  const factory ResumeEvent.loadSample() = LoadSample;
}
