import '../../domain/entities/resume_template.dart';

enum ResumeFormSection {
  profileImage,
  profileBasics,
  workExperience,
  education,
  skills,
  hobbies,
  awards,
  certifications,
  references,
}

class ResumeFormSectionSupport {
  const ResumeFormSectionSupport._();

  static List<ResumeFormSection> resolve(ResumeTemplate? template) {
    final sections = <ResumeFormSection>[
      ResumeFormSection.profileBasics,
      ResumeFormSection.workExperience,
      ResumeFormSection.education,
      ResumeFormSection.skills,
      ResumeFormSection.hobbies,
      ResumeFormSection.awards,
      ResumeFormSection.certifications,
      ResumeFormSection.references,
    ];

    if (template?.hasPhoto ?? true) {
      sections.insert(0, ResumeFormSection.profileImage);
    }

    return sections;
  }
}
