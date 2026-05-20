import 'package:flutter/material.dart';
import '../../domain/entities/resume_element.dart';
import '../models/resume_element_model.dart';

class ResumeElementMapper {
  static ResumeElement toDomain(ResumeElementDto dto) {
    return ResumeElement(
      id: dto.id,
      text: dto.text,
      fontSize: dto.fontSize,
      isBold: dto.isBold,
      isItalic: dto.isItalic,
      isUnderline: dto.isUnderline,
      color: Color(dto.colorValue),
      fontFamily: dto.fontFamily,
      textAlign: TextAlign.values.byName(dto.textAlign),
      isPlaceholder: dto.isPlaceholder,
    );
  }

  static ResumeElementDto toDto(ResumeElement domain) {
    return ResumeElementDto(
      id: domain.id,
      text: domain.text,
      fontSize: domain.fontSize,
      isBold: domain.isBold,
      isItalic: domain.isItalic,
      isUnderline: domain.isUnderline,
      colorValue: domain.color.value,
      fontFamily: domain.fontFamily,
      textAlign: domain.textAlign.name,
      isPlaceholder: domain.isPlaceholder,
    );
  }
}
