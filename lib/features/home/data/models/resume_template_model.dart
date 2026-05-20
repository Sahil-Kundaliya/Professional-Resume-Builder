import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'resume_template_model.freezed.dart';
part 'resume_template_model.g.dart';

@freezed
class ResumeTemplateModel with _$ResumeTemplateModel {
  const factory ResumeTemplateModel({
    required String id,
    required String name,
    required String description,
    required int accentColor,
    @Default(false) bool isFavorite,
    @Default('') String thumbnailPath,
  }) = _ResumeTemplateModel;

  factory ResumeTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$ResumeTemplateModelFromJson(json);
}
