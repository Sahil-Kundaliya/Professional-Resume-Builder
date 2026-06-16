import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../config/di/injection_container.dart';
import '../../../../core/widgets/skill_rating/skill_rating.dart';
import '../../data/datasources/profile_local_data_source.dart';
import '../../domain/entities/resume_profile.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/award_bottom_sheet.dart';
import '../widgets/basic_details_section.dart';
import '../widgets/certification_bottom_sheet.dart';
import '../widgets/education_bottom_sheet.dart';
import '../widgets/experience_bottom_sheet.dart';
import '../widgets/profile_list_empty_state.dart';
import '../widgets/profile_section_card.dart';
import '../widgets/profile_section_date_formatter.dart';
import '../widgets/profile_section_header.dart';
import '../widgets/profile_section_list_tiles.dart';
import '../widgets/skill_bottom_sheet.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const _ink = Color(0xFF080D32);
  static const _accent = Color(0xFF5B2ECC);
  static const _background = Color(0xFFFAFAFD);

  final _fullNameController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _portfolioController = TextEditingController();

  String _imagePath = '';
  String _countryCode = '+1';
  DateTime? _birthDate;
  String? _initializedProfileId;
  bool _saveRequested = false;
  bool _isHydrating = false;
  ResumeProfile? _baseProfile;
  ResumeProfile? _workingProfile;

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(_emitDraftUpdate);
    _jobTitleController.addListener(_emitDraftUpdate);
    _summaryController.addListener(_emitDraftUpdate);
    _emailController.addListener(_emitDraftUpdate);
    _addressController.addListener(_emitDraftUpdate);
    _phoneController.addListener(_emitDraftUpdate);
    _portfolioController.addListener(_emitDraftUpdate);
  }

  @override
  void dispose() {
    _fullNameController.removeListener(_emitDraftUpdate);
    _jobTitleController.removeListener(_emitDraftUpdate);
    _summaryController.removeListener(_emitDraftUpdate);
    _emailController.removeListener(_emitDraftUpdate);
    _addressController.removeListener(_emitDraftUpdate);
    _phoneController.removeListener(_emitDraftUpdate);
    _portfolioController.removeListener(_emitDraftUpdate);
    _fullNameController.dispose();
    _jobTitleController.dispose();
    _summaryController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        state.mapOrNull(
          loaded: (loadedState) {
            _initializeFields(loadedState.profile);
            if (_saveRequested && !loadedState.isSaving) {
              _saveRequested = false;
              Navigator.pop(context, true);
            }
          },
          error: (errorState) {
            if (_saveRequested) {
              _saveRequested = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorState.message)),
              );
            }
          },
        );
      },
      builder: (context, state) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: _accent,
                  surface: Colors.white,
                ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              labelStyle: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF353B5B),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFD6D8E6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _accent, width: 1.5),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
          child: Scaffold(
            backgroundColor: _background,
            appBar: AppBar(
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
                'Edit Profile',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                  color: _ink,
                ),
              ),
            ),
            body: state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                ),
              ),
              loaded: (profile, draft, isEditing, isSaving) {
                final effectiveProfile =
                    draft.hasUnsavedChanges ? draft.profile : profile;
                final birthDateLabel = _birthDate == null
                    ? 'Select birth date'
                    : DateFormat('dd MMM yyyy').format(_birthDate!);

                return SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        BasicDetailsSection(
                          fullNameController: _fullNameController,
                          jobTitleController: _jobTitleController,
                          summaryController: _summaryController,
                          emailController: _emailController,
                          addressController: _addressController,
                          phoneController: _phoneController,
                          portfolioController: _portfolioController,
                          imagePath: _imagePath,
                          countryCode: _countryCode,
                          birthDateLabel: birthDateLabel,
                          onPickImage: _pickImage,
                          onCountryCodeChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _countryCode = value;
                            });
                            _emitDraftUpdate();
                          },
                          onPickBirthDate: _pickBirthDate,
                        ),
                        const SizedBox(height: 18),
                        _buildSkillsSection(effectiveProfile),
                        const SizedBox(height: 14),
                        _buildExperienceSection(effectiveProfile),
                        const SizedBox(height: 14),
                        _buildEducationSection(effectiveProfile),
                        const SizedBox(height: 14),
                        _buildAwardsSection(effectiveProfile),
                        const SizedBox(height: 14),
                        _buildCertificationsSection(effectiveProfile),
                        const SizedBox(height: 14),
                        _buildHobbiesSection(effectiveProfile),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: isSaving
                              ? null
                              : () => _saveProfile(context, effectiveProfile),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accent,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                _accent.withValues(alpha: 0.45),
                            disabledForegroundColor: Colors.white70,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            textStyle: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          child: Text(isSaving ? 'Saving...' : 'Save Changes'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _initializeFields(ResumeProfile profile) {
    if (_initializedProfileId == profile.id) {
      return;
    }

    _isHydrating = true;
    _initializedProfileId = profile.id;
    _baseProfile = profile;
    _fullNameController.text = profile.fullName;
    _jobTitleController.text = profile.jobTitle;
    _summaryController.text = profile.summary;
    _emailController.text = profile.email;
    _addressController.text = profile.address;
    _phoneController.text = profile.phoneNumber;
    _portfolioController.text = profile.portfolioLink;
    _imagePath = profile.profileImagePath;
    _countryCode = profile.phoneCountryCode;
    _birthDate = profile.birthDate;
    _workingProfile = profile;
    _isHydrating = false;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final selectedFile = await picker.pickImage(source: ImageSource.gallery);
    if (selectedFile == null) {
      return;
    }

    final persistedPath = await getIt<ProfileLocalDataSource>()
        .persistSelectedImage(selectedFile);
    if (!mounted) {
      return;
    }

    setState(() {
      _imagePath = persistedPath;
    });
    _emitDraftUpdate();
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _birthDate = picked;
    });
    _emitDraftUpdate();
  }

  void _saveProfile(BuildContext context, ResumeProfile profile) {
    final updatedProfile = _buildDraftProfile(profile);
    _workingProfile = updatedProfile;

    _saveRequested = true;
    _dispatchDraftProfile(updatedProfile);
    context.read<ProfileBloc>().add(const ProfileEvent.saveProfile());
  }

  void _emitDraftUpdate() {
    if (!mounted || _isHydrating) {
      return;
    }

    final baseProfile = _workingProfile ?? _baseProfile;
    if (baseProfile == null) {
      return;
    }

    _dispatchDraftProfile(_buildDraftProfile(baseProfile));
  }

  void _dispatchDraftProfile(ResumeProfile profile) {
    _workingProfile = profile;
    context.read<ProfileBloc>().add(
          ProfileEvent.updateDraft(
            ProfileEditDraft(
              profile: profile,
              hasUnsavedChanges: true,
            ),
          ),
        );
  }

  void _applyProfileMutation(ResumeProfile Function(ResumeProfile) mutate) {
    final baseProfile = _workingProfile ?? _baseProfile;
    if (baseProfile == null) {
      return;
    }

    final updatedProfile = mutate(_buildDraftProfile(baseProfile));
    _dispatchDraftProfile(updatedProfile);
  }

  List<T> _appendItem<T>(List<T> source, T item) {
    return [...source, item];
  }

  List<T> _updateItemAt<T>(List<T> source, int index, T item) {
    if (index < 0 || index >= source.length) {
      return source;
    }
    return [...source]..[index] = item;
  }

  List<T> _removeItemAt<T>(List<T> source, int index) {
    if (index < 0 || index >= source.length) {
      return source;
    }
    return [...source]..removeAt(index);
  }

  void appendExperience(ProfileExperience item) {
    _applyProfileMutation(
      (profile) => profile.copyWith(
        experiences: _appendItem(profile.experiences, item),
      ),
    );
  }

  void appendSkill(ProfileSkill item) {
    _applyProfileMutation(
      (profile) => profile.copyWith(
        skills: _appendItem(_visibleSkills(profile), item),
      ),
    );
  }

  void updateExperienceAt(int index, ProfileExperience item) {
    _applyProfileMutation(
      (profile) => profile.copyWith(
        experiences: _updateItemAt(profile.experiences, index, item),
      ),
    );
  }

  void updateSkillAt(int index, ProfileSkill item) {
    _applyProfileMutation(
      (profile) => profile.copyWith(
        skills: _updateItemAt(_visibleSkills(profile), index, item),
      ),
    );
  }

  void removeSkillAt(int index) {
    _applyProfileMutation(
      (profile) {
        final skills = _visibleSkills(profile);
        return profile.copyWith(
          skills: _removeItemAt(skills, index),
        );
      },
    );
  }

  void removeExperienceAt(int index) {
    _applyProfileMutation(
      (profile) => profile.copyWith(
        experiences: _removeItemAt(profile.experiences, index),
      ),
    );
  }

  void appendEducation(ProfileEducation item) {
    _applyProfileMutation(
      (profile) => profile.copyWith(
        educationRecords: _appendItem(profile.educationRecords, item),
      ),
    );
  }

  void updateEducationAt(int index, ProfileEducation item) {
    _applyProfileMutation(
      (profile) => profile.copyWith(
        educationRecords: _updateItemAt(profile.educationRecords, index, item),
      ),
    );
  }

  void removeEducationAt(int index) {
    _applyProfileMutation(
      (profile) => profile.copyWith(
        educationRecords: _removeItemAt(profile.educationRecords, index),
      ),
    );
  }

  void appendAward(ProfileAward item) {
    _applyProfileMutation(
      (profile) => profile.copyWith(
        awards: _appendItem(profile.awards, item),
      ),
    );
  }

  void updateAwardAt(int index, ProfileAward item) {
    _applyProfileMutation(
      (profile) => profile.copyWith(
        awards: _updateItemAt(profile.awards, index, item),
      ),
    );
  }

  void removeAwardAt(int index) {
    _applyProfileMutation(
      (profile) => profile.copyWith(
        awards: _removeItemAt(profile.awards, index),
      ),
    );
  }

  void appendCertification(ProfileCertification item) {
    _applyProfileMutation(
      (profile) => profile.copyWith(
        certifications: _appendItem(profile.certifications, item),
      ),
    );
  }

  void updateCertificationAt(int index, ProfileCertification item) {
    _applyProfileMutation(
      (profile) => profile.copyWith(
        certifications: _updateItemAt(profile.certifications, index, item),
      ),
    );
  }

  void removeCertificationAt(int index) {
    _applyProfileMutation(
      (profile) => profile.copyWith(
        certifications: _removeItemAt(profile.certifications, index),
      ),
    );
  }

  void appendHobby(ProfileHobby item) {
    _applyProfileMutation(
      (profile) => profile.copyWith(
        hobbies: _appendItem(profile.hobbies, item),
      ),
    );
  }

  void updateHobbyAt(int index, ProfileHobby item) {
    _applyProfileMutation(
      (profile) => profile.copyWith(
        hobbies: _updateItemAt(profile.hobbies, index, item),
      ),
    );
  }

  void removeHobbyAt(int index) {
    _applyProfileMutation(
      (profile) {
        final hobbies =
            profile.hobbies.where((h) => h.name.trim().isNotEmpty).toList();
        return profile.copyWith(
          hobbies: _removeItemAt(hobbies, index),
        );
      },
    );
  }

  ResumeProfile _buildDraftProfile(ResumeProfile profile) {
    return profile.copyWith(
      profileImagePath: _imagePath,
      fullName: _fullNameController.text.trim(),
      jobTitle: _jobTitleController.text.trim(),
      summary: _summaryController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      phoneCountryCode: _countryCode,
      phoneNumber: _phoneController.text.trim(),
      birthDate: _birthDate,
      portfolioLink: _portfolioController.text.trim(),
    );
  }

  List<ProfileSkill> _visibleSkills(ResumeProfile profile) {
    return profile.skills.where((item) => item.name.trim().isNotEmpty).toList();
  }

  Widget _buildSkillsSection(ResumeProfile profile) {
    final skills = _visibleSkills(profile);

    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSectionHeader(
            title: 'Skills',
            onAdd: _openAddSkill,
          ),
          if (skills.isEmpty)
            const SizedBox(height: 8)
          else
            const SizedBox(height: 12),
          if (skills.isEmpty)
            const ProfileListEmptyState(
              title: '',
              message: 'Tap + to add multiple skills with ratings from 1 to 5.',
            )
          else
            ...skills.asMap().entries.map(
                  (entry) => SkillRatingRow(
                    name: entry.value.name,
                    rating: entry.value.rating,
                    onTap: () => _openEditSkill(entry.key, entry.value),
                    onDelete: () => _removeSkill(entry.key),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildExperienceSection(ResumeProfile profile) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSectionHeader(
            title: 'Experience',
            onAdd: _openAddExperience,
          ),
          if (profile.experiences.isEmpty)
            const SizedBox(height: 8)
          else
            const SizedBox(height: 12),
          if (profile.experiences.isEmpty)
            const ProfileListEmptyState(
              title: '',
              message: 'Tap + to add your work experience.',
            )
          else
            ...profile.experiences.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ProfileSectionListTile(
                      title:
                          '${entry.value.position} at ${entry.value.companyName}',
                      subtitle: ProfileSectionDateFormatter.formatRange(
                        entry.value.startDate,
                        entry.value.endDate,
                      ),
                      onDelete: () => removeExperienceAt(entry.key),
                      deleteTooltip: 'Remove experience',
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildEducationSection(ResumeProfile profile) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSectionHeader(
            title: 'Education',
            onAdd: _openAddEducation,
          ),
          if (profile.educationRecords.isEmpty)
            const SizedBox(height: 8)
          else
            const SizedBox(height: 12),
          if (profile.educationRecords.isEmpty)
            const ProfileListEmptyState(
              title: '',
              message: 'Tap + to add your education.',
            )
          else
            ...profile.educationRecords.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ProfileSectionListTile(
                      title: entry.value.degreeName,
                      subtitle: entry.value.schoolName,
                      onDelete: () => removeEducationAt(entry.key),
                      deleteTooltip: 'Remove education',
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildAwardsSection(ResumeProfile profile) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSectionHeader(
            title: 'Awards',
            onAdd: _openAddAward,
          ),
          if (profile.awards.isEmpty)
            const SizedBox(height: 8)
          else
            const SizedBox(height: 12),
          if (profile.awards.isEmpty)
            const ProfileListEmptyState(
              title: '',
              message: 'Tap + to add an award.',
            )
          else
            ...profile.awards.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ProfileSectionListTile(
                      title: entry.value.title,
                      subtitle: ProfileSectionDateFormatter.format(
                        entry.value.date,
                      ),
                      onDelete: () => removeAwardAt(entry.key),
                      deleteTooltip: 'Remove award',
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildCertificationsSection(ResumeProfile profile) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSectionHeader(
            title: 'Certifications',
            onAdd: _openAddCertification,
          ),
          if (profile.certifications.isEmpty)
            const SizedBox(height: 8)
          else
            const SizedBox(height: 12),
          if (profile.certifications.isEmpty)
            const ProfileListEmptyState(
              title: '',
              message: 'Tap + to add a certification.',
            )
          else
            ...profile.certifications.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ProfileSectionListTile(
                      title: entry.value.title,
                      subtitle: ProfileSectionDateFormatter.format(
                        entry.value.date,
                      ),
                      onDelete: () => removeCertificationAt(entry.key),
                      deleteTooltip: 'Remove certification',
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildHobbiesSection(ResumeProfile profile) {
    final hobbies =
        profile.hobbies.where((h) => h.name.trim().isNotEmpty).toList();
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSectionHeader(
            title: 'Hobbies',
            onAdd: _openAddHobby,
          ),
          if (hobbies.isEmpty)
            const SizedBox(height: 8)
          else
            const SizedBox(height: 12),
          if (hobbies.isEmpty)
            const ProfileListEmptyState(
              title: '',
              message: 'Tap + to add a hobby.',
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: hobbies.asMap().entries.map((entry) {
                return InputChip(
                  label: Text(entry.value.name),
                  labelStyle: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF242947),
                  ),
                  backgroundColor: const Color(0xFFFBFBFE),
                  side: const BorderSide(color: Color(0xFFE7E8F1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  deleteIcon: const Icon(Icons.close_rounded, size: 18),
                  deleteIconColor: const Color(0xFFB42318),
                  onDeleted: () => removeHobbyAt(entry.key),
                  tooltip: 'Remove hobby',
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Future<void> _openAddExperience() async {
    final item = await ExperienceBottomSheet.show(context);
    if (item == null || !mounted) {
      return;
    }
    appendExperience(item);
  }

  Future<void> _openAddSkill() async {
    final item = await SkillBottomSheet.show(context);
    if (item == null || !mounted) {
      return;
    }
    appendSkill(item);
  }

  Future<void> _openEditSkill(int index, ProfileSkill skill) async {
    final item = await SkillBottomSheet.show(
      context,
      initialSkill: skill,
    );
    if (item == null || !mounted) {
      return;
    }
    updateSkillAt(index, item);
  }

  void _removeSkill(int index) {
    removeSkillAt(index);
  }

  Future<void> _openAddEducation() async {
    final item = await EducationBottomSheet.show(context);
    if (item == null || !mounted) {
      return;
    }
    appendEducation(item);
  }

  Future<void> _openAddAward() async {
    final item = await AwardBottomSheet.show(context);
    if (item == null || !mounted) {
      return;
    }
    appendAward(item);
  }

  Future<void> _openAddCertification() async {
    final item = await CertificationBottomSheet.show(context);
    if (item == null || !mounted) {
      return;
    }
    appendCertification(item);
  }

  Future<void> _openAddHobby() async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add hobby'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Hobby'),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => Navigator.pop(ctx, true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (confirmed != true || controller.text.trim().isEmpty || !mounted) {
      return;
    }
    appendHobby(ProfileHobby(name: controller.text.trim()));
  }
}
