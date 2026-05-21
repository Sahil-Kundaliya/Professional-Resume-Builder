import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/resume_profile.dart';
import 'profile_bottom_sheet_actions.dart';
import 'profile_section_date_formatter.dart';
import 'profile_section_validators.dart';

class CertificationBottomSheet extends StatefulWidget {
  const CertificationBottomSheet({super.key});

  static Future<ProfileCertification?> show(BuildContext context) {
    return showModalBottomSheet<ProfileCertification>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const CertificationBottomSheet(),
    );
  }

  @override
  State<CertificationBottomSheet> createState() =>
      _CertificationBottomSheetState();
}

class _CertificationBottomSheetState extends State<CertificationBottomSheet> {
  final _titleController = TextEditingController();
  DateTime? _date;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
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
                'Add certification',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(
                  _date == null
                      ? 'Date'
                      : ProfileSectionDateFormatter.format(_date),
                ),
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
                saveLabel: 'Add certification',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _date = picked;
    });
  }

  void _save() {
    final certification = ProfileCertification(
      title: _titleController.text.trim(),
      date: _date,
    );

    final error = ProfileSectionValidators.validateCertification(certification);
    if (error != null) {
      setState(() {
        _errorMessage = error;
      });
      return;
    }

    Navigator.pop(context, certification);
  }
}
