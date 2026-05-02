import 'package:flutter/material.dart';
import '../models/resume_template_model.dart';
import '../models/resume_document.dart';

class ResumeProvider extends ChangeNotifier {
  List<ResumeTemplateModel> _templates = [];
  ResumeTemplateModel? _selectedTemplate;
  ResumeDocument _document = ResumeDocument.blank();
  String? _selectedFieldId;

  // Undo/redo stacks (stores snapshots of field values)
  final List<Map<String, String>> _undoStack = [];
  final List<Map<String, String>> _redoStack = [];

  List<ResumeTemplateModel> get templates => _templates;
  ResumeTemplateModel? get selectedTemplate => _selectedTemplate;
  ResumeDocument get document => _document;
  String? get selectedFieldId => _selectedFieldId;

  ResumeProvider() {
    _templates = ResumeTemplatesRegistry.all;
  }

  void selectTemplate(ResumeTemplateModel template) {
    _selectedTemplate = template;
    _document = ResumeDocument.blank();
    notifyListeners();
  }

  void toggleFavorite(String templateId) {
    final t = _templates.firstWhere((t) => t.id == templateId);
    t.isFavorite = !t.isFavorite;
    notifyListeners();
  }

  void useTemplate() {
    // Keep selected template, document stays blank for editing
    notifyListeners();
  }

  void selectField(String? id) {
    _selectedFieldId = id;
    notifyListeners();
  }

  // ── Document field updates ─────────────────────────────────────────────────
  void updateFullName(String v) { _document.fullName = v; notifyListeners(); }
  void updateJobPosition(String v) { _document.jobPosition = v; notifyListeners(); }
  void updateCareerGoals(String v) { _document.careerGoals = v; notifyListeners(); }
  void updateEmail(String v) { _document.email = v; notifyListeners(); }
  void updatePhone(String v) { _document.phone = v; notifyListeners(); }
  void updateAddress(String v) { _document.address = v; notifyListeners(); }
  void updateBirthday(String v) { _document.birthday = v; notifyListeners(); }
  void updateWebsite(String v) { _document.website = v; notifyListeners(); }
  void updatePhoto(String path) { _document.photoPath = path; notifyListeners(); }

  // Work experience
  void addWorkExperience() {
    _document.workExperience.add(WorkExperienceEntry());
    notifyListeners();
  }
  void removeWorkExperience(int i) {
    if (_document.workExperience.length > 1) {
      _document.workExperience.removeAt(i);
      notifyListeners();
    }
  }
  void updateWorkExperience(int i, WorkExperienceEntry entry) {
    _document.workExperience[i] = entry;
    notifyListeners();
  }

  // Education
  void addEducation() {
    _document.education.add(EducationEntry());
    notifyListeners();
  }
  void removeEducation(int i) {
    if (_document.education.length > 1) {
      _document.education.removeAt(i);
      notifyListeners();
    }
  }
  void updateEducation(int i, EducationEntry entry) {
    _document.education[i] = entry;
    notifyListeners();
  }

  // Skills
  void addSkill() {
    _document.skills.add(SkillEntry());
    notifyListeners();
  }
  void removeSkill(int i) {
    if (_document.skills.length > 1) {
      _document.skills.removeAt(i);
      notifyListeners();
    }
  }
  void updateSkillName(int i, String name) {
    _document.skills[i].name = name;
    notifyListeners();
  }
  void updateSkillRating(int i, int rating) {
    _document.skills[i].rating = rating;
    notifyListeners();
  }
  void moveSkillUp(int i) {
    if (i > 0) {
      final s = _document.skills.removeAt(i);
      _document.skills.insert(i - 1, s);
      notifyListeners();
    }
  }
  void moveSkillDown(int i) {
    if (i < _document.skills.length - 1) {
      final s = _document.skills.removeAt(i);
      _document.skills.insert(i + 1, s);
      notifyListeners();
    }
  }

  // Hobbies
  void addHobby() { _document.hobbies.add('Hobby name'); notifyListeners(); }
  void updateHobby(int i, String v) { _document.hobbies[i] = v; notifyListeners(); }
  void removeHobby(int i) {
    if (_document.hobbies.length > 1) {
      _document.hobbies.removeAt(i);
      notifyListeners();
    }
  }

  // Awards
  void addAward() { _document.awards.add(AwardEntry()); notifyListeners(); }
  void updateAward(int i, AwardEntry e) { _document.awards[i] = e; notifyListeners(); }
  void removeAward(int i) {
    if (_document.awards.length > 1) { _document.awards.removeAt(i); notifyListeners(); }
  }

  // Certifications
  void addCert() { _document.certifications.add(CertEntry()); notifyListeners(); }
  void updateCert(int i, CertEntry e) { _document.certifications[i] = e; notifyListeners(); }
  void removeCert(int i) {
    if (_document.certifications.length > 1) { _document.certifications.removeAt(i); notifyListeners(); }
  }

  // References
  void updateReference(int i, String v) { _document.references[i] = v; notifyListeners(); }
  void addReference() { _document.references.add('Reference information'); notifyListeners(); }
  void removeReference(int i) {
    if (_document.references.length > 1) { _document.references.removeAt(i); notifyListeners(); }
  }
}
