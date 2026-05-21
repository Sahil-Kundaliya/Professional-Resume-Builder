import '../../domain/entities/resume_profile.dart';
import '../models/resume_profile_model.dart';

class ResumeProfileMapper {
  const ResumeProfileMapper();

  ResumeProfile toDomain(ResumeProfileModel model) {
    return ResumeProfile(
      id: model.id,
      profileImagePath: model.profileImagePath,
      fullName: model.fullName,
      jobTitle: model.jobTitle,
      summary: model.summary,
      email: model.email,
      address: model.address,
      phoneCountryCode: model.phoneCountryCode,
      phoneNumber: model.phoneNumber,
      birthDate: model.birthDate,
      portfolioLink: model.portfolioLink,
      skills: model.skills
          .map((item) => ProfileSkill(name: item.name, rating: item.rating))
          .toList(),
      hobbies:
          model.hobbies.map((item) => ProfileHobby(name: item.name)).toList(),
      experiences: model.experiences
          .map(
            (item) => ProfileExperience(
              companyName: item.companyName,
              position: item.position,
              startDate: item.startDate,
              endDate: item.endDate,
              detailLines: item.detailLines,
            ),
          )
          .toList(),
      educationRecords: model.educationRecords
          .map(
            (item) => ProfileEducation(
              schoolName: item.schoolName,
              degreeName: item.degreeName,
              startDate: item.startDate,
              endDate: item.endDate,
            ),
          )
          .toList(),
      awards: model.awards
          .map((item) => ProfileAward(title: item.title, date: item.date))
          .toList(),
      certifications: model.certifications
          .map(
            (item) => ProfileCertification(title: item.title, date: item.date),
          )
          .toList(),
      updatedAt: model.updatedAt,
    );
  }

  ResumeProfileModel toModel(ResumeProfile profile) {
    return ResumeProfileModel(
      id: profile.id,
      profileImagePath: profile.profileImagePath,
      fullName: profile.fullName,
      jobTitle: profile.jobTitle,
      summary: profile.summary,
      email: profile.email,
      address: profile.address,
      phoneCountryCode: profile.phoneCountryCode,
      phoneNumber: profile.phoneNumber,
      birthDate: profile.birthDate,
      portfolioLink: profile.portfolioLink,
      skills: profile.skills
          .map(
              (item) => ProfileSkillModel(name: item.name, rating: item.rating))
          .toList(),
      hobbies: profile.hobbies
          .map((item) => ProfileHobbyModel(name: item.name))
          .toList(),
      experiences: profile.experiences
          .map(
            (item) => ProfileExperienceModel(
              companyName: item.companyName,
              position: item.position,
              startDate: item.startDate,
              endDate: item.endDate,
              detailLines: item.detailLines,
            ),
          )
          .toList(),
      educationRecords: profile.educationRecords
          .map(
            (item) => ProfileEducationModel(
              schoolName: item.schoolName,
              degreeName: item.degreeName,
              startDate: item.startDate,
              endDate: item.endDate,
            ),
          )
          .toList(),
      awards: profile.awards
          .map((item) => ProfileAwardModel(title: item.title, date: item.date))
          .toList(),
      certifications: profile.certifications
          .map(
            (item) => ProfileCertificationModel(
              title: item.title,
              date: item.date,
            ),
          )
          .toList(),
      updatedAt: profile.updatedAt,
    );
  }
}
