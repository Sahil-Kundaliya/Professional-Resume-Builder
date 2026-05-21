import '../../domain/entities/resume_profile.dart';

class ProfileSectionValidators {
  const ProfileSectionValidators._();

  static String? validateExperience(ProfileExperience experience) {
    if (experience.companyName.trim().isEmpty) {
      return 'Company name is required';
    }
    if (experience.position.trim().isEmpty) {
      return 'Job position is required';
    }
    if (experience.startDate == null) {
      return 'Start date is required';
    }
    if (experience.endDate == null) {
      return 'End date is required';
    }
    if (experience.endDate!.isBefore(experience.startDate!)) {
      return 'End date cannot be before start date';
    }
    if (experience.detailLines.every((line) => line.trim().isEmpty)) {
      return 'At least one detail is required';
    }
    return null;
  }

  static String? validateEducation(ProfileEducation education) {
    if (education.schoolName.trim().isEmpty) {
      return 'School or college name is required';
    }
    if (education.degreeName.trim().isEmpty) {
      return 'Degree is required';
    }
    if (education.startDate == null) {
      return 'Start date is required';
    }
    if (education.endDate == null) {
      return 'End date is required';
    }
    if (education.endDate!.isBefore(education.startDate!)) {
      return 'End date cannot be before start date';
    }
    return null;
  }

  static String? validateAward(ProfileAward award) {
    if (award.title.trim().isEmpty) {
      return 'Title is required';
    }
    if (award.date == null) {
      return 'Date is required';
    }
    return null;
  }

  static String? validateCertification(ProfileCertification certification) {
    if (certification.title.trim().isEmpty) {
      return 'Title is required';
    }
    if (certification.date == null) {
      return 'Date is required';
    }
    return null;
  }
}
