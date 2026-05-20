import '../../domain/entities/resume_document.dart';
import '../models/resume_document_model.dart';

class ResumeDocumentMapper {
  static ResumeDocument toDomain(ResumeDocumentDto dto) {
    return ResumeDocument(
      id: dto.id,
      photoPath: dto.photoPath,
      fullName: dto.fullName,
      jobPosition: dto.jobPosition,
      careerGoals: dto.careerGoals,
      email: dto.email,
      phone: dto.phone,
      address: dto.address,
      birthday: dto.birthday,
      website: dto.website,
      workExperience: dto.workExperience
          .map((e) => WorkExperienceEntry(
                dateRange: e.dateRange,
                position: e.position,
                companyName: e.companyName,
                description: e.description,
              ))
          .toList(),
      education: dto.education
          .map((e) => EducationEntry(
                dateRange: e.dateRange,
                coursesSubjects: e.coursesSubjects,
                schoolName: e.schoolName,
                description: e.description,
              ))
          .toList(),
      references: dto.references,
      hobbies: dto.hobbies,
      skills: dto.skills
          .map((e) => SkillEntry(name: e.name, rating: e.rating))
          .toList(),
      awards: dto.awards
          .map((e) => AwardEntry(year: e.year, name: e.name))
          .toList(),
      certifications: dto.certifications
          .map((e) => CertEntry(year: e.year, name: e.name))
          .toList(),
    );
  }

  static ResumeDocumentDto toDto(ResumeDocument domain) {
    return ResumeDocumentDto(
      id: domain.id,
      photoPath: domain.photoPath,
      fullName: domain.fullName,
      jobPosition: domain.jobPosition,
      careerGoals: domain.careerGoals,
      email: domain.email,
      phone: domain.phone,
      address: domain.address,
      birthday: domain.birthday,
      website: domain.website,
      workExperience: domain.workExperience
          .map((e) => WorkExperienceEntryDto(
                dateRange: e.dateRange,
                position: e.position,
                companyName: e.companyName,
                description: e.description,
              ))
          .toList(),
      education: domain.education
          .map((e) => EducationEntryDto(
                dateRange: e.dateRange,
                coursesSubjects: e.coursesSubjects,
                schoolName: e.schoolName,
                description: e.description,
              ))
          .toList(),
      references: domain.references,
      hobbies: domain.hobbies,
      skills: domain.skills
          .map((e) => SkillEntryDto(name: e.name, rating: e.rating))
          .toList(),
      awards: domain.awards
          .map((e) => AwardEntryDto(year: e.year, name: e.name))
          .toList(),
      certifications: domain.certifications
          .map((e) => CertEntryDto(year: e.year, name: e.name))
          .toList(),
    );
  }
}
