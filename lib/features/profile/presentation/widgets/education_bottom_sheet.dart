import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/resume_profile.dart';
import 'profile_bottom_sheet_actions.dart';
import 'profile_section_date_formatter.dart';
import 'profile_section_validators.dart';

class EducationBottomSheet extends StatefulWidget {
  const EducationBottomSheet({super.key});

  static Future<ProfileEducation?> show(BuildContext context) {
    return showModalBottomSheet<ProfileEducation>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const EducationBottomSheet(),
    );
  }

  @override
  State<EducationBottomSheet> createState() => _EducationBottomSheetState();
}

class _EducationBottomSheetState extends State<EducationBottomSheet> {
  final _schoolController = TextEditingController();
  final _degreeController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String? _errorMessage;

  @override
  void dispose() {
    _schoolController.dispose();
    _degreeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add education',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _schoolController,
                decoration:
                    const InputDecoration(labelText: 'School or college name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _degreeController,
                decoration: const InputDecoration(labelText: 'Degree'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickDate(isStartDate: true),
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text(
                        _startDate == null
                            ? 'Start date'
                            : ProfileSectionDateFormatter.format(_startDate),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickDate(isStartDate: false),
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text(
                        _endDate == null
                            ? 'End date'
                            : ProfileSectionDateFormatter.format(_endDate),
                      ),
                    ),
                  ),
                ],
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
              const SizedBox(height: 18),
              ProfileBottomSheetActions(
                onCancel: () => Navigator.pop(context),
                onSave: _save,
                saveLabel: 'Add education',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    final initialDate = isStartDate
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? _startDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      if (isStartDate) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  void _save() {
    final education = ProfileEducation(
      schoolName: _schoolController.text.trim(),
      degreeName: _degreeController.text.trim(),
      startDate: _startDate,
      endDate: _endDate,
    );

    final error = ProfileSectionValidators.validateEducation(education);
    if (error != null) {
      setState(() {
        _errorMessage = error;
      });
      return;
    }

    Navigator.pop(context, education);
  }
}
