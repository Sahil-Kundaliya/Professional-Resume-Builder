import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/mappers/profile_to_resume_prefill_mapper.dart';
import '../../domain/entities/resume_document.dart';
import '../../domain/repositories/resume_repository.dart';
import 'resume_event.dart';
import 'resume_state.dart';

class ResumeBloc extends Bloc<ResumeEvent, ResumeState> {
  final IResumeRepository repository;
  final ProfileToResumePrefillMapper prefillMapper;
  bool _isCreatingResume = false;

  ResumeBloc({
    required this.repository,
    required this.prefillMapper,
  }) : super(const ResumeState.initial()) {
    on<CreateResume>(_onCreateResume);
    on<LoadResume>(_onLoadResume);
    on<LoadSample>(_onLoadSample);
    on<UpdateFullName>(_onUpdateFullName);
    on<UpdateJobPosition>(_onUpdateJobPosition);
    on<UpdateCareerGoals>(_onUpdateCareerGoals);
    on<UpdateEmail>(_onUpdateEmail);
    on<UpdatePhone>(_onUpdatePhone);
    on<UpdateAddress>(_onUpdateAddress);
    on<UpdateBirthday>(_onUpdateBirthday);
    on<UpdateWebsite>(_onUpdateWebsite);
    on<UpdatePhoto>(_onUpdatePhoto);
    on<UpdateWorkExperience>(_onUpdateWorkExperience);
    on<UpdateEducation>(_onUpdateEducation);
    on<UpdateSkills>(_onUpdateSkills);
    on<UpdateHobbies>(_onUpdateHobbies);
    on<UpdateAwards>(_onUpdateAwards);
    on<UpdateCertifications>(_onUpdateCertifications);
    on<UpdateReferences>(_onUpdateReferences);
    on<SaveResume>(_onSaveResume);
  }

  Future<void> _onCreateResume(
      CreateResume event, Emitter<ResumeState> emit) async {
    if (_isCreatingResume) {
      return;
    }

    _isCreatingResume = true;
    emit(const ResumeState.loading());
    try {
      final baseDocument = ResumeDocument.blank();
      final doc = event.prefillProfile == null
          ? baseDocument
          : prefillMapper.applyPrefill(
              base: baseDocument,
              profile: event.prefillProfile!,
            );
      emit(ResumeState.loaded(
        document: doc,
        template: event.template,
      ));
    } catch (e) {
      emit(ResumeState.error('Failed to create resume: ${e.toString()}'));
    } finally {
      _isCreatingResume = false;
    }
  }

  Future<void> _onLoadResume(
      LoadResume event, Emitter<ResumeState> emit) async {
    emit(const ResumeState.loading());
    try {
      final doc = await repository.getResume(event.resumeId);
      emit(ResumeState.loaded(
        document: doc,
      ));
    } catch (e) {
      emit(ResumeState.error('Failed to load resume: ${e.toString()}'));
    }
  }

  Future<void> _onLoadSample(
      LoadSample event, Emitter<ResumeState> emit) async {
    emit(const ResumeState.loading());
    try {
      final doc = ResumeDocument.sampleJohnDoe();
      emit(ResumeState.loaded(
        document: doc,
      ));
    } catch (e) {
      emit(ResumeState.error('Failed to load sample: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateFullName(
      UpdateFullName event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(fullName: event.value),
      ));
    });
  }

  Future<void> _onUpdateJobPosition(
      UpdateJobPosition event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(jobPosition: event.value),
      ));
    });
  }

  Future<void> _onUpdateCareerGoals(
      UpdateCareerGoals event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(careerGoals: event.value),
      ));
    });
  }

  Future<void> _onUpdateEmail(
      UpdateEmail event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(email: event.value),
      ));
    });
  }

  Future<void> _onUpdatePhone(
      UpdatePhone event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(phone: event.value),
      ));
    });
  }

  Future<void> _onUpdateAddress(
      UpdateAddress event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(address: event.value),
      ));
    });
  }

  Future<void> _onUpdateBirthday(
      UpdateBirthday event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(birthday: event.value),
      ));
    });
  }

  Future<void> _onUpdateWebsite(
      UpdateWebsite event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(website: event.value),
      ));
    });
  }

  Future<void> _onUpdatePhoto(
      UpdatePhoto event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(photoPath: event.path),
      ));
    });
  }

  Future<void> _onUpdateWorkExperience(
      UpdateWorkExperience event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(workExperience: event.value),
      ));
    });
  }

  Future<void> _onUpdateEducation(
      UpdateEducation event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(education: event.value),
      ));
    });
  }

  Future<void> _onUpdateSkills(
      UpdateSkills event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(skills: event.value),
      ));
    });
  }

  Future<void> _onUpdateHobbies(
      UpdateHobbies event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(hobbies: event.value),
      ));
    });
  }

  Future<void> _onUpdateAwards(
      UpdateAwards event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(awards: event.value),
      ));
    });
  }

  Future<void> _onUpdateCertifications(
      UpdateCertifications event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(certifications: event.value),
      ));
    });
  }

  Future<void> _onUpdateReferences(
      UpdateReferences event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(references: event.value),
      ));
    });
  }

  Future<void> _onSaveResume(
      SaveResume event, Emitter<ResumeState> emit) async {
    final loaded = state.mapOrNull(loaded: (s) => s);
    if (loaded == null) return;

    emit(ResumeState.saving());
    try {
      await repository.createResume(loaded.document);
      emit(ResumeState.saved(
        document: loaded.document,
        template: loaded.template,
      ));
      emit(ResumeState.loaded(
        document: loaded.document,
        template: loaded.template,
      ));
    } catch (e) {
      emit(ResumeState.error('Failed to save resume: ${e.toString()}'));
    }
  }

  ResumeState _buildLoadedState(
    ResumeState state, {
    ResumeDocument? document,
  }) {
    final s = state.mapOrNull(loaded: (loaded) => loaded);
    if (s == null) return state;

    return ResumeState.loaded(
      document: document ?? s.document,
      template: s.template,
    );
  }
}
