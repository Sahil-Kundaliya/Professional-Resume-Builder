import 'package:flutter/material.dart';
import '../../domain/entities/resume_template.dart';
import '../models/resume_template_model.dart';
import 'template_field_configuration_mapper.dart';

class ResumeTemplateMapper {
  static ResumeTemplate toDomain(ResumeTemplateDto dto) {
    return ResumeTemplate(
      id: dto.id,
      name: dto.name,
      layout: _layoutFromDto(dto.layout),
      accentColor: Color(dto.accentColorValue),
      headerBgColor: Color(dto.headerBgColorValue),
      hasPhoto: dto.hasPhoto,
      hasSidebar: dto.hasSidebar,
      isFavorite: dto.isFavorite,
      fieldConfiguration:
          TemplateFieldConfigurationMapper.toDomain(dto.fieldConfiguration),
    );
  }

  static ResumeTemplateDto toDto(ResumeTemplate domain) {
    return ResumeTemplateDto(
      id: domain.id,
      name: domain.name,
      layout: _layoutToDto(domain.layout),
      accentColorValue: domain.accentColor.value,
      headerBgColorValue: domain.headerBgColor.value,
      hasPhoto: domain.hasPhoto,
      hasSidebar: domain.hasSidebar,
      isFavorite: domain.isFavorite,
      fieldConfiguration: TemplateFieldConfigurationMapper.toDto(
        domain.fieldConfiguration,
        templateId: domain.id,
      ),
    );
  }

  static TemplateLayout _layoutFromDto(TemplateLayoutDto dto) {
    return TemplateLayout.values.byName(dto.name);
  }

  static TemplateLayoutDto _layoutToDto(TemplateLayout layout) {
    return TemplateLayoutDto.values.byName(layout.name);
  }
}
