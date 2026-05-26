import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'resume_document.freezed.dart';

enum EditableHeaderField { fullName, jobPosition, careerGoals }

extension EditableHeaderFieldX on EditableHeaderField {
  String get fieldId => switch (this) {
        EditableHeaderField.fullName => 'fullName',
        EditableHeaderField.jobPosition => 'jobPosition',
        EditableHeaderField.careerGoals => 'careerGoals',
      };

  static EditableHeaderField? fromFieldId(String? fieldId) {
    return switch (fieldId) {
      'fullName' => EditableHeaderField.fullName,
      'jobPosition' => EditableHeaderField.jobPosition,
      'careerGoals' => EditableHeaderField.careerGoals,
      _ => null,
    };
  }
}

@freezed
class ResumeTextStyleSpec with _$ResumeTextStyleSpec {
  const factory ResumeTextStyleSpec({
    @Default(false) bool isBold,
    @Default(false) bool isItalic,
    @Default(false) bool isUnderline,
    @Default('Inter') String fontFamily,
    @Default(0xDD000000) int textColorValue,
    double? fontSize,
  }) = _ResumeTextStyleSpec;
}

@freezed
class ResumeHeaderStyles with _$ResumeHeaderStyles {
  const factory ResumeHeaderStyles({
    @Default(ResumeTextStyleSpec(
      isBold: true,
      fontFamily: 'Inter',
      textColorValue: 0xDD000000,
      fontSize: 20,
    ))
    ResumeTextStyleSpec fullNameStyle,
    @Default(ResumeTextStyleSpec(
      fontFamily: 'Inter',
      textColorValue: 0xFF757575,
      fontSize: 12,
    ))
    ResumeTextStyleSpec jobPositionStyle,
    @Default(ResumeTextStyleSpec(
      fontFamily: 'Inter',
      textColorValue: 0xDD000000,
      fontSize: 10,
    ))
    ResumeTextStyleSpec careerGoalsStyle,
  }) = _ResumeHeaderStyles;
}

@freezed
class HeaderEditingSnapshot with _$HeaderEditingSnapshot {
  const HeaderEditingSnapshot._();

  const factory HeaderEditingSnapshot({
    required String fullName,
    required String jobPosition,
    required String careerGoals,
    required ResumeTextStyleSpec fullNameStyle,
    required ResumeTextStyleSpec jobPositionStyle,
    required ResumeTextStyleSpec careerGoalsStyle,
    required Map<String, ResumeTextStyleSpec> fieldStyles,
  }) = _HeaderEditingSnapshot;

  factory HeaderEditingSnapshot.fromDocument(ResumeDocument document) {
    return HeaderEditingSnapshot(
      fullName: document.fullName,
      jobPosition: document.jobPosition,
      careerGoals: document.careerGoals,
      fullNameStyle: document.headerStyles.fullNameStyle,
      jobPositionStyle: document.headerStyles.jobPositionStyle,
      careerGoalsStyle: document.headerStyles.careerGoalsStyle,
      fieldStyles: document.fieldStyles,
    );
  }

  ResumeDocument applyToDocument(ResumeDocument document) {
    return document.copyWith(
      fullName: fullName,
      jobPosition: jobPosition,
      careerGoals: careerGoals,
      headerStyles: document.headerStyles.copyWith(
        fullNameStyle: fullNameStyle,
        jobPositionStyle: jobPositionStyle,
        careerGoalsStyle: careerGoalsStyle,
      ),
      fieldStyles: fieldStyles,
    );
  }
}

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
    @Default(ResumeHeaderStyles()) ResumeHeaderStyles headerStyles,
    @Default(<String, ResumeTextStyleSpec>{})
    Map<String, ResumeTextStyleSpec> fieldStyles,
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
        headerStyles: const ResumeHeaderStyles(),
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
        headerStyles: const ResumeHeaderStyles(),
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

  ResumeTextStyleSpec styleForFieldId(String? fieldId) {
    if (fieldId == null) {
      return const ResumeTextStyleSpec();
    }

    return switch (fieldId) {
      'fullName' => headerStyles.fullNameStyle,
      'jobPosition' => headerStyles.jobPositionStyle,
      'careerGoals' => headerStyles.careerGoalsStyle,
      _ => fieldStyles[fieldId] ?? const ResumeTextStyleSpec(),
    };
  }

  double baseFontSizeForFieldId(String? fieldId) {
    if (fieldId == null) {
      return 10;
    }

    if (fieldId == 'fullName') return 20;
    if (fieldId == 'jobPosition') return 12;
    if (fieldId == 'careerGoals') return 10;

    if (fieldId.startsWith('exp_date_') ||
        fieldId.startsWith('edu_date_') ||
        fieldId.startsWith('edu_course_') ||
        fieldId.startsWith('award_year_') ||
        fieldId.startsWith('cert_year_')) {
      return 8;
    }

    if (fieldId.startsWith('exp_pos_') || fieldId.startsWith('edu_school_')) {
      return 10;
    }

    return 9;
  }

  ResumeTextStyleSpec styleForField(EditableHeaderField field) {
    return switch (field) {
      EditableHeaderField.fullName => headerStyles.fullNameStyle,
      EditableHeaderField.jobPosition => headerStyles.jobPositionStyle,
      EditableHeaderField.careerGoals => headerStyles.careerGoalsStyle,
    };
  }

  ResumeDocument copyWithHeaderText(
    EditableHeaderField field,
    String value,
  ) {
    return switch (field) {
      EditableHeaderField.fullName => copyWith(fullName: value),
      EditableHeaderField.jobPosition => copyWith(jobPosition: value),
      EditableHeaderField.careerGoals => copyWith(careerGoals: value),
    };
  }

  ResumeDocument copyWithHeaderTextStyle(
    EditableHeaderField field,
    ResumeTextStyleSpec style,
  ) {
    return copyWith(
      headerStyles: switch (field) {
        EditableHeaderField.fullName =>
          headerStyles.copyWith(fullNameStyle: style),
        EditableHeaderField.jobPosition =>
          headerStyles.copyWith(jobPositionStyle: style),
        EditableHeaderField.careerGoals =>
          headerStyles.copyWith(careerGoalsStyle: style),
      },
    );
  }

  ResumeDocument copyWithFieldTextStyle(
    String fieldId,
    ResumeTextStyleSpec style,
  ) {
    return switch (fieldId) {
      'fullName' => copyWith(
          headerStyles: headerStyles.copyWith(fullNameStyle: style),
        ),
      'jobPosition' => copyWith(
          headerStyles: headerStyles.copyWith(jobPositionStyle: style),
        ),
      'careerGoals' => copyWith(
          headerStyles: headerStyles.copyWith(careerGoalsStyle: style),
        ),
      _ => copyWith(
          fieldStyles: {
            ...fieldStyles,
            fieldId: style,
          },
        ),
    };
  }
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
