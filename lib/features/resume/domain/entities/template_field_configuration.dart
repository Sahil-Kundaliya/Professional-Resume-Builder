class TemplateFieldKeys {
  static const String fullName = 'fullName';
  static const String jobPosition = 'jobPosition';
  static const String summary = 'summary';
  static const String birthDate = 'birthDate';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String address = 'address';
  static const String website = 'website';
  static const String workExperience = 'workExperience';
  static const String education = 'education';
  static const String skills = 'skills';
  static const String hobbies = 'hobbies';
  static const String awards = 'awards';
  static const String certifications = 'certifications';
  static const String references = 'references';
  static const String photo = 'photo';

  static const Set<String> all = <String>{
    fullName,
    jobPosition,
    summary,
    birthDate,
    email,
    phone,
    address,
    website,
    workExperience,
    education,
    skills,
    hobbies,
    awards,
    certifications,
    references,
    photo,
  };
}

class TemplateFieldConfiguration {
  final Set<String> enabledFields;
  final Set<String> hiddenFields;
  final Set<String> requiredFields;

  const TemplateFieldConfiguration({
    this.enabledFields = TemplateFieldKeys.all,
    this.hiddenFields = const <String>{},
    this.requiredFields = const <String>{
      TemplateFieldKeys.fullName,
      TemplateFieldKeys.summary,
      TemplateFieldKeys.email,
      TemplateFieldKeys.phone,
    },
  });

  const TemplateFieldConfiguration.empty()
      : enabledFields = const <String>{},
        hiddenFields = const <String>{},
        requiredFields = const <String>{};

  bool isVisible(String key) {
    return enabledFields.contains(key) && !hiddenFields.contains(key);
  }

  bool isRequired(String key) {
    return requiredFields.contains(key) && isVisible(key);
  }

  Set<String> visibleFields() {
    return enabledFields.where((key) => !hiddenFields.contains(key)).toSet();
  }

  Set<String> sanitizedRequiredFields() {
    return requiredFields.where(isVisible).toSet();
  }
}
