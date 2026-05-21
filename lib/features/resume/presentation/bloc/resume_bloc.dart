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
    on<ToggleSelectedBold>(_onToggleSelectedBold);
    on<ToggleSelectedItalic>(_onToggleSelectedItalic);
    on<ToggleSelectedUnderline>(_onToggleSelectedUnderline);
    on<ChangeSelectedFontFamily>(_onChangeSelectedFontFamily);
    on<ChangeSelectedTextColor>(_onChangeSelectedTextColor);
    on<UndoHeaderEdit>(_onUndoHeaderEdit);
    on<RedoHeaderEdit>(_onRedoHeaderEdit);
    on<SelectField>(_onSelectField);
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
        selectedFieldId: null,
        undoStack: const [],
        redoStack: const [],
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
        selectedFieldId: null,
        undoStack: const [],
        redoStack: const [],
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
        selectedFieldId: null,
        undoStack: const [],
        redoStack: const [],
      ));
    } catch (e) {
      emit(ResumeState.error('Failed to load sample: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateDocument(
      UpdateDocument event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      final previousSnapshot = HeaderEditingSnapshot.fromDocument(s.document);
      final nextSnapshot = HeaderEditingSnapshot.fromDocument(event.document);
      final trackHeaderHistory = previousSnapshot != nextSnapshot;

      emit(_buildLoadedState(
        s,
        document: event.document,
        undoStack: trackHeaderHistory
            ? [...s.undoStack, previousSnapshot]
            : s.undoStack,
        redoStack: trackHeaderHistory ? const [] : s.redoStack,
      ));
    });
  }

  Future<void> _onUpdateFullName(
      UpdateFullName event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      _emitUpdatedDocument(
        emit,
        s,
        s.document.copyWith(fullName: event.value),
      );
    });
  }

  Future<void> _onUpdateJobPosition(
      UpdateJobPosition event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      _emitUpdatedDocument(
        emit,
        s,
        s.document.copyWith(jobPosition: event.value),
      );
    });
  }

  Future<void> _onUpdateCareerGoals(
      UpdateCareerGoals event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      _emitUpdatedDocument(
        emit,
        s,
        s.document.copyWith(careerGoals: event.value),
      );
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
        selectedFieldId: 'photoPath',
      ));
    });
  }

  Future<void> _onToggleSelectedBold(
      ToggleSelectedBold event, Emitter<ResumeState> emit) async {
    _updateSelectedHeaderStyle(
      emit,
      (style) => style.copyWith(isBold: !style.isBold),
    );
  }

  Future<void> _onToggleSelectedItalic(
      ToggleSelectedItalic event, Emitter<ResumeState> emit) async {
    _updateSelectedHeaderStyle(
      emit,
      (style) => style.copyWith(isItalic: !style.isItalic),
    );
  }

  Future<void> _onToggleSelectedUnderline(
      ToggleSelectedUnderline event, Emitter<ResumeState> emit) async {
    _updateSelectedHeaderStyle(
      emit,
      (style) => style.copyWith(isUnderline: !style.isUnderline),
    );
  }

  Future<void> _onChangeSelectedFontFamily(
      ChangeSelectedFontFamily event, Emitter<ResumeState> emit) async {
    _updateSelectedHeaderStyle(
      emit,
      (style) => style.copyWith(fontFamily: event.fontFamily),
    );
  }

  Future<void> _onChangeSelectedTextColor(
      ChangeSelectedTextColor event, Emitter<ResumeState> emit) async {
    _updateSelectedHeaderStyle(
      emit,
      (style) => style.copyWith(textColorValue: event.textColorValue),
    );
  }

  Future<void> _onUndoHeaderEdit(
      UndoHeaderEdit event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      if (s.undoStack.isEmpty) return;

      final previous = s.undoStack.last;
      final current = HeaderEditingSnapshot.fromDocument(s.document);

      emit(_buildLoadedState(
        s,
        document: previous.applyToDocument(s.document),
        undoStack: s.undoStack.sublist(0, s.undoStack.length - 1),
        redoStack: [...s.redoStack, current],
      ));
    });
  }

  Future<void> _onRedoHeaderEdit(
      RedoHeaderEdit event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      if (s.redoStack.isEmpty) return;

      final next = s.redoStack.last;
      final current = HeaderEditingSnapshot.fromDocument(s.document);

      emit(_buildLoadedState(
        s,
        document: next.applyToDocument(s.document),
        undoStack: [...s.undoStack, current],
        redoStack: s.redoStack.sublist(0, s.redoStack.length - 1),
      ));
    });
  }

  Future<void> _onSelectField(
      SelectField event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        selectedFieldId: event.fieldId,
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
        undoStack: loaded.undoStack,
        redoStack: loaded.redoStack,
        template: loaded.template,
      ));
      emit(ResumeState.loaded(
        document: loaded.document,
        selectedFieldId: loaded.selectedFieldId,
        undoStack: loaded.undoStack,
        redoStack: loaded.redoStack,
        template: loaded.template,
      ));
    } catch (e) {
      emit(ResumeState.error('Failed to save resume: ${e.toString()}'));
    }
  }

  void _updateSelectedHeaderStyle(
    Emitter<ResumeState> emit,
    ResumeTextStyleSpec Function(ResumeTextStyleSpec) update,
  ) {
    state.mapOrNull(loaded: (s) {
      final selectedField = EditableHeaderFieldX.fromFieldId(s.selectedFieldId);
      if (selectedField == null) return;

      final currentStyle = s.document.styleForField(selectedField);
      final updatedDocument = s.document.copyWithHeaderTextStyle(
        selectedField,
        update(currentStyle),
      );

      _emitUpdatedDocument(emit, s, updatedDocument);
    });
  }

  void _emitUpdatedDocument(
    Emitter<ResumeState> emit,
    ResumeState state,
    ResumeDocument updatedDocument,
  ) {
    final s = state.mapOrNull(loaded: (loaded) => loaded);
    if (s == null) return;

    emit(_buildLoadedState(
      s,
      document: updatedDocument,
      undoStack: [
        ...s.undoStack,
        HeaderEditingSnapshot.fromDocument(s.document)
      ],
      redoStack: const [],
    ));
  }

  ResumeState _buildLoadedState(
    ResumeState state, {
    ResumeDocument? document,
    String? selectedFieldId,
    List<HeaderEditingSnapshot>? undoStack,
    List<HeaderEditingSnapshot>? redoStack,
  }) {
    final s = state.mapOrNull(loaded: (loaded) => loaded);
    if (s == null) return state;

    return ResumeState.loaded(
      document: document ?? s.document,
      selectedFieldId: selectedFieldId ?? s.selectedFieldId,
      undoStack: undoStack ?? s.undoStack,
      redoStack: redoStack ?? s.redoStack,
      template: s.template,
    );
  }
}
