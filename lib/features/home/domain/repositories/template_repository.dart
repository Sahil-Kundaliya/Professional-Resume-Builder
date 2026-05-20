import '../entities/resume_template.dart';

abstract class ITemplateRepository {
  Future<List<ResumeTemplate>> getTemplates();
  Future<void> toggleFavorite(String templateId);
  Future<List<ResumeTemplate>> getFavoriteTemplates();
}
