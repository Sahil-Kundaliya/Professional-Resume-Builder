import 'resume_canvas_section_keys.dart';

class ResumeCanvasSelectionTarget {
  const ResumeCanvasSelectionTarget({
    required this.fieldId,
    required this.section,
    required this.itemIndex,
    required this.isProtectedHeaderField,
    required this.isRepeatableItem,
  });

  final String? fieldId;
  final ResumeCanvasSectionKey? section;
  final int? itemIndex;
  final bool isProtectedHeaderField;
  final bool isRepeatableItem;

  bool get isDeletableRepeatableItem => isRepeatableItem && itemIndex != null;
}

class ResumeCanvasSelectionParser {
  static const Set<String> protectedHeaderFieldIds = {
    'fullName',
    'jobPosition',
    'careerGoals',
  };

  static ResumeCanvasSelectionTarget parse(String? fieldId) {
    if (fieldId == null || fieldId.isEmpty) {
      return const ResumeCanvasSelectionTarget(
        fieldId: null,
        section: null,
        itemIndex: null,
        isProtectedHeaderField: false,
        isRepeatableItem: false,
      );
    }

    if (protectedHeaderFieldIds.contains(fieldId)) {
      return ResumeCanvasSelectionTarget(
        fieldId: fieldId,
        section: null,
        itemIndex: null,
        isProtectedHeaderField: true,
        isRepeatableItem: false,
      );
    }

    final sectionIndexPattern = <RegExp, ResumeCanvasSectionKey>{
      RegExp(r'^exp_(date|pos|company|desc)_(\d+)$'):
          ResumeCanvasSectionKey.workExperience,
      RegExp(r'^edu_(date|course|school|desc)_(\d+)$'):
          ResumeCanvasSectionKey.education,
      RegExp(r'^skill_(\d+)$'): ResumeCanvasSectionKey.skills,
      RegExp(r'^hobby_(\d+)$'): ResumeCanvasSectionKey.hobbies,
      RegExp(r'^award_(year|name)_(\d+)$'): ResumeCanvasSectionKey.awards,
      RegExp(r'^cert_(year|name)_(\d+)$'):
          ResumeCanvasSectionKey.certifications,
      RegExp(r'^ref_(\d+)$'): ResumeCanvasSectionKey.references,
    };

    for (final entry in sectionIndexPattern.entries) {
      final match = entry.key.firstMatch(fieldId);
      if (match == null) {
        continue;
      }

      final indexGroup = match.group(match.groupCount);
      final parsedIndex = int.tryParse(indexGroup ?? '');
      return ResumeCanvasSelectionTarget(
        fieldId: fieldId,
        section: entry.value,
        itemIndex: parsedIndex,
        isProtectedHeaderField: false,
        isRepeatableItem: true,
      );
    }

    final profilePattern = RegExp(r'^profile_(email|phone|address|birthday|website)$');
    if (profilePattern.hasMatch(fieldId)) {
      return ResumeCanvasSelectionTarget(
        fieldId: fieldId,
        section: ResumeCanvasSectionKey.profile,
        itemIndex: null,
        isProtectedHeaderField: false,
        isRepeatableItem: false,
      );
    }

    if (fieldId == 'photoPath') {
      return const ResumeCanvasSelectionTarget(
        fieldId: 'photoPath',
        section: ResumeCanvasSectionKey.profile,
        itemIndex: null,
        isProtectedHeaderField: false,
        isRepeatableItem: false,
      );
    }

    return ResumeCanvasSelectionTarget(
      fieldId: fieldId,
      section: null,
      itemIndex: null,
      isProtectedHeaderField: false,
      isRepeatableItem: false,
    );
  }
}
