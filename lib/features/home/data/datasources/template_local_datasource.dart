import '../models/resume_template_model.dart';

abstract class ITemplateLocalDatasource {
  Future<List<ResumeTemplateModel>> getTemplates();
  Future<void> toggleFavorite(String templateId);
  Future<List<ResumeTemplateModel>> getFavoriteTemplates();
}
