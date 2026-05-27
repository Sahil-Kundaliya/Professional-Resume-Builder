import '../../domain/entities/template_field_configuration.dart';
import '../models/template_field_configuration_model.dart';

class TemplateFieldConfigurationMapper {
  const TemplateFieldConfigurationMapper._();

  static TemplateFieldConfiguration toDomain(
    TemplateFieldConfigurationDto dto,
  ) {
    final enabled = _sanitize(dto.enabledFields);
    final hidden = _sanitize(dto.hiddenFields);
    final required = _sanitize(dto.requiredFields);

    return TemplateFieldConfiguration(
      enabledFields: enabled.isEmpty ? TemplateFieldKeys.all : enabled,
      hiddenFields: hidden,
      requiredFields: required,
    );
  }

  static TemplateFieldConfigurationDto toDto(
    TemplateFieldConfiguration domain, {
    String templateId = '',
  }) {
    return TemplateFieldConfigurationDto(
      templateId: templateId,
      enabledFields: domain.enabledFields.toList(growable: false),
      hiddenFields: domain.hiddenFields.toList(growable: false),
      requiredFields: domain.requiredFields.toList(growable: false),
    );
  }

  static Set<String> _sanitize(Iterable<String> keys) {
    return keys
        .map((key) => key.trim())
        .where((key) => key.isNotEmpty)
        .where(TemplateFieldKeys.all.contains)
        .toSet();
  }
}
