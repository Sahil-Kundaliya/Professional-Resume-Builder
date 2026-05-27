import 'package:flutter/material.dart';

import '../../domain/entities/resume_document.dart';
import 'resume_form_mappers.dart';
import 'resume_form_validators.dart';

class ResumeWorkExperienceBottomSheet extends StatefulWidget {
  const ResumeWorkExperienceBottomSheet({
    super.key,
    this.initialValue,
  });

  final WorkExperienceEntry? initialValue;

  static Future<WorkExperienceEntry?> show(
    BuildContext context, {
    WorkExperienceEntry? initialValue,
  }) {
    return showModalBottomSheet<WorkExperienceEntry>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ResumeWorkExperienceBottomSheet(
        initialValue: initialValue,
      ),
    );
  }

  @override
  State<ResumeWorkExperienceBottomSheet> createState() =>
      _ResumeWorkExperienceBottomSheetState();
}

class _ResumeWorkExperienceBottomSheetState
    extends State<ResumeWorkExperienceBottomSheet> {
  late final TextEditingController _companyController;
  late final TextEditingController _positionController;
  late final TextEditingController _descriptionController;

  DateTime? _startDate;
  DateTime? _endDate;
  String? _error;

  @override
  void initState() {
    super.initState();
    _companyController = TextEditingController(
      text: widget.initialValue?.companyName ?? '',
    );
    _positionController = TextEditingController(
      text: widget.initialValue?.position ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialValue?.description ?? '',
    );

    final parsed = ResumeFormMappers.parseMonthYearRange(
      widget.initialValue?.dateRange ?? '',
    );
    _startDate = parsed.$1;
    _endDate = parsed.$2;
  }

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.initialValue == null
                    ? 'Add work experience'
                    : 'Edit work experience',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Company'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _positionController,
                decoration: const InputDecoration(labelText: 'Position'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(isStart: true),
                      child: Text(
                        _startDate == null
                            ? 'Start date'
                            : ResumeFormMappers.monthYear(_startDate!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(isStart: false),
                      child: Text(
                        _endDate == null
                            ? 'End date'
                            : ResumeFormMappers.monthYear(_endDate!),
                      ),
                    ),
                  ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _onSave,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = (isStart ? _startDate : _endDate) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  void _onSave() {
    final companyError = ResumeFormValidators.requiredText(
      _companyController.text,
      fieldName: 'Company',
    );
    final positionError = ResumeFormValidators.requiredText(
      _positionController.text,
      fieldName: 'Position',
    );
    final descriptionError = ResumeFormValidators.requiredText(
      _descriptionController.text,
      fieldName: 'Description',
    );
    final dateError = ResumeFormValidators.optionalDateRange(
      start: _startDate,
      end: _endDate,
      startLabel: 'Start date',
      endLabel: 'End date',
    );

    final error =
        companyError ?? positionError ?? descriptionError ?? dateError;
    if (error != null) {
      setState(() => _error = error);
      return;
    }

    Navigator.of(context).pop(
      ResumeFormMappers.toWorkExperienceEntry(
        company: _companyController.text,
        position: _positionController.text,
        startDate: _startDate!,
        endDate: _endDate!,
        description: _descriptionController.text,
      ),
    );
  }
}
