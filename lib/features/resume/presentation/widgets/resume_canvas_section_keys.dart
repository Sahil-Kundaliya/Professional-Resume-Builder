enum ResumeCanvasSectionKey {
  profile,
  workExperience,
  education,
  skills,
  hobbies,
  awards,
  certifications,
  references,
}

class ResumeCanvasSectionKeyX {
  static const Set<ResumeCanvasSectionKey> toggleableSections = {
    ResumeCanvasSectionKey.profile,
    ResumeCanvasSectionKey.workExperience,
    ResumeCanvasSectionKey.education,
    ResumeCanvasSectionKey.skills,
    ResumeCanvasSectionKey.hobbies,
    ResumeCanvasSectionKey.awards,
    ResumeCanvasSectionKey.certifications,
    ResumeCanvasSectionKey.references,
  };

  static String storageKey(ResumeCanvasSectionKey value) {
    return switch (value) {
      ResumeCanvasSectionKey.profile => 'profile',
      ResumeCanvasSectionKey.workExperience => 'work_experience',
      ResumeCanvasSectionKey.education => 'education',
      ResumeCanvasSectionKey.skills => 'skills',
      ResumeCanvasSectionKey.hobbies => 'hobbies',
      ResumeCanvasSectionKey.awards => 'awards',
      ResumeCanvasSectionKey.certifications => 'certifications',
      ResumeCanvasSectionKey.references => 'references',
    };
  }

  static String defaultTitle(ResumeCanvasSectionKey value) {
    return switch (value) {
      ResumeCanvasSectionKey.profile => 'Profile',
      ResumeCanvasSectionKey.workExperience => 'Work experience',
      ResumeCanvasSectionKey.education => 'Education',
      ResumeCanvasSectionKey.skills => 'Skills',
      ResumeCanvasSectionKey.hobbies => 'Hobbies',
      ResumeCanvasSectionKey.awards => 'Awards',
      ResumeCanvasSectionKey.certifications => 'Certifications',
      ResumeCanvasSectionKey.references => 'References',
    };
  }

  static ResumeCanvasSectionKey? fromStorageKey(String key) {
    return switch (key) {
      'profile' => ResumeCanvasSectionKey.profile,
      'work_experience' => ResumeCanvasSectionKey.workExperience,
      'education' => ResumeCanvasSectionKey.education,
      'skills' => ResumeCanvasSectionKey.skills,
      'hobbies' => ResumeCanvasSectionKey.hobbies,
      'awards' => ResumeCanvasSectionKey.awards,
      'certifications' => ResumeCanvasSectionKey.certifications,
      'references' => ResumeCanvasSectionKey.references,
      _ => null,
    };
  }
}
