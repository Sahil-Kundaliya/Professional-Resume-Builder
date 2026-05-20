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
      headerStyles: ResumeHeaderStyles(
        fullNameStyle: ResumeTextStyleSpec(
          isBold: dto.headerStyles.fullNameStyle.isBold,
          isItalic: dto.headerStyles.fullNameStyle.isItalic,
          isUnderline: dto.headerStyles.fullNameStyle.isUnderline,
          fontFamily: dto.headerStyles.fullNameStyle.fontFamily,
          textColorValue: dto.headerStyles.fullNameStyle.textColorValue,
        ),
        jobPositionStyle: ResumeTextStyleSpec(
          isBold: dto.headerStyles.jobPositionStyle.isBold,
          isItalic: dto.headerStyles.jobPositionStyle.isItalic,
          isUnderline: dto.headerStyles.jobPositionStyle.isUnderline,
          fontFamily: dto.headerStyles.jobPositionStyle.fontFamily,
          textColorValue: dto.headerStyles.jobPositionStyle.textColorValue,
        ),
        careerGoalsStyle: ResumeTextStyleSpec(
          isBold: dto.headerStyles.careerGoalsStyle.isBold,
          isItalic: dto.headerStyles.careerGoalsStyle.isItalic,
          isUnderline: dto.headerStyles.careerGoalsStyle.isUnderline,
          fontFamily: dto.headerStyles.careerGoalsStyle.fontFamily,
          textColorValue: dto.headerStyles.careerGoalsStyle.textColorValue,
        ),
      ),
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
      headerStyles: ResumeHeaderStylesDto(
        fullNameStyle: ResumeTextStyleSpecDto(
          isBold: domain.headerStyles.fullNameStyle.isBold,
          isItalic: domain.headerStyles.fullNameStyle.isItalic,
          isUnderline: domain.headerStyles.fullNameStyle.isUnderline,
          fontFamily: domain.headerStyles.fullNameStyle.fontFamily,
          textColorValue: domain.headerStyles.fullNameStyle.textColorValue,
        ),
        jobPositionStyle: ResumeTextStyleSpecDto(
          isBold: domain.headerStyles.jobPositionStyle.isBold,
          isItalic: domain.headerStyles.jobPositionStyle.isItalic,
          isUnderline: domain.headerStyles.jobPositionStyle.isUnderline,
          fontFamily: domain.headerStyles.jobPositionStyle.fontFamily,
          textColorValue: domain.headerStyles.jobPositionStyle.textColorValue,
        ),
        careerGoalsStyle: ResumeTextStyleSpecDto(
          isBold: domain.headerStyles.careerGoalsStyle.isBold,
          isItalic: domain.headerStyles.careerGoalsStyle.isItalic,
          isUnderline: domain.headerStyles.careerGoalsStyle.isUnderline,
          fontFamily: domain.headerStyles.careerGoalsStyle.fontFamily,
          textColorValue: domain.headerStyles.careerGoalsStyle.textColorValue,
        ),
      ),
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
