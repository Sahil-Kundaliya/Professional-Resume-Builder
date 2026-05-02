/// Holds all user data for a resume document
class ResumeDocument {
  // Header
  String photoPath;
  String fullName;
  String jobPosition;
  String careerGoals;

  // Work Experience entries
  List<WorkExperienceEntry> workExperience;

  // Education entries
  List<EducationEntry> education;

  // References
  List<String> references;

  // Profile (sidebar)
  String email;
  String phone;
  String address;
  String birthday;
  String website;

  // Hobbies
  List<String> hobbies;

  // Skills
  List<SkillEntry> skills;

  // Awards
  List<AwardEntry> awards;

  // Certifications
  List<CertEntry> certifications;

  ResumeDocument({
    this.photoPath = '',
    this.fullName = 'Full name',
    this.jobPosition = 'Job position',
    this.careerGoals = 'Career goals: short-term, long-term',
    List<WorkExperienceEntry>? workExperience,
    List<EducationEntry>? education,
    List<String>? references,
    this.email = 'Information',
    this.phone = 'Information',
    this.address = 'Information',
    this.birthday = 'Information',
    this.website = 'Information',
    List<String>? hobbies,
    List<SkillEntry>? skills,
    List<AwardEntry>? awards,
    List<CertEntry>? certifications,
  })  : workExperience = workExperience ??
            [
              WorkExperienceEntry(
                dateRange: 'From • To',
                position: 'Position',
                companyName: 'Company name',
                description: 'Experience description',
              )
            ],
        education = education ??
            [
              EducationEntry(
                dateRange: 'From • To',
                coursesSubjects: 'Courses/subjects',
                schoolName: 'School name',
                description: 'Education description',
              )
            ],
        references = references ??
            ['Reference information including name, title and contact information'],
        hobbies = hobbies ?? ['Hobby name', 'Hobby name', 'Hobby name'],
        skills = skills ??
            [
              SkillEntry(name: 'Skill name', rating: 3),
              SkillEntry(name: 'Skill name', rating: 2),
              SkillEntry(name: 'Skill name', rating: 4),
            ],
        awards = awards ??
            [
              AwardEntry(year: 'Time', name: 'Award name'),
            ],
        certifications = certifications ??
            [
              CertEntry(year: 'Time', name: 'Certification name'),
            ];

  /// Returns a copy pre-filled with John Doe sample data for preview
  static ResumeDocument sampleJohnDoe() {
    return ResumeDocument(
      fullName: 'John Doe',
      jobPosition: 'Software Developer',
      careerGoals:
          'Dedicated and results-driven software developer with a passion for creating efficient and scalable solutions. Seeking a challenging position to leverage my skills in full-stack development and contribute to innovative projects.',
      workExperience: [
        WorkExperienceEntry(
          dateRange: 'Jan 2021 – Aug 2021',
          position: 'Software Developer',
          companyName: 'XYZ Tech Solutions',
          description:
              '• Analyze problems, provide solutions\n• Use programming languages, frameworks\n• Integrate APIs, databases\n• Follow development processes\n• Mentor teammates\n• Stay up to date with new tech\n• Fix app issues',
        ),
        WorkExperienceEntry(
          dateRange: 'Jun 2020 – Dec 2020',
          position: 'Junior Developer',
          companyName: 'ABC Software',
          description:
              '• Fresh graduate/junior developing software\n• Work under senior developers/managers\n• Design UIs, build sites using front-end languages\n• Learn and improve skills through practice and training\n• Follow development and project processes\n• Increase code quality and efficiency',
        ),
      ],
      education: [
        EducationEntry(
          dateRange: '2018 – 2020',
          coursesSubjects: 'Computer Science',
          schoolName: 'University of California, Berkeley',
          description:
              'Bachelor of Science in Computer Science | University of Techland, Anytown, USA | May 2018',
        ),
        EducationEntry(
          dateRange: '2014 – 2018',
          coursesSubjects: 'English Literature',
          schoolName: 'Brown University',
          description:
              'Bachelor of Arts in English Literature | Brown University, Providence, RI | Graduated May 2010',
        ),
      ],
      references: [
        '- Jane Smith - Project Manager - (555) 123-4567',
        '- John Alexander - Software Developer - (555) 123-4567',
      ],
      email: 'john.doe@email.com',
      phone: '(555) 123-4567',
      address: '123 Main St, Anytown USA',
      birthday: '01/01/1995',
      website: 'https://example.com',
      hobbies: ['Art', 'Reading', 'Travelling'],
      skills: [
        SkillEntry(name: 'Problem-solving', rating: 4),
        SkillEntry(name: 'Team Collaboration', rating: 3),
        SkillEntry(name: 'Time Management', rating: 3),
      ],
      awards: [
        AwardEntry(year: '2021', name: 'Outstanding Contribution Award'),
        AwardEntry(year: '2020', name: 'Collaboration Award'),
      ],
      certifications: [
        CertEntry(year: '2021', name: 'Certified Full-Stack Developer'),
        CertEntry(year: '2020', name: 'Cybersecurity Fundamentals'),
      ],
    );
  }

  /// Returns a blank template copy for editing
  static ResumeDocument blank() => ResumeDocument();
}

class WorkExperienceEntry {
  String dateRange;
  String position;
  String companyName;
  String description;

  WorkExperienceEntry({
    this.dateRange = 'From • To',
    this.position = 'Position',
    this.companyName = 'Company name',
    this.description = 'Experience description',
  });
}

class EducationEntry {
  String dateRange;
  String coursesSubjects;
  String schoolName;
  String description;

  EducationEntry({
    this.dateRange = 'From • To',
    this.coursesSubjects = 'Courses/subjects',
    this.schoolName = 'School name',
    this.description = 'Education description',
  });
}

class SkillEntry {
  String name;
  int rating; // 1-5

  SkillEntry({this.name = 'Skill name', this.rating = 3});
}

class AwardEntry {
  String year;
  String name;

  AwardEntry({this.year = 'Time', this.name = 'Award name'});
}

class CertEntry {
  String year;
  String name;

  CertEntry({this.year = 'Time', this.name = 'Certification name'});
}
