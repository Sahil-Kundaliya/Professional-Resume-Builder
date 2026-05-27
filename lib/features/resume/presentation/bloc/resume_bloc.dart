import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/mappers/profile_to_resume_prefill_mapper.dart';
import '../../domain/entities/resume_document.dart';
import '../../domain/entities/template_field_configuration.dart';
import '../../domain/repositories/resume_repository.dart';
import '../constants/resume_form_messages.dart';
import '../widgets/resume_form_validators.dart';
import 'resume_event.dart';
import 'resume_state.dart';

class _ValidationResult {
  final Map<String, String> fieldErrors;
  final Set<String> missingRequiredFields;

  const _ValidationResult({
    required this.fieldErrors,
    required this.missingRequiredFields,
  });

  bool get canPreview => fieldErrors.isEmpty && missingRequiredFields.isEmpty;
}

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
    on<ValidateForPreview>(_onValidateForPreview);
    on<ClearFieldError>(_onClearFieldError);
    on<ConsumeFeedback>(_onConsumeFeedback);
    on<ConsumePreviewRequest>(_onConsumePreviewRequest);
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
      emit(_buildLoadedState(
        const ResumeState.loaded(
          document: ResumeDocument(
            id: '',
            fullName: '',
            jobPosition: '',
            careerGoals: '',
            email: '',
            phone: '',
            address: '',
            birthday: '',
            website: '',
            photoPath: '',
            workExperience: <WorkExperienceEntry>[],
            education: <EducationEntry>[],
            references: <String>[],
            hobbies: <String>[],
            skills: <SkillEntry>[],
            awards: <AwardEntry>[],
            certifications: <CertEntry>[],
          ),
        ),
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
      emit(_buildLoadedState(
        ResumeState.loaded(document: doc),
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
      emit(_buildLoadedState(
        ResumeState.loaded(document: doc),
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
        changedFieldKey: TemplateFieldKeys.fullName,
      ));
    });
  }

  Future<void> _onUpdateJobPosition(
      UpdateJobPosition event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(jobPosition: event.value),
        changedFieldKey: TemplateFieldKeys.jobPosition,
      ));
    });
  }

  Future<void> _onUpdateCareerGoals(
      UpdateCareerGoals event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(careerGoals: event.value),
        changedFieldKey: TemplateFieldKeys.summary,
      ));
    });
  }

  Future<void> _onUpdateEmail(
      UpdateEmail event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(email: event.value),
        changedFieldKey: TemplateFieldKeys.email,
      ));
    });
  }

  Future<void> _onUpdatePhone(
      UpdatePhone event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(phone: event.value),
        changedFieldKey: TemplateFieldKeys.phone,
      ));
    });
  }

  Future<void> _onUpdateAddress(
      UpdateAddress event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(address: event.value),
        changedFieldKey: TemplateFieldKeys.address,
      ));
    });
  }

  Future<void> _onUpdateBirthday(
      UpdateBirthday event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(birthday: event.value),
        changedFieldKey: TemplateFieldKeys.birthDate,
      ));
    });
  }

  Future<void> _onUpdateWebsite(
      UpdateWebsite event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(website: event.value),
        changedFieldKey: TemplateFieldKeys.website,
      ));
    });
  }

  Future<void> _onUpdatePhoto(
      UpdatePhoto event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(photoPath: event.path),
        changedFieldKey: TemplateFieldKeys.photo,
      ));
    });
  }

  Future<void> _onUpdateWorkExperience(
      UpdateWorkExperience event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(workExperience: event.value),
        changedFieldKey: TemplateFieldKeys.workExperience,
      ));
    });
  }

  Future<void> _onUpdateEducation(
      UpdateEducation event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(education: event.value),
        changedFieldKey: TemplateFieldKeys.education,
      ));
    });
  }

  Future<void> _onUpdateSkills(
      UpdateSkills event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(skills: event.value),
        changedFieldKey: TemplateFieldKeys.skills,
      ));
    });
  }

  Future<void> _onUpdateHobbies(
      UpdateHobbies event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(hobbies: event.value),
        changedFieldKey: TemplateFieldKeys.hobbies,
      ));
    });
  }

  Future<void> _onUpdateAwards(
      UpdateAwards event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(awards: event.value),
        changedFieldKey: TemplateFieldKeys.awards,
      ));
    });
  }

  Future<void> _onUpdateCertifications(
      UpdateCertifications event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(certifications: event.value),
        changedFieldKey: TemplateFieldKeys.certifications,
      ));
    });
  }

  Future<void> _onUpdateReferences(
      UpdateReferences event, Emitter<ResumeState> emit) async {
    state.mapOrNull(loaded: (s) {
      emit(_buildLoadedState(
        s,
        document: s.document.copyWith(references: event.value),
        changedFieldKey: TemplateFieldKeys.references,
      ));
    });
  }

  Future<void> _onValidateForPreview(
    ValidateForPreview event,
    Emitter<ResumeState> emit,
  ) async {
    state.mapOrNull(loaded: (s) {
      emit(s.copyWith(
        isPreviewValidationInProgress: true,
        previewRequested: false,
        feedbackMessage: null,
      ));

      final validatedState = _buildLoadedState(s).mapOrNull(loaded: (l) => l);
      if (validatedState == null) {
        return;
      }

      emit(validatedState.copyWith(
        isPreviewValidationInProgress: false,
        previewRequested: validatedState.canPreview,
        feedbackMessage: validatedState.canPreview
            ? null
            : _feedbackForValidation(
                missingRequiredFields: validatedState.missingRequiredFields,
                fieldErrors: validatedState.fieldErrors,
              ),
      ));
    });
  }

  Future<void> _onClearFieldError(
    ClearFieldError event,
    Emitter<ResumeState> emit,
  ) async {
    state.mapOrNull(loaded: (s) {
      final nextErrors = Map<String, String>.from(s.fieldErrors)
        ..remove(event.fieldKey);
      final nextMissing = Set<String>.from(s.missingRequiredFields)
        ..remove(event.fieldKey);
      emit(s.copyWith(
        fieldErrors: nextErrors,
        missingRequiredFields: nextMissing,
        canPreview: nextErrors.isEmpty && nextMissing.isEmpty,
        feedbackMessage: null,
        previewRequested: false,
      ));
    });
  }

  Future<void> _onConsumeFeedback(
    ConsumeFeedback event,
    Emitter<ResumeState> emit,
  ) async {
    state.mapOrNull(loaded: (s) {
      emit(s.copyWith(feedbackMessage: null));
    });
  }

  Future<void> _onConsumePreviewRequest(
    ConsumePreviewRequest event,
    Emitter<ResumeState> emit,
  ) async {
    state.mapOrNull(loaded: (s) {
      emit(s.copyWith(previewRequested: false));
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
        fieldErrors: loaded.fieldErrors,
        missingRequiredFields: loaded.missingRequiredFields,
        canPreview: loaded.canPreview,
        feedbackMessage: loaded.feedbackMessage,
        previewRequested: loaded.previewRequested,
        isPreviewValidationInProgress: loaded.isPreviewValidationInProgress,
      ));
      emit(_buildLoadedState(
        ResumeState.loaded(
          document: loaded.document,
          template: loaded.template,
          fieldErrors: loaded.fieldErrors,
          missingRequiredFields: loaded.missingRequiredFields,
          canPreview: loaded.canPreview,
          feedbackMessage: loaded.feedbackMessage,
          previewRequested: loaded.previewRequested,
          isPreviewValidationInProgress: loaded.isPreviewValidationInProgress,
        ),
      ));
    } catch (e) {
      emit(ResumeState.error('Failed to save resume: ${e.toString()}'));
    }
  }

  ResumeState _buildLoadedState(
    ResumeState state, {
    ResumeDocument? document,
    dynamic template,
    String? changedFieldKey,
  }) {
    final s = state.mapOrNull(loaded: (loaded) => loaded);
    if (s == null) return state;

    final nextDocument = document ?? s.document;
    final nextTemplate = template ?? s.template;
    final validation = _validate(
      document: nextDocument,
      template: nextTemplate,
    );

    final fieldErrors = Map<String, String>.from(validation.fieldErrors);
    final missingRequired = Set<String>.from(validation.missingRequiredFields);
    if (changedFieldKey != null) {
      // Keep UI feedback focused on current document state as user edits.
      if (!fieldErrors.containsKey(changedFieldKey)) {
        missingRequired.remove(changedFieldKey);
      }
    }

    return ResumeState.loaded(
      document: nextDocument,
      template: nextTemplate,
      fieldErrors: fieldErrors,
      missingRequiredFields: missingRequired,
      canPreview: validation.canPreview,
      feedbackMessage: s.feedbackMessage,
      previewRequested: false,
      isPreviewValidationInProgress: false,
    );
  }

  _ValidationResult _validate({
    required ResumeDocument document,
    required dynamic template,
  }) {
    final config = template?.fieldConfiguration as TemplateFieldConfiguration?;
    final requiredFields = (config ?? const TemplateFieldConfiguration())
        .sanitizedRequiredFields();

    final fieldErrors = <String, String>{};
    final missingRequired = <String>{};

    for (final key in requiredFields) {
      final value = _rawFieldValue(document, key);
      if (!_hasRequiredValue(key, value)) {
        missingRequired.add(key);
        fieldErrors[key] = '${_labelForField(key)} is required.';
      }
    }

    final emailError = ResumeFormValidators.optionalEmail(document.email);
    if (emailError != null) {
      fieldErrors[TemplateFieldKeys.email] = emailError;
    }

    final phoneError = ResumeFormValidators.optionalPhone(document.phone);
    if (phoneError != null) {
      fieldErrors[TemplateFieldKeys.phone] = phoneError;
    }

    return _ValidationResult(
      fieldErrors: fieldErrors,
      missingRequiredFields: missingRequired,
    );
  }

  dynamic _rawFieldValue(ResumeDocument document, String key) {
    switch (key) {
      case TemplateFieldKeys.fullName:
        return document.fullName;
      case TemplateFieldKeys.jobPosition:
        return document.jobPosition;
      case TemplateFieldKeys.summary:
        return document.careerGoals;
      case TemplateFieldKeys.birthDate:
        return document.birthday;
      case TemplateFieldKeys.email:
        return document.email;
      case TemplateFieldKeys.phone:
        return document.phone;
      case TemplateFieldKeys.address:
        return document.address;
      case TemplateFieldKeys.website:
        return document.website;
      case TemplateFieldKeys.photo:
        return document.photoPath;
      case TemplateFieldKeys.workExperience:
        return document.workExperience;
      case TemplateFieldKeys.education:
        return document.education;
      case TemplateFieldKeys.skills:
        return document.skills;
      case TemplateFieldKeys.hobbies:
        return document.hobbies;
      case TemplateFieldKeys.awards:
        return document.awards;
      case TemplateFieldKeys.certifications:
        return document.certifications;
      case TemplateFieldKeys.references:
        return document.references;
      default:
        return null;
    }
  }

  bool _hasRequiredValue(String key, dynamic value) {
    if (value == null) {
      return false;
    }

    if (value is String) {
      return ResumeFormValidators.hasMeaningfulValue(value);
    }

    if (value is List<WorkExperienceEntry>) {
      return ResumeFormValidators.sanitizeWorkExperienceItems(value).isNotEmpty;
    }

    if (value is List<EducationEntry>) {
      return ResumeFormValidators.sanitizeEducationItems(value).isNotEmpty;
    }

    if (value is List<SkillEntry>) {
      return ResumeFormValidators.sanitizeSkillItems(value).isNotEmpty;
    }

    if (value is List<AwardEntry>) {
      return ResumeFormValidators.sanitizeAwardItems(value).isNotEmpty;
    }

    if (value is List<CertEntry>) {
      return ResumeFormValidators.sanitizeCertificationItems(value).isNotEmpty;
    }

    if (value is List<String>) {
      return ResumeFormValidators.hasAnyMeaningfulText(value);
    }

    return false;
  }

  ResumeFormMessage _feedbackForValidation({
    required Set<String> missingRequiredFields,
    required Map<String, String> fieldErrors,
  }) {
    if (missingRequiredFields.isNotEmpty) {
      final labels =
          missingRequiredFields.map(_labelForField).toList(growable: false);
      return ResumeFormMessages.missingRequired(labels);
    }

    if (fieldErrors.isNotEmpty) {
      final issues = fieldErrors.values.toList(growable: false);
      return ResumeFormMessages.validationFailed(issues);
    }

    return ResumeFormMessages.unexpectedError();
  }

  String _labelForField(String key) {
    switch (key) {
      case TemplateFieldKeys.fullName:
        return 'Full name';
      case TemplateFieldKeys.jobPosition:
        return 'Job position';
      case TemplateFieldKeys.summary:
        return 'Summary';
      case TemplateFieldKeys.birthDate:
        return 'Birth date';
      case TemplateFieldKeys.email:
        return 'Email';
      case TemplateFieldKeys.phone:
        return 'Phone';
      case TemplateFieldKeys.address:
        return 'Address';
      case TemplateFieldKeys.website:
        return 'Portfolio';
      case TemplateFieldKeys.photo:
        return 'Profile image';
      case TemplateFieldKeys.workExperience:
        return 'Work experience';
      case TemplateFieldKeys.education:
        return 'Education';
      case TemplateFieldKeys.skills:
        return 'Skills';
      case TemplateFieldKeys.hobbies:
        return 'Hobbies';
      case TemplateFieldKeys.awards:
        return 'Awards';
      case TemplateFieldKeys.certifications:
        return 'Certifications';
      case TemplateFieldKeys.references:
        return 'References';
      default:
        return 'Field';
    }
  }
}
