import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/resume_document.dart';
import '../../domain/repositories/resume_repository.dart';
import 'resume_event.dart';
import 'resume_state.dart';

class ResumeBloc extends Bloc<ResumeEvent, ResumeState> {
  final IResumeRepository repository;

  ResumeBloc({required this.repository}) : super(const ResumeState.initial()) {
    on<CreateResume>(_onCreateResume);
    on<LoadResume>(_onLoadResume);
    on<LoadSample>(_onLoadSample);
    on<UpdateDocument>(_onUpdateDocument);
    on<UpdateFullName>(_onUpdateFullName);
    on<UpdateJobPosition>(_onUpdateJobPosition);
    on<UpdateCareerGoals>(_onUpdateCareerGoals);
    on<UpdateEmail>(_onUpdateEmail);
    on<UpdatePhone>(_onUpdatePhone);
    on<UpdateAddress>(_onUpdateAddress);
    on<UpdateBirthday>(_onUpdateBirthday);
    on<UpdateWebsite>(_onUpdateWebsite);
    on<UpdatePhoto>(_onUpdatePhoto);
    on<SelectField>(_onSelectField);
    on<SaveResume>(_onSaveResume);
  }

  Future<void> _onCreateResume(
      CreateResume event, Emitter<ResumeState> emit) async {
    emit(const ResumeState.loading());
    try {
      final doc = ResumeDocument.blank();
      emit(ResumeState.loaded(
        document: doc,
        selectedFieldId: null,
        template: event.template,
      ));
    } catch (e) {
      emit(ResumeState.error('Failed to create resume: ${e.toString()}'));
    }
  }

  Future<void> _onLoadResume(
      LoadResume event, Emitter<ResumeState> emit) async {
    emit(const ResumeState.loading());
    try {
      final doc = await repository.getResume(event.resumeId);
      emit(ResumeState.loaded(document: doc, selectedFieldId: null));
    } catch (e) {
      emit(ResumeState.error('Failed to load resume: ${e.toString()}'));
    }
  }

  Future<void> _onLoadSample(
      LoadSample event, Emitter<ResumeState> emit) async {
    emit(const ResumeState.loading());
    try {
      final doc = ResumeDocument.sampleJohnDoe();
      emit(ResumeState.loaded(document: doc, selectedFieldId: null));
    } catch (e) {
      emit(ResumeState.error('Failed to load sample: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateDocument(
      UpdateDocument event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(ResumeState.loaded(
        document: event.document,
        selectedFieldId: s.selectedFieldId,
        template: s.template,
      ));
    });
  }

  Future<void> _onUpdateFullName(
      UpdateFullName event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(ResumeState.loaded(
        document: s.document.copyWith(fullName: event.value),
        selectedFieldId: s.selectedFieldId,
        template: s.template,
      ));
    });
  }

  Future<void> _onUpdateJobPosition(
      UpdateJobPosition event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(ResumeState.loaded(
        document: s.document.copyWith(jobPosition: event.value),
        selectedFieldId: s.selectedFieldId,
        template: s.template,
      ));
    });
  }

  Future<void> _onUpdateCareerGoals(
      UpdateCareerGoals event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(ResumeState.loaded(
        document: s.document.copyWith(careerGoals: event.value),
        selectedFieldId: s.selectedFieldId,
        template: s.template,
      ));
    });
  }

  Future<void> _onUpdateEmail(
      UpdateEmail event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(ResumeState.loaded(
        document: s.document.copyWith(email: event.value),
        selectedFieldId: s.selectedFieldId,
        template: s.template,
      ));
    });
  }

  Future<void> _onUpdatePhone(
      UpdatePhone event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(ResumeState.loaded(
        document: s.document.copyWith(phone: event.value),
        selectedFieldId: s.selectedFieldId,
        template: s.template,
      ));
    });
  }

  Future<void> _onUpdateAddress(
      UpdateAddress event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(ResumeState.loaded(
        document: s.document.copyWith(address: event.value),
        selectedFieldId: s.selectedFieldId,
        template: s.template,
      ));
    });
  }

  Future<void> _onUpdateBirthday(
      UpdateBirthday event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(ResumeState.loaded(
        document: s.document.copyWith(birthday: event.value),
        selectedFieldId: s.selectedFieldId,
        template: s.template,
      ));
    });
  }

  Future<void> _onUpdateWebsite(
      UpdateWebsite event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(ResumeState.loaded(
        document: s.document.copyWith(website: event.value),
        selectedFieldId: s.selectedFieldId,
        template: s.template,
      ));
    });
  }

  Future<void> _onUpdatePhoto(
      UpdatePhoto event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(ResumeState.loaded(
        document: s.document.copyWith(photoPath: event.path),
        selectedFieldId: s.selectedFieldId,
        template: s.template,
      ));
    });
  }

  Future<void> _onSelectField(
      SelectField event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(ResumeState.loaded(
        document: s.document,
        selectedFieldId: event.fieldId,
        template: s.template,
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
        selectedFieldId: loaded.selectedFieldId,
        template: loaded.template,
      ));
      emit(ResumeState.loaded(
        document: loaded.document,
        selectedFieldId: loaded.selectedFieldId,
        template: loaded.template,
      ));
    } catch (e) {
      emit(ResumeState.error('Failed to save resume: ${e.toString()}'));
    }
  }
}
