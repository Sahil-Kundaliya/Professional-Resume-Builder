import '../../../profile/domain/entities/resume_profile.dart';
import '../entities/profile_availability_result.dart';
import 'profile_value_guards.dart';

class ProfileAvailabilityEvaluator {
  ProfileAvailabilityEvaluator({
    required this.guards,
  });

  final ProfileValueGuards guards;

  static const Set<String> _fullNameDefaults = {'Your Name'};
  static const Set<String> _jobTitleDefaults = {'Your Job Title'};

  ProfileAvailabilityResult evaluate(ResumeProfile profile) {
    final usableFieldKeys = <String>[];

    if (guards.hasText(profile.profileImagePath)) usableFieldKeys.add('image');
    if (guards.hasText(profile.fullName, blockedValues: _fullNameDefaults)) {
      usableFieldKeys.add('fullName');
    }
    if (guards.hasText(profile.jobTitle, blockedValues: _jobTitleDefaults)) {
      usableFieldKeys.add('jobTitle');
    }
    if (guards.hasText(profile.summary)) usableFieldKeys.add('summary');
    if (guards.hasText(profile.email)) usableFieldKeys.add('email');
    if (guards.hasText(profile.address)) usableFieldKeys.add('address');
    if (guards.hasDate(profile.birthDate)) usableFieldKeys.add('birthDate');
    if (guards.hasText(profile.portfolioLink)) usableFieldKeys.add('portfolio');

    final hasPhone = guards.hasText(profile.phoneNumber);
    if (hasPhone) usableFieldKeys.add('phone');

    if (profile.skills.any(guards.hasMeaningfulSkill)) {
      usableFieldKeys.add('skills');
    }
    if (profile.hobbies.any(guards.hasMeaningfulHobby)) {
      usableFieldKeys.add('hobbies');
    }
    if (profile.experiences.any(guards.hasMeaningfulExperience)) {
      usableFieldKeys.add('experience');
    }
    if (profile.educationRecords.any(guards.hasMeaningfulEducation)) {
      usableFieldKeys.add('education');
    }
    if (profile.awards.any(guards.hasMeaningfulAward)) {
      usableFieldKeys.add('awards');
    }
    if (profile.certifications.any(guards.hasMeaningfulCertification)) {
      usableFieldKeys.add('certifications');
    }

    return ProfileAvailabilityResult(
      hasUsableData: usableFieldKeys.isNotEmpty,
      usableFieldKeys: usableFieldKeys,
      sourceState: usableFieldKeys.isNotEmpty
          ? ProfileAvailabilitySourceState.loaded
          : ProfileAvailabilitySourceState.empty,
    );
  }
}
