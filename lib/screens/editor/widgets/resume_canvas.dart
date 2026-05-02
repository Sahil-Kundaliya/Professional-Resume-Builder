import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/resume_document.dart';
import '../../../models/resume_template_model.dart';

/// Renders the resume as a visual document — used in both preview and editor.
/// When [isEditable] is true, each field becomes an inline text editor
/// with dashed selection border and move/delete controls.
class ResumeCanvas extends StatelessWidget {
  final ResumeDocument document;
  final ResumeTemplateModel? template;
  final bool isEditable;
  final String? selectedFieldId;
  final ValueChanged<String?>? onFieldSelected;

  const ResumeCanvas({
    super.key,
    required this.document,
    required this.template,
    required this.isEditable,
    this.selectedFieldId,
    this.onFieldSelected,
  });

  Color get accent => template?.accentColor ?? const Color(0xFF444444);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        if (isEditable)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            child: GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle, color: const Color(0xFF00A86B), size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'Add row',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF00A86B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
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
          ),
          const SizedBox(width: 14),
          // Name / position / summary
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _EditableField(
                  fieldId: 'fullName',
                  text: document.fullName,
                  isEditable: isEditable,
                  isSelected: selectedFieldId == 'fullName',
                  onSelected: onFieldSelected,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  hintText: 'Full name',
                  onChanged: (v) => document.fullName = v,
                  accentColor: accent,
                ),
                const SizedBox(height: 4),
                _EditableField(
                  fieldId: 'jobPosition',
                  text: document.jobPosition,
                  isEditable: isEditable,
                  isSelected: selectedFieldId == 'jobPosition',
                  onSelected: onFieldSelected,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  hintText: 'Job position',
                  onChanged: (v) => document.jobPosition = v,
                  accentColor: accent,
                ),
                const SizedBox(height: 6),
                _EditableField(
                  fieldId: 'careerGoals',
                  text: document.careerGoals,
                  isEditable: isEditable,
                  isSelected: selectedFieldId == 'careerGoals',
                  onSelected: onFieldSelected,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  hintText: 'Career goals: short-term, long-term',
                  maxLines: 4,
                  onChanged: (v) => document.careerGoals = v,
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
                    style: GoogleFonts.inter(fontSize: 8, color: Colors.grey.shade600),
                    hintText: 'From • To',
                    onChanged: (v) => exp.dateRange = v,
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
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        hintText: 'Position',
                        onChanged: (v) => exp.position = v,
                        accentColor: accent,
                      ),
                      _EditableField(
                        fieldId: 'exp_company_$i',
                        text: exp.companyName,
                        isEditable: isEditable,
                        isSelected: selectedFieldId == 'exp_company_$i',
                        onSelected: onFieldSelected,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          color: Colors.grey.shade500,
                        ),
                        hintText: 'Company name',
                        onChanged: (v) => exp.companyName = v,
                        accentColor: accent,
                      ),
                      _EditableField(
                        fieldId: 'exp_desc_$i',
                        text: exp.description,
                        isEditable: isEditable,
                        isSelected: selectedFieldId == 'exp_desc_$i',
                        onSelected: onFieldSelected,
                        style: GoogleFonts.inter(fontSize: 9, height: 1.6),
                        hintText: 'Experience description',
                        maxLines: 8,
                        onChanged: (v) => exp.description = v,
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
                        style: GoogleFonts.inter(fontSize: 8, color: Colors.grey.shade600),
                        hintText: 'From • To',
                        onChanged: (v) => edu.dateRange = v,
                        accentColor: accent,
                      ),
                      _EditableField(
                        fieldId: 'edu_course_$i',
                        text: edu.coursesSubjects,
                        isEditable: isEditable,
                        isSelected: selectedFieldId == 'edu_course_$i',
                        onSelected: onFieldSelected,
                        style: GoogleFonts.inter(fontSize: 8, color: Colors.grey.shade500),
                        hintText: 'Courses/subjects',
                        onChanged: (v) => edu.coursesSubjects = v,
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
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600),
                        hintText: 'School name',
                        onChanged: (v) => edu.schoolName = v,
                        accentColor: accent,
                      ),
                      _EditableField(
                        fieldId: 'edu_desc_$i',
                        text: edu.description,
                        isEditable: isEditable,
                        isSelected: selectedFieldId == 'edu_desc_$i',
                        onSelected: onFieldSelected,
                        style: GoogleFonts.inter(fontSize: 9, height: 1.5),
                        hintText: 'Education description',
                        maxLines: 4,
                        onChanged: (v) => edu.description = v,
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
            style: GoogleFonts.inter(fontSize: 9, height: 1.6),
            hintText: 'Reference information including name, title and contact information',
            maxLines: 3,
            onChanged: (v) => document.references[i] = v,
            accentColor: accent,
          );
        }),
      ],
    );
  }

  // ── Profile (sidebar) ─────────────────────────────────────────────────────
  Widget _buildProfile(BuildContext context) {
    final fields = [
      ('profile_email', document.email, Icons.email_outlined, (String v) => document.email = v),
      ('profile_phone', document.phone, Icons.phone_outlined, (String v) => document.phone = v),
      ('profile_address', document.address, Icons.location_on_outlined, (String v) => document.address = v),
      ('profile_birthday', document.birthday, Icons.cake_outlined, (String v) => document.birthday = v),
      ('profile_website', document.website, Icons.link_outlined, (String v) => document.website = v),
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
                  style: GoogleFonts.inter(fontSize: 9),
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
            style: GoogleFonts.inter(fontSize: 9, height: 1.8),
            hintText: 'Hobby name',
            onChanged: (v) => document.hobbies[i] = v,
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
                        // Move up
                        _SmallIconBtn(
                          icon: Icons.arrow_upward,
                          color: const Color(0xFF00A86B),
                          onTap: () {},
                        ),
                        // Move down
                        _SmallIconBtn(
                          icon: Icons.arrow_downward,
                          color: const Color(0xFF00A86B),
                          onTap: () {},
                        ),
                        // Rating
                        _SmallIconBtn(
                          icon: Icons.star_outline,
                          color: const Color(0xFF00A86B),
                          onTap: () {},
                        ),
                        // Delete
                        _SmallIconBtn(
                          icon: Icons.delete_outline,
                          color: Colors.red,
                          onTap: () {},
                        ),
                      ],
                    ),
                  TextFormField(
                    initialValue: skill.name,
                    style: GoogleFonts.inter(fontSize: 9),
                    decoration: InputDecoration(
                      hintText: 'Skill name',
                      hintStyle: GoogleFonts.inter(fontSize: 9, color: Colors.grey.shade400),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 2),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (v) => skill.name = v,
                    readOnly: !isEditable,
                  ),
                  // Star rating dots
                  Row(
                    children: List.generate(7, (dotI) {
                      final filled = dotI < skill.rating + 1;
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled ? accent : Colors.grey.shade300,
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
                  style: GoogleFonts.inter(fontSize: 8, color: Colors.grey.shade500),
                  hintText: 'Time',
                  onChanged: (v) => award.year = v,
                  accentColor: accent,
                ),
                _EditableField(
                  fieldId: 'award_name_$i',
                  text: award.name,
                  isEditable: isEditable,
                  isSelected: selectedFieldId == 'award_name_$i',
                  onSelected: onFieldSelected,
                  style: GoogleFonts.inter(fontSize: 9),
                  hintText: 'Award name',
                  onChanged: (v) => award.name = v,
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
                  style: GoogleFonts.inter(fontSize: 8, color: Colors.grey.shade500),
                  hintText: 'Time',
                  onChanged: (v) => cert.year = v,
                  accentColor: accent,
                ),
                _EditableField(
                  fieldId: 'cert_name_$i',
                  text: cert.name,
                  isEditable: isEditable,
                  isSelected: selectedFieldId == 'cert_name_$i',
                  onSelected: onFieldSelected,
                  style: GoogleFonts.inter(fontSize: 9),
                  hintText: 'Certification name',
                  onChanged: (v) => cert.name = v,
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
}

// ── Editable photo widget ──────────────────────────────────────────────────
class _EditablePhoto extends StatelessWidget {
  final bool isEditable;
  final String photoPath;

  const _EditablePhoto({required this.isEditable, required this.photoPath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEditable ? () {} : null,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
        child: photoPath.isEmpty
            ? Icon(Icons.person, size: 36, color: Colors.grey.shade500)
            : Image.asset(photoPath, fit: BoxFit.cover),
      ),
    );
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

  const _SmallIconBtn({required this.icon, required this.color, required this.onTap});

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
      return Text(text, style: style, maxLines: maxLines == 1 ? null : maxLines);
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
                    icon: Icons.open_with,
                    color: const Color(0xFF00A86B),
                    onTap: () {},
                  ),
                  const SizedBox(width: 4),
                  _ActionChip(
                    icon: Icons.delete,
                    color: Colors.red,
                    onTap: () => onSelected?.call(null),
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
              contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
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

  const _ActionChip({required this.icon, required this.color, required this.onTap});

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
