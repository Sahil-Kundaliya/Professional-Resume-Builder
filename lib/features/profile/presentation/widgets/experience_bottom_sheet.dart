import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/resume_profile.dart';
import 'profile_bottom_sheet_actions.dart';
import 'profile_section_date_formatter.dart';
import 'profile_section_validators.dart';

class ExperienceBottomSheet extends StatefulWidget {
  const ExperienceBottomSheet({super.key});

  static Future<ProfileExperience?> show(BuildContext context) {
    return showModalBottomSheet<ProfileExperience>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ExperienceBottomSheet(),
    );
  }

  @override
  State<ExperienceBottomSheet> createState() => _ExperienceBottomSheetState();
}

class _ExperienceBottomSheetState extends State<ExperienceBottomSheet> {
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _detailsController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String? _errorMessage;

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    _detailsController.dispose();
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
                'Add experience',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Company name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _positionController,
                decoration: const InputDecoration(labelText: 'Job position'),
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
              const SizedBox(height: 12),
              TextField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  labelText: 'Topic-based details (one per line)',
                ),
                minLines: 3,
                maxLines: 6,
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
                saveLabel: 'Add experience',
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
    final details = _detailsController.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    final experience = ProfileExperience(
      companyName: _companyController.text.trim(),
      position: _positionController.text.trim(),
      startDate: _startDate,
      endDate: _endDate,
      detailLines: details,
    );

    final error = ProfileSectionValidators.validateExperience(experience);
    if (error != null) {
      setState(() {
        _errorMessage = error;
      });
      return;
    }

    Navigator.pop(context, experience);
  }
}
