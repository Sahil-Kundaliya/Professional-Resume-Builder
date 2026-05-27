import '../../domain/entities/resume_document.dart';
import 'resume_form_validators.dart';

class ResumeFormContentPredicates {
  const ResumeFormContentPredicates._();

  static bool hasMeaningfulProfile(ResumeDocument document) {
    return ResumeFormValidators.hasMeaningfulValue(document.fullName) ||
        ResumeFormValidators.hasMeaningfulValue(document.jobPosition) ||
        ResumeFormValidators.hasMeaningfulValue(document.careerGoals) ||
        ResumeFormValidators.hasMeaningfulValue(document.email) ||
        ResumeFormValidators.hasMeaningfulValue(document.phone) ||
        ResumeFormValidators.hasMeaningfulValue(document.address) ||
        ResumeFormValidators.hasMeaningfulValue(document.birthday) ||
        ResumeFormValidators.hasMeaningfulValue(document.website);
  }

  static bool hasMeaningfulWorkExperience(List<WorkExperienceEntry> entries) {
    return entries.any((entry) =>
        ResumeFormValidators.hasMeaningfulValue(entry.dateRange) ||
        ResumeFormValidators.hasMeaningfulValue(entry.position) ||
        ResumeFormValidators.hasMeaningfulValue(entry.companyName) ||
        ResumeFormValidators.hasMeaningfulValue(entry.description));
  }

  static bool hasMeaningfulEducation(List<EducationEntry> entries) {
    return entries.any((entry) =>
        ResumeFormValidators.hasMeaningfulValue(entry.dateRange) ||
        ResumeFormValidators.hasMeaningfulValue(entry.coursesSubjects) ||
        ResumeFormValidators.hasMeaningfulValue(entry.schoolName) ||
        ResumeFormValidators.hasMeaningfulValue(entry.description));
  }

  static bool hasMeaningfulSkills(List<SkillEntry> entries) {
    return entries.any(
      (entry) => ResumeFormValidators.hasMeaningfulValue(entry.name),
    );
  }

  static bool hasMeaningfulAwards(List<AwardEntry> entries) {
    return entries.any((entry) =>
        ResumeFormValidators.hasMeaningfulValue(entry.name) ||
        ResumeFormValidators.hasMeaningfulValue(entry.year));
  }

  static bool hasMeaningfulCertifications(List<CertEntry> entries) {
    return entries.any((entry) =>
        ResumeFormValidators.hasMeaningfulValue(entry.name) ||
        ResumeFormValidators.hasMeaningfulValue(entry.year));
  }
}
