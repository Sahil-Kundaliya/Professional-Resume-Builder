import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/skill_rating/skill_rating.dart';
import '../../domain/entities/resume_document.dart';
import '../bloc/resume_bloc.dart';
import '../bloc/resume_event.dart';
import '../bloc/resume_state.dart';
import '../widgets/resume_education_bottom_sheet.dart';
import '../widgets/resume_form_feedback.dart';
import '../widgets/resume_form_section_support.dart';
import '../widgets/resume_work_experience_bottom_sheet.dart';

class ResumeFormPage extends StatefulWidget {
  const ResumeFormPage({super.key});

  @override
  State<ResumeFormPage> createState() => _ResumeFormPageState();
}

class _ResumeFormPageState extends State<ResumeFormPage> {
  static const _ink = Color(0xFF080D32);
  static const _accent = Color(0xFF5B2ECC);
  static const _background = Color(0xFFFAFAFD);
  static const _cardTint = Color(0xFFFBF8FF);
  static const _border = Color(0xFFDADDEC);

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResumeBloc, ResumeState>(
      listener: (context, state) {
        state.mapOrNull(
          loaded: (loaded) {
            if (loaded.feedbackMessage != null) {
              ResumeFormFeedback.show(context, loaded.feedbackMessage!);
              context.read<ResumeBloc>().add(const ConsumeFeedback());
            }

            if (loaded.previewRequested && loaded.canPreview) {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.pushNamed(context, AppRoutes.pdfPreview);
              context.read<ResumeBloc>().add(const ConsumePreviewRequest());
            }
          },
        );
      },
      builder: (context, state) {
        return state.whenOrNull(
              loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
              error: (message) => Scaffold(
                appBar: AppBar(title: const Text('Resume Form')),
                body: Center(child: Text('Error: $message')),
              ),
              loaded: (document, template, _, __, ___, ____, _____,
                  isPreviewValidationInProgress) {
                final sections = ResumeFormSectionSupport.resolve(template);

                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: _accent,
                          surface: Colors.white,
                        ),
                    inputDecorationTheme: InputDecorationTheme(
                      labelStyle: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF3D4260),
                      ),
                      floatingLabelStyle: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3D4260),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: _border),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: _accent, width: 1.6),
                      ),
                      contentPadding: const EdgeInsets.only(bottom: 12),
                    ),
                  ),
                  child: Scaffold(
                    backgroundColor: _background,
                    appBar: _buildAppBar(
                      context,
                      isPreviewValidationInProgress,
                    ),
                    body: SafeArea(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                        children: [
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 760),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _TemplateLabel(
                                    name: template?.name ?? 'Unknown',
                                  ),
                                  const SizedBox(height: 18),
                                  if (sections.contains(
                                      ResumeFormSection.profileBasics))
                                    _buildPersonalInformationSection(
                                      context,
                                      document,
                                      sections.contains(
                                        ResumeFormSection.profileImage,
                                      ),
                                    ),
                                  if (sections
                                      .contains(ResumeFormSection.skills)) ...[
                                    const SizedBox(height: 16),
                                    _buildSkillsSection(context, document),
                                  ],
                                  if (sections
                                      .contains(ResumeFormSection.hobbies)) ...[
                                    const SizedBox(height: 16),
                                    _buildTextListSection(
                                      context: context,
                                      title: 'Hobbies',
                                      hint: 'Hobby',
                                      emptyMessage:
                                          'Add hobbies that show personality and range.',
                                      items: document.hobbies,
                                      onChanged: (updated) => context
                                          .read<ResumeBloc>()
                                          .add(UpdateHobbies(updated)),
                                    ),
                                  ],
                                  if (sections.contains(
                                      ResumeFormSection.references)) ...[
                                    const SizedBox(height: 16),
                                    _buildTextListSection(
                                      context: context,
                                      title: 'References',
                                      hint: 'Reference',
                                      emptyMessage:
                                          'Add names, roles, and contact details for references.',
                                      items: document.references,
                                      onChanged: (updated) => context
                                          .read<ResumeBloc>()
                                          .add(UpdateReferences(updated)),
                                    ),
                                  ],
                                  if (sections
                                      .contains(ResumeFormSection.awards)) ...[
                                    const SizedBox(height: 16),
                                    _buildAwardsSection(context, document),
                                  ],
                                  if (sections.contains(
                                      ResumeFormSection.certifications)) ...[
                                    const SizedBox(height: 16),
                                    _buildCertificationsSection(
                                      context,
                                      document,
                                    ),
                                  ],
                                  if (sections.contains(
                                      ResumeFormSection.workExperience)) ...[
                                    const SizedBox(height: 16),
                                    _buildWorkExperienceSection(
                                      context,
                                      document,
                                    ),
                                  ],
                                  if (sections.contains(
                                      ResumeFormSection.education)) ...[
                                    const SizedBox(height: 16),
                                    _buildEducationSection(context, document),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    bool isPreviewValidationInProgress,
  ) {
    return AppBar(
      toolbarHeight: 84,
      backgroundColor: _background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      leading: IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: const Icon(Icons.arrow_back_rounded, size: 32),
        color: _ink,
        tooltip: 'Back',
      ),
      title: Text(
        'Resume Form',
        style: GoogleFonts.inter(
          fontSize: 25,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
          color: _ink,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: TextButton.icon(
            onPressed: isPreviewValidationInProgress
                ? null
                : () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    context.read<ResumeBloc>().add(const ValidateForPreview());
                  },
            style: TextButton.styleFrom(
              foregroundColor: _accent,
              disabledForegroundColor: _accent.withValues(alpha: 0.45),
              textStyle: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            icon: Icon(
              isPreviewValidationInProgress
                  ? Icons.hourglass_empty_rounded
                  : Icons.visibility_outlined,
              size: 28,
            ),
            label: Text(isPreviewValidationInProgress ? 'Checking' : 'Preview'),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final bloc = context.read<ResumeBloc>();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null || !mounted) {
      return;
    }
    bloc.add(UpdatePhoto(image.path));
  }

  Widget _buildPersonalInformationSection(
    BuildContext context,
    ResumeDocument document,
    bool isImageSupported,
  ) {
    return _ResumeFormCard(
      title: 'Basic Information',
      initiallyExpanded: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isImageSupported) ...[
            _ProfileImagePicker(
              photoPath: document.photoPath,
              onPickImage: () => _pickImage(context),
            ),
            const SizedBox(height: 24),
          ],
          _PremiumTextField(
            initialValue: document.fullName,
            label: 'Full name',
            onChanged: (value) =>
                context.read<ResumeBloc>().add(UpdateFullName(value)),
          ),
          const SizedBox(height: 18),
          _PremiumTextField(
            initialValue: document.jobPosition,
            label: 'Job position',
            onChanged: (value) =>
                context.read<ResumeBloc>().add(UpdateJobPosition(value)),
          ),
          const SizedBox(height: 18),
          _PremiumTextField(
            initialValue: document.careerGoals,
            label: 'Summary',
            minLines: 3,
            maxLines: 6,
            onChanged: (value) =>
                context.read<ResumeBloc>().add(UpdateCareerGoals(value)),
          ),
          const SizedBox(height: 18),
          _DateLikeField(
            initialValue: document.birthday,
            label: 'Birth date',
            onChanged: (value) =>
                context.read<ResumeBloc>().add(UpdateBirthday(value)),
          ),
          const SizedBox(height: 18),
          _PremiumTextField(
            initialValue: document.email,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) =>
                context.read<ResumeBloc>().add(UpdateEmail(value)),
          ),
          const SizedBox(height: 18),
          _PremiumTextField(
            initialValue: document.phone,
            label: 'Phone',
            keyboardType: TextInputType.phone,
            onChanged: (value) =>
                context.read<ResumeBloc>().add(UpdatePhone(value)),
          ),
          const SizedBox(height: 18),
          _PremiumTextField(
            initialValue: document.address,
            label: 'Address',
            onChanged: (value) =>
                context.read<ResumeBloc>().add(UpdateAddress(value)),
          ),
          const SizedBox(height: 18),
          _PremiumTextField(
            initialValue: document.website,
            label: 'Portfolio link',
            keyboardType: TextInputType.url,
            onChanged: (value) =>
                context.read<ResumeBloc>().add(UpdateWebsite(value)),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(BuildContext context, ResumeDocument document) {
    final skills = document.skills
        .where((item) => item.name.trim().isNotEmpty)
        .toList(growable: false);

    return _ResumeFormCard(
      title: 'Skills',
      trailing: _SectionAddButton(
        tooltip: 'Add skill',
        onPressed: () => _openSkillEditor(context, document),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (skills.isEmpty)
            const _SectionEmptyState(
              message: 'Add multiple skills and rate each one from 1 to 5.',
            )
          else
            ...skills.asMap().entries.map(
                  (entry) => _SkillItemCard(
                    skill: entry.value,
                    onTap: () => _openSkillEditor(
                      context,
                      document,
                      index: entry.key,
                      initialSkill: entry.value,
                    ),
                    onDelete: () => _removeSkill(context, document, entry.key),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTextListSection({
    required BuildContext context,
    required String title,
    required String hint,
    required String emptyMessage,
    required List<String> items,
    required ValueChanged<List<String>> onChanged,
  }) {
    return _ResumeFormCard(
      title: title,
      trailing: _SectionAddButton(
        tooltip: 'Add $hint',
        onPressed: () => onChanged([...items, '']),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (items.isEmpty)
            _SectionEmptyState(message: emptyMessage)
          else
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final value = entry.value;
              return _EditableListItem(
                child: _PremiumTextField(
                  initialValue: value,
                  label: '$hint ${index + 1}',
                  onChanged: (next) {
                    final updated = [...items];
                    updated[index] = next;
                    onChanged(updated);
                  },
                ),
                onDelete: () {
                  final updated = [...items]..removeAt(index);
                  onChanged(updated);
                },
              );
            }),
        ],
      ),
    );
  }

  Widget _buildAwardsSection(BuildContext context, ResumeDocument document) {
    return _ResumeFormCard(
      title: 'Awards',
      trailing: _SectionAddButton(
        tooltip: 'Add award',
        onPressed: () => context.read<ResumeBloc>().add(
              UpdateAwards([
                ...document.awards,
                const AwardEntry(year: '', name: ''),
              ]),
            ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (document.awards.isEmpty)
            const _SectionEmptyState(message: 'Add awards and recognitions.')
          else
            ...document.awards.asMap().entries.map((entry) {
              final index = entry.key;
              final value = entry.value;
              return _EditableListItem(
                child: _TwoColumnFields(
                  first: _PremiumTextField(
                    initialValue: value.name,
                    label: 'Award title',
                    onChanged: (next) {
                      final updated = [...document.awards];
                      updated[index] = value.copyWith(name: next);
                      context.read<ResumeBloc>().add(UpdateAwards(updated));
                    },
                  ),
                  second: _PremiumTextField(
                    initialValue: value.year,
                    label: 'Year',
                    onChanged: (next) {
                      final updated = [...document.awards];
                      updated[index] = value.copyWith(year: next);
                      context.read<ResumeBloc>().add(UpdateAwards(updated));
                    },
                  ),
                ),
                onDelete: () {
                  final updated = [...document.awards]..removeAt(index);
                  context.read<ResumeBloc>().add(UpdateAwards(updated));
                },
              );
            }),
        ],
      ),
    );
  }

  Widget _buildCertificationsSection(
    BuildContext context,
    ResumeDocument document,
  ) {
    return _ResumeFormCard(
      title: 'Certifications',
      trailing: _SectionAddButton(
        tooltip: 'Add certification',
        onPressed: () => context.read<ResumeBloc>().add(
              UpdateCertifications([
                ...document.certifications,
                const CertEntry(year: '', name: ''),
              ]),
            ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (document.certifications.isEmpty)
            const _SectionEmptyState(message: 'Add licenses and certificates.')
          else
            ...document.certifications.asMap().entries.map((entry) {
              final index = entry.key;
              final value = entry.value;
              return _EditableListItem(
                child: _TwoColumnFields(
                  first: _PremiumTextField(
                    initialValue: value.name,
                    label: 'Certification title',
                    onChanged: (next) {
                      final updated = [...document.certifications];
                      updated[index] = value.copyWith(name: next);
                      context
                          .read<ResumeBloc>()
                          .add(UpdateCertifications(updated));
                    },
                  ),
                  second: _PremiumTextField(
                    initialValue: value.year,
                    label: 'Year',
                    onChanged: (next) {
                      final updated = [...document.certifications];
                      updated[index] = value.copyWith(year: next);
                      context
                          .read<ResumeBloc>()
                          .add(UpdateCertifications(updated));
                    },
                  ),
                ),
                onDelete: () {
                  final updated = [...document.certifications]..removeAt(index);
                  context.read<ResumeBloc>().add(UpdateCertifications(updated));
                },
              );
            }),
        ],
      ),
    );
  }

  Widget _buildWorkExperienceSection(
    BuildContext context,
    ResumeDocument document,
  ) {
    return _ResumeFormCard(
      title: 'Work Experience',
      trailing: _SectionAddButton(
        tooltip: 'Add work experience',
        onPressed: () => _openAddWorkExperience(context, document),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (document.workExperience.isEmpty)
            const _SectionEmptyState(message: 'Add recent roles and impact.')
          else
            ...document.workExperience.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _RecordTile(
                title: '${item.position} at ${item.companyName}',
                subtitle: item.dateRange,
                body: item.description,
                onEdit: () => _openEditWorkExperience(context, document, index),
                onDelete: () {
                  final updated = [...document.workExperience]..removeAt(index);
                  context.read<ResumeBloc>().add(UpdateWorkExperience(updated));
                },
              );
            }),
        ],
      ),
    );
  }

  Widget _buildEducationSection(BuildContext context, ResumeDocument document) {
    return _ResumeFormCard(
      title: 'Education',
      trailing: _SectionAddButton(
        tooltip: 'Add education',
        onPressed: () => _openAddEducation(context, document),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (document.education.isEmpty)
            const _SectionEmptyState(
              message: 'Add schools, courses, or degrees.',
            )
          else
            ...document.education.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _RecordTile(
                title: '${item.coursesSubjects} - ${item.schoolName}',
                subtitle: item.dateRange,
                body: item.description,
                onEdit: () => _openEditEducation(context, document, index),
                onDelete: () {
                  final updated = [...document.education]..removeAt(index);
                  context.read<ResumeBloc>().add(UpdateEducation(updated));
                },
              );
            }),
        ],
      ),
    );
  }

  Future<void> _openAddWorkExperience(
    BuildContext context,
    ResumeDocument document,
  ) async {
    final bloc = context.read<ResumeBloc>();
    final item = await ResumeWorkExperienceBottomSheet.show(context);
    if (item == null || !mounted) return;
    bloc.add(UpdateWorkExperience([...document.workExperience, item]));
  }

  Future<void> _openEditWorkExperience(
    BuildContext context,
    ResumeDocument document,
    int index,
  ) async {
    final bloc = context.read<ResumeBloc>();
    final item = await ResumeWorkExperienceBottomSheet.show(
      context,
      initialValue: document.workExperience[index],
    );
    if (item == null || !mounted) return;
    final updated = [...document.workExperience];
    updated[index] = item;
    bloc.add(UpdateWorkExperience(updated));
  }

  Future<void> _openAddEducation(
    BuildContext context,
    ResumeDocument document,
  ) async {
    final bloc = context.read<ResumeBloc>();
    final item = await ResumeEducationBottomSheet.show(context);
    if (item == null || !mounted) return;
    bloc.add(UpdateEducation([...document.education, item]));
  }

  Future<void> _openEditEducation(
    BuildContext context,
    ResumeDocument document,
    int index,
  ) async {
    final bloc = context.read<ResumeBloc>();
    final item = await ResumeEducationBottomSheet.show(
      context,
      initialValue: document.education[index],
    );
    if (item == null || !mounted) return;
    final updated = [...document.education];
    updated[index] = item;
    bloc.add(UpdateEducation(updated));
  }

  Future<void> _openSkillEditor(
    BuildContext context,
    ResumeDocument document, {
    int? index,
    SkillEntry? initialSkill,
  }) async {
    final bloc = context.read<ResumeBloc>();
    final result = await SkillRatingBottomSheet.show(
      context,
      initialName: initialSkill?.name ?? '',
      initialRating: initialSkill?.rating ?? kDefaultSkillRating,
      title: initialSkill == null ? 'Add skill' : 'Edit skill',
      nameLabel: 'Skill title',
      saveLabel: initialSkill == null ? 'Add skill' : 'Save skill',
    );

    if (result == null || !mounted) {
      return;
    }

    final updated = [...document.skills];
    final skill = SkillEntry(name: result.name, rating: result.rating);
    if (index == null) {
      updated.add(skill);
    } else if (index >= 0 && index < updated.length) {
      updated[index] = skill;
    }

    bloc.add(UpdateSkills(updated));
  }

  void _removeSkill(BuildContext context, ResumeDocument document, int index) {
    if (index < 0 || index >= document.skills.length) {
      return;
    }

    final updated = [...document.skills]..removeAt(index);
    context.read<ResumeBloc>().add(UpdateSkills(updated));
  }
}

class _TemplateLabel extends StatelessWidget {
  const _TemplateLabel({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.inter(
          fontSize: 20,
          height: 1.35,
          color: _ResumeFormPageState._ink,
        ),
        children: [
          TextSpan(
            text: 'Template: ',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w800,
              color: _ResumeFormPageState._accent,
            ),
          ),
          TextSpan(
            text: name,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: _ResumeFormPageState._accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumeFormCard extends StatelessWidget {
  const _ResumeFormCard({
    required this.title,
    required this.child,
    this.trailing,
    this.initiallyExpanded = false,
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _ResumeFormPageState._cardTint,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFEFEAF8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF111827).withValues(alpha: 0.06),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.fromLTRB(22, 18, 18, 12),
          childrenPadding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
          iconColor: _ResumeFormPageState._accent,
          collapsedIconColor: const Color(0xFF555A78),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                    color: _ResumeFormPageState._ink,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          children: [child],
        ),
      ),
    );
  }
}

class _ProfileImagePicker extends StatelessWidget {
  const _ProfileImagePicker({
    required this.photoPath,
    required this.onPickImage,
  });

  final String photoPath;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    final file = File(photoPath);
    final hasImage = photoPath.trim().isNotEmpty && file.existsSync();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile image',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF3D4260),
          ),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 430;
            final preview = Container(
              width: 118,
              height: 118,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFD7D3E8)),
                image: hasImage
                    ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
                    : null,
              ),
              child: hasImage
                  ? null
                  : const Icon(
                      Icons.cloud_upload_outlined,
                      size: 52,
                      color: _ResumeFormPageState._accent,
                    ),
            );
            final button = OutlinedButton.icon(
              onPressed: onPickImage,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _ResumeFormPageState._accent,
                side: const BorderSide(color: Color(0xFFD7D3E8)),
                elevation: 3,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
                textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              icon: const Icon(Icons.info_outline_rounded, size: 26),
              label: Text(hasImage ? 'Change image' : 'Select image'),
            );

            if (isCompact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  preview,
                  const SizedBox(height: 14),
                  SizedBox(width: double.infinity, child: button),
                ],
              );
            }

            return Row(
              children: [
                preview,
                const SizedBox(width: 28),
                Expanded(child: button),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _PremiumTextField extends StatelessWidget {
  const _PremiumTextField({
    required this.initialValue,
    required this.label,
    required this.onChanged,
    this.keyboardType,
    this.minLines,
    this.maxLines = 1,
  });

  final String initialValue;
  final String label;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      style: GoogleFonts.inter(
        fontSize: 19,
        height: 1.42,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF0B102B),
      ),
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
    );
  }
}

class _DateLikeField extends StatelessWidget {
  const _DateLikeField({
    required this.initialValue,
    required this.label,
    required this.onChanged,
  });

  final String initialValue;
  final String label;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: _PremiumTextField(
            initialValue: initialValue,
            label: label,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _ResumeFormPageState._border),
          ),
          child: const Icon(
            Icons.calendar_month_outlined,
            color: Color(0xFF3D4260),
          ),
        ),
      ],
    );
  }
}

class _TwoColumnFields extends StatelessWidget {
  const _TwoColumnFields({
    required this.first,
    required this.second,
  });

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 430) {
          return Column(
            children: [
              first,
              const SizedBox(height: 12),
              second,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: first),
            const SizedBox(width: 14),
            Expanded(child: second),
          ],
        );
      },
    );
  }
}

class _SectionAddButton extends StatelessWidget {
  const _SectionAddButton({
    required this.onPressed,
    required this.tooltip,
  });

  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFFF0E8FF),
        foregroundColor: _ResumeFormPageState._accent,
        minimumSize: const Size.square(42),
      ),
      icon: const Icon(Icons.add_rounded),
      tooltip: tooltip,
    );
  }
}

class _SectionEmptyState extends StatelessWidget {
  const _SectionEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E5F2)),
      ),
      child: Text(
        message,
        style: GoogleFonts.inter(
          fontSize: 14,
          height: 1.45,
          color: const Color(0xFF5D637C),
        ),
      ),
    );
  }
}

class _EditableListItem extends StatelessWidget {
  const _EditableListItem({
    required this.child,
    required this.onDelete,
  });

  final Widget child;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 6, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8E5F2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: child),
          const SizedBox(width: 6),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
            color: const Color(0xFFB42318),
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }
}

class _SkillItemCard extends StatelessWidget {
  const _SkillItemCard({
    required this.skill,
    required this.onTap,
    required this.onDelete,
  });

  final SkillEntry skill;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8E5F2)),
      ),
      child: SkillRatingRow(
        name: skill.name,
        rating: skill.rating,
        onTap: onTap,
        onDelete: onDelete,
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final String subtitle;
  final String body;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8E5F2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: _ResumeFormPageState._ink,
                  ),
                ),
                if (subtitle.trim().isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _ResumeFormPageState._accent,
                    ),
                  ),
                ],
                if (body.trim().isNotEmpty) ...[
                  const SizedBox(height: 7),
                  Text(
                    body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.35,
                      color: const Color(0xFF5D637C),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            color: _ResumeFormPageState._accent,
            tooltip: 'Edit',
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
            color: const Color(0xFFB42318),
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }
}
