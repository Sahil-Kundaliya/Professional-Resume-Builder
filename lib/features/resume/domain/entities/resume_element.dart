import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'resume_element.freezed.dart';

@freezed
class ResumeElement with _$ResumeElement {
  const factory ResumeElement({
    required String id,
    required String text,
    @Default(12) double fontSize,
    @Default(false) bool isBold,
    @Default(false) bool isItalic,
    @Default(false) bool isUnderline,
    @ColorConverter() @Default(Color(0xFF333333)) Color color,
    @Default('Default') String fontFamily,
    @Default(TextAlign.left) TextAlign textAlign,
    @Default(false) bool isPlaceholder,
  }) = _ResumeElement;
}

class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color object) => object.value;
}

class TextAlignConverter implements JsonConverter<TextAlign, String> {
  const TextAlignConverter();

  @override
  TextAlign fromJson(String json) => TextAlign.values.byName(json);

  @override
  String toJson(TextAlign object) => object.name;
}
