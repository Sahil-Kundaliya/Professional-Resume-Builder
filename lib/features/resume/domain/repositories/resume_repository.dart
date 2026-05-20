import '../entities/resume_document.dart';

abstract class IResumeRepository {
  /// Fetch a resume by ID
  Future<ResumeDocument> getResume(String id);

  /// Fetch all resumes
  Future<List<ResumeDocument>> getAllResumes();

  /// Create a new resume. Returns the ID of the created resume.
  Future<String> createResume(ResumeDocument document);

  /// Update an existing resume
  Future<void> updateResume(ResumeDocument document);

  /// Delete a resume by ID
  Future<void> deleteResume(String id);
}
