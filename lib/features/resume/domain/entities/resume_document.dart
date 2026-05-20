import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'resume_document.freezed.dart';

@freezed
class ResumeDocument with _$ResumeDocument {
  const ResumeDocument._();

  const factory ResumeDocument({
    required String id,
    required String fullName,
    required String jobPosition,
    required String careerGoals,
    required String email,
    required String phone,
    required String address,
    required String birthday,
    required String website,
    required String photoPath,
    required List<WorkExperienceEntry> workExperience,
    required List<EducationEntry> education,
    required List<String> references,
    required List<String> hobbies,
    required List<SkillEntry> skills,
    required List<AwardEntry> awards,
    required List<CertEntry> certifications,
  }) = _ResumeDocument;

  /// Creates a blank document ready for editing
  factory ResumeDocument.blank() => ResumeDocument(
        id: const Uuid().v4(),
        photoPath: '',
        fullName: 'Full name',
        jobPosition: 'Job position',
        careerGoals: 'Career goals: short-term, long-term',
        email: 'Information',
        phone: 'Information',
        address: 'Information',
        birthday: 'Information',
        website: 'Information',
        workExperience: const [
          WorkExperienceEntry(
            dateRange: 'From • To',
            position: 'Position',
            companyName: 'Company name',
            description: 'Experience description',
          ),
        ],
        education: const [
          EducationEntry(
            dateRange: 'From • To',
            coursesSubjects: 'Courses/subjects',
            schoolName: 'School name',
            description: 'Education description',
          ),
        ],
        references: const [
          'Reference information including name, title and contact information',
        ],
        hobbies: const ['Hobby name', 'Hobby name', 'Hobby name'],
        skills: const [
          SkillEntry(name: 'Skill name', rating: 3),
          SkillEntry(name: 'Skill name', rating: 2),
          SkillEntry(name: 'Skill name', rating: 4),
        ],
        awards: const [AwardEntry(year: 'Time', name: 'Award name')],
        certifications: const [
          CertEntry(year: 'Time', name: 'Certification name'),
        ],
      );

  /// Returns a pre-filled document with sample John Doe data for preview
  factory ResumeDocument.sampleJohnDoe() => ResumeDocument(
        id: const Uuid().v4(),
        fullName: 'John Doe',
        jobPosition: 'Software Developer',
        careerGoals:
            'Dedicated and results-driven software developer with a passion for creating efficient and scalable solutions. Seeking a challenging position to leverage my skills in full-stack development and contribute to innovative projects.',
        email: 'john.doe@email.com',
        phone: '(555) 123-4567',
        address: '123 Main St, Anytown USA',
        birthday: '01/01/1995',
        website: 'https://example.com',
        photoPath: '',
        workExperience: const [
          WorkExperienceEntry(
            dateRange: 'Jan 2021 – Aug 2021',
            position: 'Software Developer',
            companyName: 'XYZ Tech Solutions',
            description:
                '• Analyze problems, provide solutions\n• Use programming languages, frameworks\n• Integrate APIs, databases\n• Follow development processes',
          ),
          WorkExperienceEntry(
            dateRange: 'Jun 2020 – Dec 2020',
            position: 'Junior Developer',
            companyName: 'ABC Software',
            description:
                '• Fresh graduate/junior developing software\n• Work under senior developers\n• Design UIs, build sites',
          ),
        ],
        education: const [
          EducationEntry(
            dateRange: '2018 – 2020',
            coursesSubjects: 'Computer Science',
            schoolName: 'University of California, Berkeley',
            description: 'Bachelor of Science in Computer Science',
          ),
        ],
        references: const [
          '- Jane Smith - Project Manager - (555) 123-4567',
          '- John Alexander - Software Developer - (555) 123-4567',
        ],
        hobbies: const ['Art', 'Reading', 'Travelling'],
        skills: const [
          SkillEntry(name: 'Problem-solving', rating: 4),
          SkillEntry(name: 'Team Collaboration', rating: 3),
          SkillEntry(name: 'Time Management', rating: 3),
        ],
        awards: const [
          AwardEntry(year: '2021', name: 'Outstanding Contribution Award'),
          AwardEntry(year: '2020', name: 'Collaboration Award'),
        ],
        certifications: const [
          CertEntry(year: '2021', name: 'Certified Full-Stack Developer'),
          CertEntry(year: '2020', name: 'Cybersecurity Fundamentals'),
        ],
      );
}

@freezed
class WorkExperienceEntry with _$WorkExperienceEntry {
  const factory WorkExperienceEntry({
    required String dateRange,
    required String position,
    required String companyName,
    required String description,
  }) = _WorkExperienceEntry;
}

@freezed
class EducationEntry with _$EducationEntry {
  const factory EducationEntry({
    required String dateRange,
    required String coursesSubjects,
    required String schoolName,
    required String description,
  }) = _EducationEntry;
}

@freezed
class SkillEntry with _$SkillEntry {
  const factory SkillEntry({
    required String name,
    required int rating,
  }) = _SkillEntry;
}

@freezed
class AwardEntry with _$AwardEntry {
  const factory AwardEntry({
    required String year,
    required String name,
  }) = _AwardEntry;
}

@freezed
class CertEntry with _$CertEntry {
  const factory CertEntry({
    required String year,
    required String name,
  }) = _CertEntry;
}
