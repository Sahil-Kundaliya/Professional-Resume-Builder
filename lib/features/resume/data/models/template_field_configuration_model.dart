class TemplateFieldConfigurationDto {
  final String templateId;
  final List<String> enabledFields;
  final List<String> hiddenFields;
  final List<String> requiredFields;

  const TemplateFieldConfigurationDto({
    this.templateId = '',
    this.enabledFields = const <String>[],
    this.hiddenFields = const <String>[],
    this.requiredFields = const <String>[],
  });

  factory TemplateFieldConfigurationDto.fromJson(Map<String, dynamic> json) {
    return TemplateFieldConfigurationDto(
      templateId: json['templateId'] as String? ?? '',
      enabledFields:
          (json['enabledFields'] as List<dynamic>? ?? const <dynamic>[])
              .whereType<String>()
              .toList(growable: false),
      hiddenFields:
          (json['hiddenFields'] as List<dynamic>? ?? const <dynamic>[])
              .whereType<String>()
              .toList(growable: false),
      requiredFields:
          (json['requiredFields'] as List<dynamic>? ?? const <dynamic>[])
              .whereType<String>()
              .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'templateId': templateId,
      'enabledFields': enabledFields,
      'hiddenFields': hiddenFields,
      'requiredFields': requiredFields,
    };
  }
}
