import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_routes.dart';
import '../../domain/entities/resume_document.dart';
import '../bloc/resume_event.dart';
import '../bloc/resume_bloc.dart';
import '../bloc/resume_state.dart';
import '../widgets/resume_awards_certifications_section.dart';
import '../widgets/resume_basic_info_section.dart';
import '../widgets/resume_education_section.dart';
import '../widgets/resume_form_section_support.dart';
import '../widgets/resume_repeatable_text_section.dart';
import '../widgets/resume_work_experience_section.dart';

class ResumeFormPage extends StatefulWidget {
  const ResumeFormPage({super.key});

  @override
  State<ResumeFormPage> createState() => _ResumeFormPageState();
}

class _ResumeFormPageState extends State<ResumeFormPage> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResumeBloc, ResumeState>(
      builder: (context, state) {
        return state.whenOrNull(
              loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
              error: (message) => Scaffold(
                appBar: AppBar(title: const Text('Resume Form')),
                body: Center(child: Text('Error: $message')),
              ),
              loaded: (document, template) {
                final sections = ResumeFormSectionSupport.resolve(template);
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'Resume Form',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    actions: [
                      TextButton.icon(
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.pushNamed(context, AppRoutes.pdfPreview);
                        },
                        icon: const Icon(Icons.preview_outlined),
                        label: const Text('Preview'),
                      ),
                    ],
                  ),
                  body: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        'Template: ${template?.name ?? 'Unknown'}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 8),
                      if (sections.contains(ResumeFormSection.profileBasics))
                        ResumeBasicInfoSection(
                          document: document,
                          isImageSupported:
                              sections.contains(ResumeFormSection.profileImage),
                          onPickImage: () => _pickImage(context),
                          onUpdateFullName: (value) => context
                              .read<ResumeBloc>()
                              .add(UpdateFullName(value)),
                          onUpdateJobPosition: (value) => context
                              .read<ResumeBloc>()
                              .add(UpdateJobPosition(value)),
                          onUpdateSummary: (value) => context
                              .read<ResumeBloc>()
                              .add(UpdateCareerGoals(value)),
                          onUpdateBirthDate: (value) => context
                              .read<ResumeBloc>()
                              .add(UpdateBirthday(value)),
                          onUpdateEmail: (value) => context
                              .read<ResumeBloc>()
                              .add(UpdateEmail(value)),
                          onUpdatePhone: (value) => context
                              .read<ResumeBloc>()
                              .add(UpdatePhone(value)),
                          onUpdateAddress: (value) => context
                              .read<ResumeBloc>()
                              .add(UpdateAddress(value)),
                          onUpdatePortfolio: (value) => context
                              .read<ResumeBloc>()
                              .add(UpdateWebsite(value)),
                        ),
                      const SizedBox(height: 10),
                      if (sections.contains(ResumeFormSection.skills))
                        ResumeRepeatableTextSection(
                          title: 'Skills',
                          hint: 'Skill',
                          items:
                              document.skills.map((item) => item.name).toList(),
                          onChanged: (updated) =>
                              context.read<ResumeBloc>().add(
                                    UpdateSkills(
                                      _mapSkills(updated, document.skills),
                                    ),
                                  ),
                        ),
                      const SizedBox(height: 10),
                      if (sections.contains(ResumeFormSection.hobbies))
                        ResumeRepeatableTextSection(
                          title: 'Hobbies',
                          hint: 'Hobby',
                          items: document.hobbies,
                          onChanged: (updated) => context
                              .read<ResumeBloc>()
                              .add(UpdateHobbies(updated)),
                        ),
                      const SizedBox(height: 10),
                      if (sections.contains(ResumeFormSection.references))
                        ResumeRepeatableTextSection(
                          title: 'References',
                          hint: 'Reference',
                          items: document.references,
                          onChanged: (updated) => context
                              .read<ResumeBloc>()
                              .add(UpdateReferences(updated)),
                        ),
                      const SizedBox(height: 10),
                      if (sections.contains(ResumeFormSection.awards) ||
                          sections.contains(ResumeFormSection.certifications))
                        ResumeAwardsCertificationsSection(
                          awards: document.awards,
                          certifications: document.certifications,
                          onAwardsChanged: (updated) => context
                              .read<ResumeBloc>()
                              .add(UpdateAwards(updated)),
                          onCertificationsChanged: (updated) => context
                              .read<ResumeBloc>()
                              .add(UpdateCertifications(updated)),
                        ),
                      const SizedBox(height: 10),
                      if (sections.contains(ResumeFormSection.workExperience))
                        ResumeWorkExperienceSection(
                          items: document.workExperience,
                          onChanged: (updated) => context
                              .read<ResumeBloc>()
                              .add(UpdateWorkExperience(updated)),
                        ),
                      const SizedBox(height: 10),
                      if (sections.contains(ResumeFormSection.education))
                        ResumeEducationSection(
                          items: document.education,
                          onChanged: (updated) => context
                              .read<ResumeBloc>()
                              .add(UpdateEducation(updated)),
                        ),
                    ],
                  ),
                );
              },
            ) ??
            const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
      },
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null || !mounted) {
      return;
    }
    context.read<ResumeBloc>().add(UpdatePhoto(image.path));
  }

  List<SkillEntry> _mapSkills(
    List<String> values,
    List<SkillEntry> current,
  ) {
    return values.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;
      final existingRating = index < current.length ? current[index].rating : 3;
      return SkillEntry(name: value, rating: existingRating);
    }).toList(growable: false);
  }
}
