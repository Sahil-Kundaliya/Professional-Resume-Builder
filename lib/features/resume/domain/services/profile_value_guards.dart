import '../../../profile/domain/entities/resume_profile.dart';

class ProfileValueGuards {
  const ProfileValueGuards();

  bool hasText(String? value, {Set<String> blockedValues = const {}}) {
    if (value == null) return false;
    final normalized = value.trim();
    if (normalized.isEmpty) return false;
    return !blockedValues.contains(normalized);
  }

  bool hasDate(DateTime? value) => value != null;

  bool hasMeaningfulSkill(ProfileSkill skill) => hasText(skill.name);

  bool hasMeaningfulHobby(ProfileHobby hobby) => hasText(hobby.name);

  bool hasMeaningfulExperience(ProfileExperience item) {
    final hasDetails = item.detailLines.any((line) => hasText(line));
    return hasText(item.companyName) ||
        hasText(item.position) ||
        hasDate(item.startDate) ||
        hasDate(item.endDate) ||
        hasDetails;
  }

  bool hasMeaningfulEducation(ProfileEducation item) {
    return hasText(item.schoolName) ||
        hasText(item.degreeName) ||
        hasDate(item.startDate) ||
        hasDate(item.endDate);
  }

  bool hasMeaningfulAward(ProfileAward item) {
    return hasText(item.title) || hasDate(item.date);
  }

  bool hasMeaningfulCertification(ProfileCertification item) {
    return hasText(item.title) || hasDate(item.date);
  }
}
