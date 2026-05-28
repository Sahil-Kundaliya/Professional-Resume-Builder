import '../models/resume_template_model.dart';

abstract class ITemplateLocalDatasource {
  Future<List<ResumeTemplateModel>> getTemplates();
  Future<List<ResumeTemplateModel>> toggleFavorite(String templateId);
  Future<List<ResumeTemplateModel>> getFavoriteTemplates();
  Future<Set<String>> getFavoriteTemplateIds();
}
