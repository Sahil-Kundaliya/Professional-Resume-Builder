import '../../domain/entities/resume_document.dart';
import 'resume_canvas_section_keys.dart';

class ResumeCanvasTitleResolver {
  const ResumeCanvasTitleResolver._();

  static String resolveTitle(
    ResumeDocument document,
    ResumeCanvasSectionKey section,
  ) {
    final key = ResumeCanvasSectionKeyX.storageKey(section);
    return document.resolvedSectionTitle(key);
  }

  static String defaultTitle(ResumeCanvasSectionKey section) {
    return ResumeCanvasSectionKeyX.defaultTitle(section);
  }
}
