import '../../../features/resume/domain/entities/resume_document.dart';

class PdfSectionVisibility {
  static bool isBlank(String? value) {
    return value == null || value.trim().isEmpty;
  }

  static bool isNotBlank(String? value) {
    return !isBlank(value);
  }

  static List<String> nonBlankValues(Iterable<String> values) {
    return values
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();
  }

  static bool hasProfileValues(ResumeDocument data) {
    return [data.email, data.phone, data.address, data.birthday, data.website]
        .any(isNotBlank);
  }

  static bool hasSummaryValue(ResumeDocument data) {
    return isNotBlank(data.careerGoals);
  }

  static bool hasWorkExperience(ResumeDocument data) {
    return data.workExperience.any((entry) {
      return [
        entry.dateRange,
        entry.position,
        entry.companyName,
        entry.description,
      ].any(isNotBlank);
    });
  }

  static bool hasEducation(ResumeDocument data) {
    return data.education.any((entry) {
      return [
        entry.dateRange,
        entry.coursesSubjects,
        entry.schoolName,
        entry.description,
      ].any(isNotBlank);
    });
  }

  static bool hasSkills(ResumeDocument data) {
    return data.skills.any((entry) => isNotBlank(entry.name));
  }

  static bool hasAwards(ResumeDocument data) {
    return data.awards.any((entry) {
      return [entry.year, entry.name].any(isNotBlank);
    });
  }

  static bool hasCertifications(ResumeDocument data) {
    return data.certifications.any((entry) {
      return [entry.year, entry.name].any(isNotBlank);
    });
  }

  static bool hasReferences(ResumeDocument data) {
    return nonBlankValues(data.references).isNotEmpty;
  }

  static bool hasHobbies(ResumeDocument data) {
    return nonBlankValues(data.hobbies).isNotEmpty;
  }
}
