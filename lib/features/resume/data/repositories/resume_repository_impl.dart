import '../../domain/entities/resume_document.dart';
import '../../domain/repositories/resume_repository.dart';
import '../datasources/resume_local_datasource.dart';
import '../mappers/resume_document_mapper.dart';

class ResumeRepositoryImpl implements IResumeRepository {
  final IResumeLocalDatasource localDatasource;

  ResumeRepositoryImpl({required this.localDatasource});

  @override
  Future<ResumeDocument> getResume(String id) async {
    final dto = await localDatasource.getResume(id);
    return ResumeDocumentMapper.toDomain(dto);
  }

  @override
  Future<List<ResumeDocument>> getAllResumes() async {
    final dtos = await localDatasource.getAllResumes();
    return dtos.map(ResumeDocumentMapper.toDomain).toList();
  }

  @override
  Future<String> createResume(ResumeDocument document) async {
    final dto = ResumeDocumentMapper.toDto(document);
    return localDatasource.createResume(dto);
  }

  @override
  Future<void> updateResume(ResumeDocument document) async {
    final dto = ResumeDocumentMapper.toDto(document);
    await localDatasource.updateResume(dto);
  }

  @override
  Future<void> deleteResume(String id) async {
    await localDatasource.deleteResume(id);
  }
}
