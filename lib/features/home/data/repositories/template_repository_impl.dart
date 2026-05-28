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
  Future<List<ResumeTemplate>> toggleFavorite(String templateId) async {
    final models = await localDatasource.toggleFavorite(templateId);
    return models.map((m) => TemplateMapper.toDomain(m)).toList();
  }

  @override
  Future<List<ResumeTemplate>> getFavoriteTemplates() async {
    final models = await localDatasource.getFavoriteTemplates();
    return models.map((m) => TemplateMapper.toDomain(m)).toList();
  }

  @override
  Future<Set<String>> getFavoriteTemplateIds() async {
    return localDatasource.getFavoriteTemplateIds();
  }
}
