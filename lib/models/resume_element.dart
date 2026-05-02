import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// Represents a single editable text element inside the resume canvas
class ResumeElement {
  final String id;
  String text;
  double fontSize;
  bool isBold;
  bool isItalic;
  bool isUnderline;
  Color color;
  String fontFamily;
  TextAlign textAlign;
  bool isPlaceholder;

  ResumeElement({
    String? id,
    required this.text,
    this.fontSize = 12,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.color = const Color(0xFF333333),
    this.fontFamily = 'Default',
    this.textAlign = TextAlign.left,
    this.isPlaceholder = false,
  }) : id = id ?? const Uuid().v4();

  ResumeElement copyWith({
    String? text,
    double? fontSize,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    Color? color,
    String? fontFamily,
    TextAlign? textAlign,
    bool? isPlaceholder,
  }) {
    return ResumeElement(
      id: id,
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      color: color ?? this.color,
      fontFamily: fontFamily ?? this.fontFamily,
      textAlign: textAlign ?? this.textAlign,
      isPlaceholder: isPlaceholder ?? this.isPlaceholder,
    );
  }
}
