import 'package:uuid/uuid.dart';
import '../models/resume_document_model.dart';
import 'resume_local_datasource.dart';

class ResumeLocalDatasourceImpl implements IResumeLocalDatasource {
  final Map<String, ResumeDocumentDto> _store = {};
  final _uuid = const Uuid();

  @override
  Future<ResumeDocumentDto> getResume(String id) async {
    final doc = _store[id];
    if (doc == null) throw Exception('Resume not found: $id');
    return doc;
  }

  @override
  Future<List<ResumeDocumentDto>> getAllResumes() async {
    return _store.values.toList();
  }

  @override
  Future<String> createResume(ResumeDocumentDto dto) async {
    final id = dto.id.isEmpty ? _uuid.v4() : dto.id;
    final saved = ResumeDocumentDto(
      id: id,
      photoPath: dto.photoPath,
      fullName: dto.fullName,
      jobPosition: dto.jobPosition,
      careerGoals: dto.careerGoals,
      email: dto.email,
      phone: dto.phone,
      address: dto.address,
      birthday: dto.birthday,
      website: dto.website,
      workExperience: dto.workExperience,
      education: dto.education,
      references: dto.references,
      hobbies: dto.hobbies,
      skills: dto.skills,
      awards: dto.awards,
      certifications: dto.certifications,
    );
    _store[id] = saved;
    return id;
  }

  @override
  Future<void> updateResume(ResumeDocumentDto dto) async {
    if (!_store.containsKey(dto.id)) {
      throw Exception('Resume not found: ${dto.id}');
    }
    _store[dto.id] = dto;
  }

  @override
  Future<void> deleteResume(String id) async {
    if (!_store.containsKey(id)) {
      throw Exception('Resume not found: $id');
    }
    _store.remove(id);
  }
}
