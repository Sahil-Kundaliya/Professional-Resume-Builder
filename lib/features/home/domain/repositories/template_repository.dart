import '../entities/resume_template.dart';

abstract class ITemplateRepository {
  Future<List<ResumeTemplate>> getTemplates();
  Future<List<ResumeTemplate>> toggleFavorite(String templateId);
  Future<List<ResumeTemplate>> getFavoriteTemplates();
  Future<Set<String>> getFavoriteTemplateIds();
}
