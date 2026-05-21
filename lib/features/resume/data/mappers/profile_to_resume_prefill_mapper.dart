import '../../../profile/domain/entities/resume_profile.dart';
import '../../domain/entities/resume_document.dart';
import '../../domain/services/profile_value_guards.dart';

class ProfileToResumePrefillMapper {
  ProfileToResumePrefillMapper({
    required this.guards,
  });

  final ProfileValueGuards guards;

  ResumeDocument applyPrefill({
    required ResumeDocument base,
    required ResumeProfile profile,
  }) {
    // Apply each mapped field independently so missing values do not block
    // the rest of the prefill pipeline.
    var next = base;

    if (guards.hasText(profile.profileImagePath)) {
      next = next.copyWith(photoPath: profile.profileImagePath.trim());
    }

    if (guards.hasText(profile.fullName, blockedValues: {'Your Name'})) {
      next = next.copyWith(fullName: profile.fullName.trim());
    }

    if (guards.hasText(profile.jobTitle, blockedValues: {'Your Job Title'})) {
      next = next.copyWith(jobPosition: profile.jobTitle.trim());
    }

    if (guards.hasText(profile.summary)) {
      next = next.copyWith(careerGoals: profile.summary.trim());
    }

    if (guards.hasText(profile.email)) {
      next = next.copyWith(email: profile.email.trim());
    }

    if (guards.hasText(profile.address)) {
      next = next.copyWith(address: profile.address.trim());
    }

    if (guards.hasDate(profile.birthDate)) {
      next = next.copyWith(birthday: _formatDate(profile.birthDate!));
    }

    if (guards.hasText(profile.portfolioLink)) {
      next = next.copyWith(website: profile.portfolioLink.trim());
    }

    if (guards.hasText(profile.phoneNumber)) {
      final phone = _formatPhone(profile.phoneCountryCode, profile.phoneNumber);
      if (guards.hasText(phone)) {
        next = next.copyWith(phone: phone);
      }
    }

    final skills = profile.skills
        .where(guards.hasMeaningfulSkill)
        .map(
          (item) => SkillEntry(
            name: item.name.trim(),
            rating: item.rating.clamp(1, 5),
          ),
        )
        .toList();
    if (skills.isNotEmpty) {
      next = next.copyWith(skills: skills);
    }

    final hobbies = profile.hobbies
        .where(guards.hasMeaningfulHobby)
        .map((item) => item.name.trim())
        .toList();
    if (hobbies.isNotEmpty) {
      next = next.copyWith(hobbies: hobbies);
    }

    final workExperience = profile.experiences
        .where(guards.hasMeaningfulExperience)
        .map(
          (item) => WorkExperienceEntry(
            dateRange: _dateRange(item.startDate, item.endDate),
            position: guards.hasText(item.position)
                ? item.position.trim()
                : next.workExperience.first.position,
            companyName: guards.hasText(item.companyName)
                ? item.companyName.trim()
                : next.workExperience.first.companyName,
            description: _descriptionOrDefault(
              item.detailLines,
              next.workExperience.first.description,
            ),
          ),
        )
        .toList();
    if (workExperience.isNotEmpty) {
      next = next.copyWith(workExperience: workExperience);
    }

    final education = profile.educationRecords
        .where(guards.hasMeaningfulEducation)
        .map(
          (item) => EducationEntry(
            dateRange: _dateRange(item.startDate, item.endDate),
            coursesSubjects: guards.hasText(item.degreeName)
                ? item.degreeName.trim()
                : next.education.first.coursesSubjects,
            schoolName: guards.hasText(item.schoolName)
                ? item.schoolName.trim()
                : next.education.first.schoolName,
            description: guards.hasText(item.degreeName)
                ? item.degreeName.trim()
                : next.education.first.description,
          ),
        )
        .toList();
    if (education.isNotEmpty) {
      next = next.copyWith(education: education);
    }

    final awards = profile.awards
        .where(guards.hasMeaningfulAward)
        .map(
          (item) => AwardEntry(
            year: item.date != null
                ? _formatYear(item.date!)
                : next.awards.first.year,
            name: guards.hasText(item.title)
                ? item.title.trim()
                : next.awards.first.name,
          ),
        )
        .toList();
    if (awards.isNotEmpty) {
      next = next.copyWith(awards: awards);
    }

    final certifications = profile.certifications
        .where(guards.hasMeaningfulCertification)
        .map(
          (item) => CertEntry(
            year: item.date != null
                ? _formatYear(item.date!)
                : next.certifications.first.year,
            name: guards.hasText(item.title)
                ? item.title.trim()
                : next.certifications.first.name,
          ),
        )
        .toList();
    if (certifications.isNotEmpty) {
      next = next.copyWith(certifications: certifications);
    }

    return next;
  }

  String _formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day/$month/${value.year}';
  }

  String _formatYear(DateTime value) => value.year.toString();

  String _formatPhone(String countryCode, String number) {
    final normalizedCode = countryCode.trim();
    final normalizedNumber = number.trim();
    if (normalizedCode.isEmpty) return normalizedNumber;
    return '$normalizedCode $normalizedNumber'.trim();
  }

  String _dateRange(DateTime? start, DateTime? end) {
    final startPart = start != null ? _formatMonthYear(start) : 'From';
    final endPart = end != null ? _formatMonthYear(end) : 'To';
    return '$startPart • $endPart';
  }

  String _formatMonthYear(DateTime value) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[value.month - 1]} ${value.year}';
  }

  String _descriptionOrDefault(List<String> lines, String fallback) {
    // Keep the target section readable even when profile details are partial.
    final sanitized = lines
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    if (sanitized.isEmpty) return fallback;
    return sanitized.join('\n');
  }
}
