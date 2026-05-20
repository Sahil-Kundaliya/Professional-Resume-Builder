import '../../domain/entities/resume_template.dart';
import '../../domain/repositories/template_repository.dart';
import '../datasources/template_local_datasource.dart';
import '../mappers/template_mapper.dart';

class TemplateRepositoryImpl implements ITemplateRepository {
  final ITemplateLocalDatasource localDatasource;

  TemplateRepositoryImpl(this.localDatasource);

  @override
  Future<List<ResumeTemplate>> getTemplates() async {
    final models = await localDatasource.getTemplates();
    return models.map((m) => TemplateMapper.toDomain(m)).toList();
  }

  @override
  Future<void> toggleFavorite(String templateId) async {
    await localDatasource.toggleFavorite(templateId);
  }

  @override
  Future<List<ResumeTemplate>> getFavoriteTemplates() async {
    final models = await localDatasource.getFavoriteTemplates();
    return models.map((m) => TemplateMapper.toDomain(m)).toList();
  }
}
