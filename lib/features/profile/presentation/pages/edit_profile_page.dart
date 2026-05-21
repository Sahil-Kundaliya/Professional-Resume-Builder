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
import '../widgets/basic_details_section.dart';

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

    _saveRequested = true;
    context.read<ProfileBloc>()
      ..add(ProfileEvent.updateDraft(ProfileEditDraft(
        profile: updatedProfile,
        hasUnsavedChanges: true,
      )))
      ..add(const ProfileEvent.saveProfile());
  }

  void _emitDraftUpdate() {
    if (!mounted || _isHydrating) {
      return;
    }

    final baseProfile = _baseProfile;
    if (baseProfile == null) {
      return;
    }

    context.read<ProfileBloc>().add(
          ProfileEvent.updateDraft(
            ProfileEditDraft(
              profile: _buildDraftProfile(baseProfile),
              hasUnsavedChanges: true,
            ),
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
}
