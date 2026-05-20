import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'resume_template.freezed.dart';

enum TemplateLayout { albany, amsterdam, barcelona, berlin, boston, calgary }

@freezed
class ResumeTemplate with _$ResumeTemplate {
  const factory ResumeTemplate({
    required String id,
    required String name,
    required TemplateLayout layout,
    @ColorConverter() required Color accentColor,
    @ColorConverter() required Color headerBgColor,
    required bool hasPhoto,
    required bool hasSidebar,
    required bool isFavorite,
  }) = _ResumeTemplate;
}

class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color object) => object.value;
}
