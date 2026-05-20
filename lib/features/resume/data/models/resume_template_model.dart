import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_template_model.freezed.dart';
part 'resume_template_model.g.dart';

enum TemplateLayoutDto {
  albany,
  amsterdam,
  barcelona,
  berlin,
  boston,
  calgary,
}

@freezed
class ResumeTemplateDto with _$ResumeTemplateDto {
  const factory ResumeTemplateDto({
    required String id,
    required String name,
    required TemplateLayoutDto layout,
    required int accentColorValue,
    required int headerBgColorValue,
    @Default(true) bool hasPhoto,
    @Default(true) bool hasSidebar,
    @Default(false) bool isFavorite,
  }) = _ResumeTemplateDto;

  factory ResumeTemplateDto.fromJson(Map<String, dynamic> json) =>
      _$ResumeTemplateDtoFromJson(json);
}
