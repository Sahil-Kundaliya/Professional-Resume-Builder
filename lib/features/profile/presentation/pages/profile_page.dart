import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/di/injection_container.dart';
import '../../../../core/constants/app_routes.dart';
import '../../domain/entities/resume_profile.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_awards_section.dart';
import '../widgets/profile_certifications_section.dart';
import '../widgets/profile_contact_section.dart';
import '../widgets/profile_education_section.dart';
import '../widgets/profile_experience_section.dart';
import '../widgets/profile_hobbies_section.dart';
import '../widgets/profile_identity_card.dart';
import '../widgets/profile_skills_section.dart';
import '../widgets/profile_summary_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ProfileBloc>()..add(const ProfileEvent.loadProfile()),
      child: const _ProfilePageView(),
    );
  }
}

class _ProfilePageView extends StatefulWidget {
  const _ProfilePageView();

  @override
  State<_ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<_ProfilePageView> {
  Future<void> _openEditProfile() async {
    final didSave = await Navigator.pushNamed(context, AppRoutes.editProfile);
    if (!mounted) {
      return;
    }

    if (didSave == true) {
      context.read<ProfileBloc>().add(const ProfileEvent.loadProfile());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0.5,
        actions: [
          TextButton(
            onPressed: _openEditProfile,
            child: Text(
              'Edit',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            loaded: (profile, draft, isEditing, isSaving) {
              final displayProfile = _mergeDraft(profile, draft.profile);
              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfileIdentityCard(profile: displayProfile),
                      const SizedBox(height: 20),
                      ProfileSummarySection(profile: displayProfile),
                      const SizedBox(height: 12),
                      ProfileSkillsSection(skills: displayProfile.skills),
                      if (displayProfile.skills
                          .where((item) => item.name.trim().isNotEmpty)
                          .isNotEmpty)
                        const SizedBox(height: 12),
                      ProfileContactSection(profile: displayProfile),
                      const SizedBox(height: 12),
                      ProfileExperienceSection(
                          experiences: displayProfile.experiences),
                      if (displayProfile.experiences.isNotEmpty)
                        const SizedBox(height: 12),
                      ProfileEducationSection(
                          educationRecords: displayProfile.educationRecords),
                      if (displayProfile.educationRecords.isNotEmpty)
                        const SizedBox(height: 12),
                      ProfileAwardsSection(awards: displayProfile.awards),
                      if (displayProfile.awards.isNotEmpty)
                        const SizedBox(height: 12),
                      ProfileCertificationsSection(
                          certifications: displayProfile.certifications),
                      if (displayProfile.certifications.isNotEmpty)
                        const SizedBox(height: 12),
                      ProfileHobbiesSection(hobbies: displayProfile.hobbies),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  ResumeProfile _mergeDraft(ResumeProfile profile, ResumeProfile draftProfile) {
    return draftProfile.updatedAt == null ? profile : draftProfile;
  }
}
