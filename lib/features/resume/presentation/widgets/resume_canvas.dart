import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/resume_document.dart';
import '../../domain/entities/resume_template.dart';
import 'resume_editor_constraints.dart';
import 'formatting_toolbar.dart';
import 'resume_canvas_section_keys.dart';
import 'resume_canvas_selection_parser.dart';

class ResumeCanvasFieldIds {
  static const String fullName = 'fullName';
  static const String jobPosition = 'jobPosition';
  static const String careerGoals = 'careerGoals';
  static const String photoPath = 'photoPath';

  static bool supportsFormatting(String? fieldId) {
    return fieldId != null && fieldId != photoPath;
  }
}

/// Renders the resume as a visual document — used in both preview and editor.
/// When [isEditable] is true, each field becomes an inline text editor
/// with dashed selection border and move/delete controls.
class ResumeCanvas extends StatelessWidget {
  final ResumeDocument document;
  final ResumeTemplate? template;
  final bool isEditable;
  final String? selectedFieldId;
  final ValueChanged<String?>? onFieldSelected;

  /// Called whenever a field changes; provides an updated [ResumeDocument]
  final ValueChanged<ResumeDocument>? onDocumentChanged;

  /// Called when canvas actions need to show user feedback.
  final ValueChanged<String>? onActionFeedback;

  const ResumeCanvas({
    super.key,
    required this.document,
    required this.template,
    this.isEditable = false,
    this.selectedFieldId,
    this.onFieldSelected,
    this.onDocumentChanged,
    this.onActionFeedback,
  });

  Color get accent => template?.accentColor ?? const Color(0xFF444444);

  // ── Document mutation helpers ──────────────────────────────────────────────

  void _emit(ResumeDocument updated) => onDocumentChanged?.call(updated);

  void _updateWorkExp(
      int i, WorkExperienceEntry Function(WorkExperienceEntry) fn) {
    final list = List<WorkExperienceEntry>.from(document.workExperience);
    list[i] = fn(list[i]);
    _emit(document.copyWith(workExperience: list));
  }

  void _updateEducation(int i, EducationEntry Function(EducationEntry) fn) {
    final list = List<EducationEntry>.from(document.education);
    list[i] = fn(list[i]);
    _emit(document.copyWith(education: list));
  }

  void _updateSkill(int i, SkillEntry Function(SkillEntry) fn) {
    final list = List<SkillEntry>.from(document.skills);
    list[i] = fn(list[i]);
    _emit(document.copyWith(skills: list));
  }

  int _clampSkillRating(int value) {
    return value.clamp(
      resumeEditorMinSkillRating,
      resumeEditorMaxSkillRating,
    );
  }

  void _updateAward(int i, AwardEntry Function(AwardEntry) fn) {
    final list = List<AwardEntry>.from(document.awards);
    list[i] = fn(list[i]);
    _emit(document.copyWith(awards: list));
  }

  void _updateCert(int i, CertEntry Function(CertEntry) fn) {
    final list = List<CertEntry>.from(document.certifications);
    list[i] = fn(list[i]);
    _emit(document.copyWith(certifications: list));
  }

  void _notify(String message) {
    onActionFeedback?.call(message);
  }

  List<T>? _removeSelectedItemFromList<T>(List<T> source, int index) {
    if (index < 0 || index >= source.length) {
      return null;
    }
    if (source.length <= 1) {
      return null;
    }
    final updated = List<T>.from(source)..removeAt(index);
    return updated;
  }

  void _deleteSelectedField([String? fallbackFieldId]) {
    final target = ResumeCanvasSelectionParser.parse(
      selectedFieldId ?? fallbackFieldId,
    );

    if (target.fieldId == null) {
      _notify('Select an item to delete.');
      return;
    }

    if (target.isProtectedHeaderField) {
      _notify('This field is required and cannot be deleted.');
      return;
    }

    if (!target.isDeletableRepeatableItem || target.section == null) {
      _notify('Only repeatable section items can be deleted.');
      return;
    }

    final itemIndex = target.itemIndex!;
    switch (target.section!) {
      case ResumeCanvasSectionKey.workExperience:
        final updated = _removeSelectedItemFromList(
          document.workExperience,
          itemIndex,
        );
        if (updated == null) {
          _notify('At least one work experience item must remain.');
          return;
        }
        _emit(document.copyWith(workExperience: updated));
      case ResumeCanvasSectionKey.education:
        final updated = _removeSelectedItemFromList(
          document.education,
          itemIndex,
        );
        if (updated == null) {
          _notify('At least one education item must remain.');
          return;
        }
        _emit(document.copyWith(education: updated));
      case ResumeCanvasSectionKey.skills:
        final updated = _removeSelectedItemFromList(document.skills, itemIndex);
        if (updated == null) {
          _notify('At least one skill item must remain.');
          return;
        }
        _emit(document.copyWith(skills: updated));
      case ResumeCanvasSectionKey.hobbies:
        final updated = _removeSelectedItemFromList(document.hobbies, itemIndex);
        if (updated == null) {
          _notify('At least one hobby item must remain.');
          return;
        }
        _emit(document.copyWith(hobbies: updated));
      case ResumeCanvasSectionKey.awards:
        final updated = _removeSelectedItemFromList(document.awards, itemIndex);
        if (updated == null) {
          _notify('At least one award item must remain.');
          return;
        }
        _emit(document.copyWith(awards: updated));
      case ResumeCanvasSectionKey.certifications:
        final updated =
            _removeSelectedItemFromList(document.certifications, itemIndex);
        if (updated == null) {
          _notify('At least one certification item must remain.');
          return;
        }
        _emit(document.copyWith(certifications: updated));
      case ResumeCanvasSectionKey.references:
        final updated =
            _removeSelectedItemFromList(document.references, itemIndex);
        if (updated == null) {
          _notify('At least one reference item must remain.');
          return;
        }
        _emit(document.copyWith(references: updated));
      case ResumeCanvasSectionKey.profile:
        _notify('Profile fields cannot be deleted from this control.');
        return;
    }

    onFieldSelected?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    return _ResumeCanvasActions(
      onDeleteRequested: _deleteSelectedField,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column
                Expanded(
                  flex: 55,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWorkExperience(context),
                      const SizedBox(height: 14),
                      _buildEducation(context),
                      const SizedBox(height: 14),
                      _buildReferences(context),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Right sidebar
                Expanded(
                  flex: 45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfile(context),
                      const SizedBox(height: 14),
                      _buildHobbies(context),
                      const SizedBox(height: 14),
                      _buildSkills(context),
                      const SizedBox(height: 14),
                      _buildAwards(context),
                      const SizedBox(height: 14),
                      _buildCertifications(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final fullNameStyle = _resolveFieldStyle(
      ResumeCanvasFieldIds.fullName,
      GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
    final jobPositionStyle = _resolveFieldStyle(
      ResumeCanvasFieldIds.jobPosition,
      GoogleFonts.inter(
        fontSize: 12,
        color: Colors.grey.shade600,
      ),
    );
    final careerGoalsStyle = _resolveFieldStyle(
      ResumeCanvasFieldIds.careerGoals,
      GoogleFonts.inter(
        fontSize: 10,
        color: Colors.black87,
        height: 1.5,
      ),
    );

    return Container(
      color: template?.headerBgColor ?? Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo
          _EditablePhoto(
            isEditable: isEditable,
            photoPath: document.photoPath,
            isSelected: selectedFieldId == ResumeCanvasFieldIds.photoPath,
            onSelected: onFieldSelected,
            onChanged: (value) => _emit(document.copyWith(photoPath: value)),
          ),
          const SizedBox(width: 14),
          // Name / position / summary
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _EditableField(
                  fieldId: ResumeCanvasFieldIds.fullName,
                  text: document.fullName,
                  isEditable: isEditable,
                  isSelected: selectedFieldId == ResumeCanvasFieldIds.fullName,
                  onSelected: onFieldSelected,
                  style: fullNameStyle,
                  hintText: 'Full name',
                  onChanged: (v) => _emit(document.copyWith(fullName: v)),
                  accentColor: accent,
                ),
                const SizedBox(height: 4),
                _EditableField(
                  fieldId: ResumeCanvasFieldIds.jobPosition,
                  text: document.jobPosition,
                  isEditable: isEditable,
                  isSelected:
                      selectedFieldId == ResumeCanvasFieldIds.jobPosition,
                  onSelected: onFieldSelected,
                  style: jobPositionStyle,
                  hintText: 'Job position',
                  onChanged: (v) => _emit(document.copyWith(jobPosition: v)),
                  accentColor: accent,
                ),
                const SizedBox(height: 6),
                _EditableField(
                  fieldId: ResumeCanvasFieldIds.careerGoals,
                  text: document.careerGoals,
                  isEditable: isEditable,
                  isSelected:
                      selectedFieldId == ResumeCanvasFieldIds.careerGoals,
                  onSelected: onFieldSelected,
                  style: careerGoalsStyle,
                  hintText: 'Career goals: short-term, long-term',
                  maxLines: 4,
                  onChanged: (v) => _emit(document.copyWith(careerGoals: v)),
                  accentColor: accent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Work Experience ────────────────────────────────────────────────────────
  Widget _buildWorkExperience(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Work experience'),
        const SizedBox(height: 6),
        ...document.workExperience.asMap().entries.map((entry) {
          final i = entry.key;
          final exp = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date
                SizedBox(
                  width: 70,
                  child: _EditableField(
                    fieldId: 'exp_date_$i',
                    text: exp.dateRange,
                    isEditable: isEditable,
                    isSelected: selectedFieldId == 'exp_date_$i',
                    onSelected: onFieldSelected,
                    style: _resolveFieldStyle(
                      'exp_date_$i',
                      GoogleFonts.inter(
                          fontSize: 8, color: Colors.grey.shade600),
                    ),
                    hintText: 'From • To',
                    onChanged: (v) =>
                        _updateWorkExp(i, (e) => e.copyWith(dateRange: v)),
                    accentColor: accent,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _EditableField(
                        fieldId: 'exp_pos_$i',
                        text: exp.position,
                        isEditable: isEditable,
                        isSelected: selectedFieldId == 'exp_pos_$i',
                        onSelected: onFieldSelected,
                        style: _resolveFieldStyle(
                          'exp_pos_$i',
                          GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        hintText: 'Position',
                        onChanged: (v) =>
                            _updateWorkExp(i, (e) => e.copyWith(position: v)),
                        accentColor: accent,
                      ),
                      _EditableField(
                        fieldId: 'exp_company_$i',
                        text: exp.companyName,
                        isEditable: isEditable,
                        isSelected: selectedFieldId == 'exp_company_$i',
                        onSelected: onFieldSelected,
                        style: _resolveFieldStyle(
                          'exp_company_$i',
                          GoogleFonts.inter(
                            fontSize: 9,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        hintText: 'Company name',
                        onChanged: (v) => _updateWorkExp(
                            i, (e) => e.copyWith(companyName: v)),
                        accentColor: accent,
                      ),
                      _EditableField(
                        fieldId: 'exp_desc_$i',
                        text: exp.description,
                        isEditable: isEditable,
                        isSelected: selectedFieldId == 'exp_desc_$i',
                        onSelected: onFieldSelected,
                        style: _resolveFieldStyle(
                          'exp_desc_$i',
                          GoogleFonts.inter(fontSize: 9, height: 1.6),
                        ),
                        hintText: 'Experience description',
                        maxLines: 8,
                        onChanged: (v) => _updateWorkExp(
                            i, (e) => e.copyWith(description: v)),
                        accentColor: accent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ── Education ─────────────────────────────────────────────────────────────
  Widget _buildEducation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Education'),
        const SizedBox(height: 6),
        ...document.education.asMap().entries.map((entry) {
          final i = entry.key;
          final edu = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _EditableField(
                        fieldId: 'edu_date_$i',
                        text: edu.dateRange,
                        isEditable: isEditable,
                        isSelected: selectedFieldId == 'edu_date_$i',
                        onSelected: onFieldSelected,
                        style: _resolveFieldStyle(
                          'edu_date_$i',
                          GoogleFonts.inter(
                              fontSize: 8, color: Colors.grey.shade600),
                        ),
                        hintText: 'From • To',
                        onChanged: (v) => _updateEducation(
                            i, (e) => e.copyWith(dateRange: v)),
                        accentColor: accent,
                      ),
                      _EditableField(
                        fieldId: 'edu_course_$i',
                        text: edu.coursesSubjects,
                        isEditable: isEditable,
                        isSelected: selectedFieldId == 'edu_course_$i',
                        onSelected: onFieldSelected,
                        style: _resolveFieldStyle(
                          'edu_course_$i',
                          GoogleFonts.inter(
                              fontSize: 8, color: Colors.grey.shade500),
                        ),
                        hintText: 'Courses/subjects',
                        onChanged: (v) => _updateEducation(
                            i, (e) => e.copyWith(coursesSubjects: v)),
                        accentColor: accent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _EditableField(
                        fieldId: 'edu_school_$i',
                        text: edu.schoolName,
                        isEditable: isEditable,
                        isSelected: selectedFieldId == 'edu_school_$i',
                        onSelected: onFieldSelected,
                        style: _resolveFieldStyle(
                          'edu_school_$i',
                          GoogleFonts.inter(
                              fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                        hintText: 'School name',
                        onChanged: (v) => _updateEducation(
                            i, (e) => e.copyWith(schoolName: v)),
                        accentColor: accent,
                      ),
                      _EditableField(
                        fieldId: 'edu_desc_$i',
                        text: edu.description,
                        isEditable: isEditable,
                        isSelected: selectedFieldId == 'edu_desc_$i',
                        onSelected: onFieldSelected,
                        style: _resolveFieldStyle(
                          'edu_desc_$i',
                          GoogleFonts.inter(fontSize: 9, height: 1.5),
                        ),
                        hintText: 'Education description',
                        maxLines: 4,
                        onChanged: (v) => _updateEducation(
                            i, (e) => e.copyWith(description: v)),
                        accentColor: accent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ── References ────────────────────────────────────────────────────────────
  Widget _buildReferences(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('References'),
        const SizedBox(height: 6),
        ...document.references.asMap().entries.map((entry) {
          final i = entry.key;
          return _EditableField(
            fieldId: 'ref_$i',
            text: entry.value,
            isEditable: isEditable,
            isSelected: selectedFieldId == 'ref_$i',
            onSelected: onFieldSelected,
            style: _resolveFieldStyle(
              'ref_$i',
              GoogleFonts.inter(fontSize: 9, height: 1.6),
            ),
            hintText:
                'Reference information including name, title and contact information',
            maxLines: 3,
            onChanged: (v) {
              final list = List<String>.from(document.references);
              list[i] = v;
              _emit(document.copyWith(references: list));
            },
            accentColor: accent,
          );
        }),
      ],
    );
  }

  // ── Profile (sidebar) ─────────────────────────────────────────────────────
  Widget _buildProfile(BuildContext context) {
    final fields = [
      (
        'profile_email',
        document.email,
        Icons.email_outlined,
        (String v) => _emit(document.copyWith(email: v))
      ),
      (
        'profile_phone',
        document.phone,
        Icons.phone_outlined,
        (String v) => _emit(document.copyWith(phone: v))
      ),
      (
        'profile_address',
        document.address,
        Icons.location_on_outlined,
        (String v) => _emit(document.copyWith(address: v))
      ),
      (
        'profile_birthday',
        document.birthday,
        Icons.cake_outlined,
        (String v) => _emit(document.copyWith(birthday: v))
      ),
      (
        'profile_website',
        document.website,
        Icons.link_outlined,
        (String v) => _emit(document.copyWith(website: v))
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Profile'),
        const SizedBox(height: 6),
        ...fields.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(f.$3, size: 11, color: accent),
                  const SizedBox(width: 5),
                  Expanded(
                    child: _EditableField(
                      fieldId: f.$1,
                      text: f.$2,
                      isEditable: isEditable,
                      isSelected: selectedFieldId == f.$1,
                      onSelected: onFieldSelected,
                      style: _resolveFieldStyle(
                        f.$1,
                        GoogleFonts.inter(fontSize: 9),
                      ),
                      hintText: 'Information',
                      onChanged: f.$4,
                      accentColor: accent,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  // ── Hobbies ───────────────────────────────────────────────────────────────
  Widget _buildHobbies(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Hobbies'),
        const SizedBox(height: 6),
        ...document.hobbies.asMap().entries.map((entry) {
          final i = entry.key;
          return _EditableField(
            fieldId: 'hobby_$i',
            text: entry.value,
            isEditable: isEditable,
            isSelected: selectedFieldId == 'hobby_$i',
            onSelected: onFieldSelected,
            style: _resolveFieldStyle(
              'hobby_$i',
              GoogleFonts.inter(fontSize: 9, height: 1.8),
            ),
            hintText: 'Hobby name',
            onChanged: (v) {
              final list = List<String>.from(document.hobbies);
              list[i] = v;
              _emit(document.copyWith(hobbies: list));
            },
            accentColor: accent,
          );
        }),
      ],
    );
  }

  // ── Skills ────────────────────────────────────────────────────────────────
  Widget _buildSkills(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Skills'),
        const SizedBox(height: 6),
        ...document.skills.asMap().entries.map((entry) {
          final i = entry.key;
          final skill = entry.value;
          final fieldId = 'skill_$i';
          final isSelected = selectedFieldId == fieldId;
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _SelectedWrapper(
              fieldId: fieldId,
              isEditable: isEditable,
              isSelected: isSelected,
              onSelected: onFieldSelected,
              accentColor: accent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Skill name editable
                  if (isEditable && isSelected)
                    Row(
                      children: [
                        _SmallIconBtn(
                          icon: Icons.remove,
                          color: const Color(0xFF00A86B),
                          onTap: () => _updateSkill(
                            i,
                            (s) => s.copyWith(
                              rating: _clampSkillRating(s.rating - 1),
                            ),
                          ),
                        ),
                        _SmallIconBtn(
                          icon: Icons.add,
                          color: const Color(0xFF00A86B),
                          onTap: () => _updateSkill(
                            i,
                            (s) => s.copyWith(
                              rating: _clampSkillRating(s.rating + 1),
                            ),
                          ),
                        ),
                        _SmallIconBtn(
                          icon: Icons.delete_outline,
                          color: Colors.red,
                          onTap: () => _deleteSelectedField(fieldId),
                        ),
                      ],
                    ),
                  TextFormField(
                    initialValue: skill.name,
                    style: _resolveFieldStyle(
                      fieldId,
                      GoogleFonts.inter(fontSize: 9),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Skill name',
                      hintStyle: _resolveFieldStyle(
                        fieldId,
                        GoogleFonts.inter(
                          fontSize: 9,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 2),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (v) =>
                        _updateSkill(i, (s) => s.copyWith(name: v)),
                    readOnly: !isEditable,
                  ),
                  // Star rating dots
                  Row(
                    children: List.generate(5, (starIndex) {
                      final filled = starIndex < skill.rating;
                      return GestureDetector(
                        onTap: isEditable
                            ? () => _updateSkill(
                                  i,
                                  (s) => s.copyWith(rating: starIndex + 1),
                                )
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Icon(
                            filled ? Icons.star : Icons.star_border,
                            size: 12,
                            color: filled ? accent : Colors.grey.shade300,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Awards ────────────────────────────────────────────────────────────────
  Widget _buildAwards(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Awards'),
        const SizedBox(height: 6),
        ...document.awards.asMap().entries.map((entry) {
          final i = entry.key;
          final award = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _EditableField(
                  fieldId: 'award_year_$i',
                  text: award.year,
                  isEditable: isEditable,
                  isSelected: selectedFieldId == 'award_year_$i',
                  onSelected: onFieldSelected,
                  style: _resolveFieldStyle(
                    'award_year_$i',
                    GoogleFonts.inter(fontSize: 8, color: Colors.grey.shade500),
                  ),
                  hintText: 'Time',
                  onChanged: (v) => _updateAward(i, (a) => a.copyWith(year: v)),
                  accentColor: accent,
                ),
                _EditableField(
                  fieldId: 'award_name_$i',
                  text: award.name,
                  isEditable: isEditable,
                  isSelected: selectedFieldId == 'award_name_$i',
                  onSelected: onFieldSelected,
                  style: _resolveFieldStyle(
                    'award_name_$i',
                    GoogleFonts.inter(fontSize: 9),
                  ),
                  hintText: 'Award name',
                  onChanged: (v) => _updateAward(i, (a) => a.copyWith(name: v)),
                  accentColor: accent,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ── Certifications ────────────────────────────────────────────────────────
  Widget _buildCertifications(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Certifications'),
        const SizedBox(height: 6),
        ...document.certifications.asMap().entries.map((entry) {
          final i = entry.key;
          final cert = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _EditableField(
                  fieldId: 'cert_year_$i',
                  text: cert.year,
                  isEditable: isEditable,
                  isSelected: selectedFieldId == 'cert_year_$i',
                  onSelected: onFieldSelected,
                  style: _resolveFieldStyle(
                    'cert_year_$i',
                    GoogleFonts.inter(fontSize: 8, color: Colors.grey.shade500),
                  ),
                  hintText: 'Time',
                  onChanged: (v) => _updateCert(i, (c) => c.copyWith(year: v)),
                  accentColor: accent,
                ),
                _EditableField(
                  fieldId: 'cert_name_$i',
                  text: cert.name,
                  isEditable: isEditable,
                  isSelected: selectedFieldId == 'cert_name_$i',
                  onSelected: onFieldSelected,
                  style: _resolveFieldStyle(
                    'cert_name_$i',
                    GoogleFonts.inter(fontSize: 9),
                  ),
                  hintText: 'Certification name',
                  onChanged: (v) => _updateCert(i, (c) => c.copyWith(name: v)),
                  accentColor: accent,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: accent,
          ),
        ),
        Container(
          height: 1,
          color: accent.withOpacity(0.4),
          margin: const EdgeInsets.only(top: 2, bottom: 4),
        ),
      ],
    );
  }

  TextStyle _resolveFieldStyle(
    String fieldId,
    TextStyle baseStyle,
  ) {
    final style = document.styleForFieldId(fieldId);
    final styledBase = baseStyle.copyWith(
      fontSize: style.fontSize ?? baseStyle.fontSize,
      fontWeight: style.isBold ? FontWeight.w700 : baseStyle.fontWeight,
      fontStyle: style.isItalic ? FontStyle.italic : FontStyle.normal,
      decoration:
          style.isUnderline ? TextDecoration.underline : TextDecoration.none,
      color: Color(style.textColorValue),
    );

    return resolveResumeToolbarTextStyle(style.fontFamily, styledBase);
  }
}

class _ResumeCanvasActions extends InheritedWidget {
  const _ResumeCanvasActions({
    required this.onDeleteRequested,
    required super.child,
  });

  final ValueChanged<String?> onDeleteRequested;

  static _ResumeCanvasActions? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ResumeCanvasActions>();
  }

  @override
  bool updateShouldNotify(covariant _ResumeCanvasActions oldWidget) {
    return onDeleteRequested != oldWidget.onDeleteRequested;
  }
}

// ── Editable photo widget ──────────────────────────────────────────────────
class _EditablePhoto extends StatelessWidget {
  final bool isEditable;
  final String photoPath;
  final bool isSelected;
  final ValueChanged<String?>? onSelected;
  final ValueChanged<String>? onChanged;

  const _EditablePhoto({
    required this.isEditable,
    required this.photoPath,
    required this.isSelected,
    required this.onSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !isEditable
          ? null
          : () async {
              onSelected?.call(ResumeCanvasFieldIds.photoPath);
              final picker = ImagePicker();
              final file = await picker.pickImage(source: ImageSource.gallery);
              if (file == null) {
                return;
              }
              final bytes = await file.readAsBytes();
              onChanged?.call('base64:${base64Encode(bytes)}');
            },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
          border: isSelected
              ? Border.all(color: const Color(0xFF00A86B), width: 1.5)
              : null,
        ),
        child: _photoWidget(),
      ),
    );
  }

  Widget _photoWidget() {
    if (photoPath.isEmpty) {
      return Icon(Icons.person, size: 36, color: Colors.grey.shade500);
    }

    if (photoPath.startsWith('base64:')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.memory(
          base64Decode(photoPath.substring('base64:'.length)),
          fit: BoxFit.cover,
        ),
      );
    }

    if (_isLocalImagePath(photoPath)) {
      final path = photoPath.startsWith('file://')
          ? Uri.parse(photoPath).toFilePath()
          : photoPath;
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Icon(Icons.person, size: 36, color: Colors.grey.shade500);
          },
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        photoPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Icon(Icons.person, size: 36, color: Colors.grey.shade500);
        },
      ),
    );
  }

  bool _isLocalImagePath(String value) {
    return value.startsWith('/') ||
        value.startsWith('file://') ||
        RegExp(r'^[a-zA-Z]:\\').hasMatch(value);
  }
}

// ── Selectable wrapper (for skills with action buttons) ───────────────────
class _SelectedWrapper extends StatelessWidget {
  final String fieldId;
  final bool isEditable;
  final bool isSelected;
  final ValueChanged<String?>? onSelected;
  final Color accentColor;
  final Widget child;

  const _SelectedWrapper({
    required this.fieldId,
    required this.isEditable,
    required this.isSelected,
    required this.onSelected,
    required this.accentColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!isEditable) return child;
    return GestureDetector(
      onTap: () => onSelected?.call(isSelected ? null : fieldId),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(
                  color: accentColor,
                  width: 1.5,
                  strokeAlign: BorderSide.strokeAlignOutside,
                )
              : null,
        ),
        child: child,
      ),
    );
  }
}

class _SmallIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SmallIconBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 4, bottom: 4),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Icon(icon, size: 10, color: Colors.white),
      ),
    );
  }
}

// ── Core editable field widget ─────────────────────────────────────────────
class _EditableField extends StatelessWidget {
  final String fieldId;
  final String text;
  final bool isEditable;
  final bool isSelected;
  final ValueChanged<String?>? onSelected;
  final TextStyle style;
  final String hintText;
  final int maxLines;
  final ValueChanged<String> onChanged;
  final Color accentColor;

  const _EditableField({
    required this.fieldId,
    required this.text,
    required this.isEditable,
    required this.isSelected,
    required this.onSelected,
    required this.style,
    required this.hintText,
    this.maxLines = 1,
    required this.onChanged,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!isEditable) {
      // Preview mode — just show text
      return Text(text,
          style: style, maxLines: maxLines == 1 ? null : maxLines);
    }

    return GestureDetector(
      onTap: () => onSelected?.call(isSelected ? null : fieldId),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Dashed selection border
          if (isSelected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: accentColor,
                    width: 1.5,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
              ),
            ),
          // Top action buttons when selected
          if (isSelected)
            Positioned(
              top: -24,
              left: 0,
              child: Row(
                children: [
                  _ActionChip(
                    icon: Icons.delete,
                    color: Colors.red,
                    onTap: () {
                      final actions = _ResumeCanvasActions.maybeOf(context);
                      if (actions == null) {
                        onChanged('');
                        onSelected?.call(fieldId);
                        return;
                      }
                      actions.onDeleteRequested(fieldId);
                    },
                  ),
                ],
              ),
            ),
          // Text field
          TextFormField(
            initialValue: text,
            style: style,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: style.copyWith(
                color: Colors.grey.shade400,
                fontStyle: FontStyle.italic,
              ),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onChanged: (v) {
              onChanged(v);
              onSelected?.call(fieldId);
            },
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Icon(icon, color: Colors.white, size: 12),
      ),
    );
  }
}
