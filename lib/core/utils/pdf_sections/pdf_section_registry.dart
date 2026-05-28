import 'package:pdf/widgets.dart' as pw;

import 'awards_section_builder.dart';
import 'certifications_section_builder.dart';
import 'education_section_builder.dart';
import 'hobbies_section_builder.dart';
import 'pdf_section_builder.dart';
import 'pdf_section_context.dart';
import 'pdf_section_style.dart';
import 'profile_section_builder.dart';
import 'references_section_builder.dart';
import 'skills_section_builder.dart';
import 'summary_section_builder.dart';
import 'work_experience_section_builder.dart';

class PdfSectionRegistry {
  static const List<RegisteredPdfSectionBuilder> _leftColumnSections = [
    RegisteredPdfSectionBuilder(
      sectionKey: PdfSectionKeys.workExperience,
      build: buildWorkExperienceSection,
    ),
    RegisteredPdfSectionBuilder(
      sectionKey: PdfSectionKeys.education,
      build: buildEducationSection,
    ),
    RegisteredPdfSectionBuilder(
      sectionKey: PdfSectionKeys.references,
      build: buildReferencesSection,
    ),
  ];

  static const List<RegisteredPdfSectionBuilder> _rightColumnSections = [
    RegisteredPdfSectionBuilder(
      sectionKey: PdfSectionKeys.profile,
      build: buildProfileSection,
    ),
    RegisteredPdfSectionBuilder(
      sectionKey: PdfSectionKeys.hobbies,
      build: buildHobbiesSection,
    ),
    RegisteredPdfSectionBuilder(
      sectionKey: PdfSectionKeys.skills,
      build: buildSkillsSection,
    ),
    RegisteredPdfSectionBuilder(
      sectionKey: PdfSectionKeys.awards,
      build: buildAwardsSection,
    ),
    RegisteredPdfSectionBuilder(
      sectionKey: PdfSectionKeys.certifications,
      build: buildCertificationsSection,
    ),
  ];

  static List<pw.Widget> buildLeftColumn(PdfSectionContext context) {
    return _buildColumn(_leftColumnSections, context);
  }

  static List<pw.Widget> buildRightColumn(PdfSectionContext context) {
    return _buildColumn(_rightColumnSections, context);
  }

  static pw.Widget? buildHeaderSummary(PdfSectionContext context) {
    return buildSummarySection(context);
  }

  static List<pw.Widget> _buildColumn(
    List<RegisteredPdfSectionBuilder> builders,
    PdfSectionContext context,
  ) {
    final widgets = <pw.Widget>[];

    for (final builder in builders) {
      final section = builder.build(context);
      if (section == null) {
        continue;
      }
      if (widgets.isNotEmpty) {
        widgets.add(pw.SizedBox(height: PdfSectionStyle.sectionSpacing));
      }
      widgets.add(section);
    }

    return widgets;
  }
}
