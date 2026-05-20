import '../models/resume_document_model.dart';

abstract class IResumeLocalDatasource {
  Future<ResumeDocumentDto> getResume(String id);
  Future<List<ResumeDocumentDto>> getAllResumes();
  Future<String> createResume(ResumeDocumentDto dto);
  Future<void> updateResume(ResumeDocumentDto dto);
  Future<void> deleteResume(String id);
}
