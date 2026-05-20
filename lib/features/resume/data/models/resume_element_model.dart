import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'resume_element_model.freezed.dart';
part 'resume_element_model.g.dart';

@freezed
class ResumeElementDto with _$ResumeElementDto {
  const factory ResumeElementDto({
    required String id,
    required String text,
    @Default(12.0) double fontSize,
    @Default(false) bool isBold,
    @Default(false) bool isItalic,
    @Default(false) bool isUnderline,
    @Default(0xFF333333) int colorValue,
    @Default('Default') String fontFamily,
    @Default('left') String textAlign,
    @Default(false) bool isPlaceholder,
  }) = _ResumeElementDto;

  factory ResumeElementDto.fromJson(Map<String, dynamic> json) =>
      _$ResumeElementDtoFromJson(json);
}
