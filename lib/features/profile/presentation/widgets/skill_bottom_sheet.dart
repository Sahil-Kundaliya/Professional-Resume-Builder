import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/resume_profile.dart';
import 'profile_bottom_sheet_actions.dart';

class SkillBottomSheet extends StatefulWidget {
  const SkillBottomSheet({super.key, this.initialSkill});

  final ProfileSkill? initialSkill;

  static Future<ProfileSkill?> show(
    BuildContext context, {
    ProfileSkill? initialSkill,
  }) {
    return showModalBottomSheet<ProfileSkill>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SkillBottomSheet(initialSkill: initialSkill),
    );
  }

  @override
  State<SkillBottomSheet> createState() => _SkillBottomSheetState();
}

class _SkillBottomSheetState extends State<SkillBottomSheet> {
  late final TextEditingController _titleController;
  late int _rating;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialSkill?.name ?? '',
    );
    _rating = widget.initialSkill?.rating.clamp(1, 5) ?? 3;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isEditing = widget.initialSkill != null;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEditing ? 'Edit skill' : 'Add skill',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Skill title'),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 16),
              Text(
                'Rating',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: List.generate(
                  5,
                  (index) {
                    final value = index + 1;
                    return ChoiceChip(
                      label: Text('$value'),
                      selected: _rating == value,
                      onSelected: (_) {
                        setState(() {
                          _rating = value;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < _rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: Colors.amber.shade700,
                    size: 22,
                  ),
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
                saveLabel: isEditing ? 'Save skill' : 'Add skill',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    final name = _titleController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Skill title is required.';
      });
      return;
    }

    Navigator.pop(
      context,
      ProfileSkill(
        name: name,
        rating: _rating,
      ),
    );
  }
}
