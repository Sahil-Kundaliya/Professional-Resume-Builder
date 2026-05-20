import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'resume_template.freezed.dart';

@freezed
class ResumeTemplate with _$ResumeTemplate {
  const factory ResumeTemplate({
    required String id,
    required String name,
    required String description,
    required Color accentColor,
    @Default(false) bool isFavorite,
    @Default('') String thumbnailPath,
  }) = _ResumeTemplate;
}
