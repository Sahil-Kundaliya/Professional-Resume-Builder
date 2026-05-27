import 'package:flutter/material.dart';

import '../../domain/entities/resume_document.dart';
import 'resume_form_mappers.dart';
import 'resume_form_validators.dart';

class ResumeEducationBottomSheet extends StatefulWidget {
  const ResumeEducationBottomSheet({
    super.key,
    this.initialValue,
  });

  final EducationEntry? initialValue;

  static Future<EducationEntry?> show(
    BuildContext context, {
    EducationEntry? initialValue,
  }) {
    return showModalBottomSheet<EducationEntry>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ResumeEducationBottomSheet(initialValue: initialValue),
    );
  }

  @override
  State<ResumeEducationBottomSheet> createState() =>
      _ResumeEducationBottomSheetState();
}

class _ResumeEducationBottomSheetState
    extends State<ResumeEducationBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _schoolController;
  late final TextEditingController _descriptionController;

  DateTime? _startDate;
  DateTime? _endDate;
  String? _error;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialValue?.coursesSubjects ?? '',
    );
    _schoolController = TextEditingController(
      text: widget.initialValue?.schoolName ?? '',
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
    _titleController.dispose();
    _schoolController.dispose();
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
                    ? 'Add education'
                    : 'Edit education',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _schoolController,
                decoration: const InputDecoration(labelText: 'School'),
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
                Text(_error!, style: const TextStyle(color: Colors.red)),
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
    final titleError = ResumeFormValidators.requiredText(_titleController.text,
        fieldName: 'Title');
    final schoolError = ResumeFormValidators.requiredText(
      _schoolController.text,
      fieldName: 'School',
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

    final error = titleError ?? schoolError ?? descriptionError ?? dateError;
    if (error != null) {
      setState(() => _error = error);
      return;
    }

    Navigator.of(context).pop(
      ResumeFormMappers.toEducationEntry(
        title: _titleController.text,
        school: _schoolController.text,
        description: _descriptionController.text,
        startDate: _startDate!,
        endDate: _endDate!,
      ),
    );
  }
}
