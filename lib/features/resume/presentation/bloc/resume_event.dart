import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../profile/domain/entities/resume_profile.dart';
import '../../domain/entities/resume_document.dart';
import '../../domain/entities/resume_template.dart';

part 'resume_event.freezed.dart';

@freezed
class ResumeEvent with _$ResumeEvent {
  const factory ResumeEvent.loadResume(String resumeId) = LoadResume;
  const factory ResumeEvent.createResume(
    ResumeTemplate template, {
    ResumeProfile? prefillProfile,
  }) = CreateResume;

  /// Replace the entire document (used by canvas on any field change)
  const factory ResumeEvent.updateDocument(ResumeDocument document) =
      UpdateDocument;
  const factory ResumeEvent.updateFullName(String value) = UpdateFullName;
  const factory ResumeEvent.updateJobPosition(String value) = UpdateJobPosition;
  const factory ResumeEvent.updateCareerGoals(String value) = UpdateCareerGoals;
  const factory ResumeEvent.updateEmail(String value) = UpdateEmail;
  const factory ResumeEvent.updatePhone(String value) = UpdatePhone;
  const factory ResumeEvent.updateAddress(String value) = UpdateAddress;
  const factory ResumeEvent.updateBirthday(String value) = UpdateBirthday;
  const factory ResumeEvent.updateWebsite(String value) = UpdateWebsite;
  const factory ResumeEvent.updatePhoto(String path) = UpdatePhoto;
  const factory ResumeEvent.toggleSelectedBold() = ToggleSelectedBold;
  const factory ResumeEvent.toggleSelectedItalic() = ToggleSelectedItalic;
  const factory ResumeEvent.toggleSelectedUnderline() = ToggleSelectedUnderline;
  const factory ResumeEvent.changeSelectedFontFamily(String fontFamily) =
      ChangeSelectedFontFamily;
  const factory ResumeEvent.changeSelectedTextColor(int textColorValue) =
      ChangeSelectedTextColor;
  const factory ResumeEvent.undoHeaderEdit() = UndoHeaderEdit;
  const factory ResumeEvent.redoHeaderEdit() = RedoHeaderEdit;
  const factory ResumeEvent.selectField(String? fieldId) = SelectField;
  const factory ResumeEvent.saveResume() = SaveResume;
  const factory ResumeEvent.loadSample() = LoadSample;
}
