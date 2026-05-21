import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../config/di/injection_container.dart';
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
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
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
                  padding: const EdgeInsets.all(20),
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
                      const SizedBox(height: 16),
                      _buildSkillsSection(effectiveProfile),
                      const SizedBox(height: 12),
                      _buildExperienceSection(effectiveProfile),
                      const SizedBox(height: 12),
                      _buildEducationSection(effectiveProfile),
                      const SizedBox(height: 12),
                      _buildAwardsSection(effectiveProfile),
                      const SizedBox(height: 12),
                      _buildCertificationsSection(effectiveProfile),
                      const SizedBox(height: 12),
                      _buildHobbiesSection(effectiveProfile),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isSaving
                            ? null
                            : () => _saveProfile(context, effectiveProfile),
                        child: Text(isSaving ? 'Saving...' : 'Save profile'),
                      ),
                    ],
                  ),
                ),
              );
            },
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
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ProfileSectionListTile(
                      title: entry.value.name,
                      subtitle: 'Rating: ${entry.value.rating}/5',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < entry.value.rating
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: Colors.amber.shade700,
                            size: 18,
                          ),
                        ),
                      ),
                      onTap: () => _openEditSkill(entry.key, entry.value),
                    ),
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
            ...profile.experiences.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ProfileSectionListTile(
                  title: '${item.position} at ${item.companyName}',
                  subtitle: ProfileSectionDateFormatter.formatRange(
                      item.startDate, item.endDate),
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
            ...profile.educationRecords.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ProfileSectionListTile(
                  title: item.degreeName,
                  subtitle: item.schoolName,
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
            ...profile.awards.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ProfileSectionListTile(
                  title: item.title,
                  subtitle: ProfileSectionDateFormatter.format(item.date),
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
            ...profile.certifications.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ProfileSectionListTile(
                  title: item.title,
                  subtitle: ProfileSectionDateFormatter.format(item.date),
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
              spacing: 8,
              runSpacing: 6,
              children: hobbies.map((h) => Chip(label: Text(h.name))).toList(),
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
