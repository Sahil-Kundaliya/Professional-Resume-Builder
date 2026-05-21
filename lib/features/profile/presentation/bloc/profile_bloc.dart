import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/resume_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/load_resume_profile.dart';
import '../../domain/usecases/save_resume_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required this.repository})
      : super(const ProfileState.initial()) {
    on<LoadProfile>(_onLoadProfile);
    on<StartEditing>(_onStartEditing);
    on<UpdateDraft>(_onUpdateDraft);
    on<SaveProfile>(_onSaveProfile);
  }

  final IProfileRepository repository;

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState.loading());
    try {
      final usecase = LoadResumeProfileUsecase(repository);
      final profile = await usecase();
      emit(
        ProfileState.loaded(
          profile: _ensureInitialRows(profile),
          draft: ProfileEditDraft(profile: _ensureInitialRows(profile)),
        ),
      );
    } catch (error) {
      emit(ProfileState.error('Failed to load profile: ${error.toString()}'));
    }
  }

  Future<void> _onStartEditing(
    StartEditing event,
    Emitter<ProfileState> emit,
  ) async {
    state.mapOrNull(
      loaded: (loadedState) {
        emit(
          loadedState.copyWith(
            isEditing: true,
            draft: ProfileEditDraft(
              profile: loadedState.profile,
              hasUnsavedChanges: false,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onUpdateDraft(
    UpdateDraft event,
    Emitter<ProfileState> emit,
  ) async {
    state.mapOrNull(
      loaded: (loadedState) {
        emit(
          loadedState.copyWith(
            draft: event.draft.copyWith(hasUnsavedChanges: true),
            isEditing: true,
          ),
        );
      },
    );
  }

  Future<void> _onSaveProfile(
    SaveProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    await currentState.mapOrNull(
      loaded: (loadedState) async {
        emit(loadedState.copyWith(isSaving: true));
        try {
          final usecase = SaveResumeProfileUsecase(repository);
          final savedProfile = await usecase(loadedState.draft.profile);
          final normalizedProfile = _ensureInitialRows(savedProfile);
          emit(
            loadedState.copyWith(
              profile: normalizedProfile,
              draft: ProfileEditDraft(profile: normalizedProfile),
              isEditing: false,
              isSaving: false,
            ),
          );
        } catch (error) {
          emit(ProfileState.error(
              'Failed to save profile: ${error.toString()}'));
        }
      },
    );
  }

  ResumeProfile _ensureInitialRows(ResumeProfile profile) {
    return profile.copyWith(
      skills: profile.skills.isEmpty ? const [ProfileSkill()] : profile.skills,
      hobbies:
          profile.hobbies.isEmpty ? const [ProfileHobby()] : profile.hobbies,
    );
  }
}
