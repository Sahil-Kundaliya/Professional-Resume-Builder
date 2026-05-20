import 'package:flutter/material.dart';
import 'package:resume_builder/features/home/data/models/resume_template_model.dart';
import '../../domain/entities/resume_template.dart';

class TemplateMapper {
  static ResumeTemplate toDomain(ResumeTemplateModel model) {
    return ResumeTemplate(
      id: model.id,
      name: model.name,
      description: model.description,
      accentColor: Color(model.accentColor),
      isFavorite: model.isFavorite,
      thumbnailPath: model.thumbnailPath,
    );
  }

  static ResumeTemplateModel toModel(ResumeTemplate entity) {
    return ResumeTemplateModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      accentColor: entity.accentColor.value,
      isFavorite: entity.isFavorite,
      thumbnailPath: entity.thumbnailPath,
    );
  }
}
