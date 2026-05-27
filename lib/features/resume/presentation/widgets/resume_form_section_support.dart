import '../../domain/entities/resume_document.dart';
import '../../domain/entities/resume_template.dart';
import '../../domain/entities/template_field_configuration.dart';
import 'resume_form_validators.dart';

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
    final config = template?.fieldConfiguration;
    if (config == null) {
      return _defaultSections(template);
    }

    final sections = <ResumeFormSection>[
      if (_hasAnyVisibleProfileField(config)) ResumeFormSection.profileBasics,
      if (config.isVisible(TemplateFieldKeys.workExperience))
        ResumeFormSection.workExperience,
      if (config.isVisible(TemplateFieldKeys.education))
        ResumeFormSection.education,
      if (config.isVisible(TemplateFieldKeys.skills)) ResumeFormSection.skills,
      if (config.isVisible(TemplateFieldKeys.hobbies))
        ResumeFormSection.hobbies,
      if (config.isVisible(TemplateFieldKeys.awards)) ResumeFormSection.awards,
      if (config.isVisible(TemplateFieldKeys.certifications))
        ResumeFormSection.certifications,
      if (config.isVisible(TemplateFieldKeys.references))
        ResumeFormSection.references,
    ];

    if ((template?.hasPhoto ?? true) &&
        config.isVisible(TemplateFieldKeys.photo)) {
      sections.insert(0, ResumeFormSection.profileImage);
    }

    return sections.isEmpty ? _defaultSections(template) : sections;
  }

  static bool shouldRenderInPreview(
    ResumeFormSection section,
    ResumeDocument document,
  ) {
    return switch (section) {
      ResumeFormSection.profileImage =>
        ResumeFormValidators.hasMeaningfulValue(document.photoPath),
      ResumeFormSection.profileBasics => true,
      ResumeFormSection.workExperience => document.workExperience.isNotEmpty,
      ResumeFormSection.education => document.education.isNotEmpty,
      ResumeFormSection.skills =>
        document.skills.any((item) => item.name.trim().isNotEmpty),
      ResumeFormSection.hobbies =>
        ResumeFormValidators.hasAnyMeaningfulText(document.hobbies),
      ResumeFormSection.awards =>
        document.awards.any((item) => item.name.trim().isNotEmpty),
      ResumeFormSection.certifications =>
        document.certifications.any((item) => item.name.trim().isNotEmpty),
      ResumeFormSection.references =>
        ResumeFormValidators.hasAnyMeaningfulText(document.references),
    };
  }

  static List<ResumeFormSection> resolvePreviewSections({
    required ResumeDocument document,
    required ResumeTemplate? template,
  }) {
    final sections = resolve(template);
    return sections
        .where((section) => shouldRenderInPreview(section, document))
        .toList(growable: false);
  }

  static List<ResumeFormSection> _defaultSections(ResumeTemplate? template) {
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

  static bool _hasAnyVisibleProfileField(TemplateFieldConfiguration config) {
    return config.isVisible(TemplateFieldKeys.fullName) ||
        config.isVisible(TemplateFieldKeys.jobPosition) ||
        config.isVisible(TemplateFieldKeys.summary) ||
        config.isVisible(TemplateFieldKeys.birthDate) ||
        config.isVisible(TemplateFieldKeys.email) ||
        config.isVisible(TemplateFieldKeys.phone) ||
        config.isVisible(TemplateFieldKeys.address) ||
        config.isVisible(TemplateFieldKeys.website);
  }
}
