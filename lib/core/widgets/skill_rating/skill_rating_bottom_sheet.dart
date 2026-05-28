import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'skill_rating_utils.dart';

class SkillRatingBottomSheet extends StatefulWidget {
  const SkillRatingBottomSheet({
    super.key,
    this.initialName = '',
    this.initialRating = kDefaultSkillRating,
    this.title = 'Add skill',
    this.nameLabel = 'Skill title',
    this.saveLabel = 'Save skill',
  });

  final String initialName;
  final int initialRating;
  final String title;
  final String nameLabel;
  final String saveLabel;

  static Future<SkillRatingDraft?> show(
    BuildContext context, {
    String initialName = '',
    int initialRating = kDefaultSkillRating,
    String title = 'Add skill',
    String nameLabel = 'Skill title',
    String saveLabel = 'Save skill',
  }) {
    return showModalBottomSheet<SkillRatingDraft>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SkillRatingBottomSheet(
        initialName: initialName,
        initialRating: initialRating,
        title: title,
        nameLabel: nameLabel,
        saveLabel: saveLabel,
      ),
    );
  }

  @override
  State<SkillRatingBottomSheet> createState() => _SkillRatingBottomSheetState();
}

class _SkillRatingBottomSheetState extends State<SkillRatingBottomSheet> {
  late final TextEditingController _nameController;
  late int _rating;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _rating = clampSkillRating(widget.initialRating);
  }

  @override
  void dispose() {
    _nameController.dispose();
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
                widget.title,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: widget.nameLabel),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 16),
              Text(
                'Expertise',
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
                  kMaxSkillRating,
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
                children: buildSkillRatingStars(_rating, size: 22),
              ),
              const SizedBox(height: 6),
              Text(
                skillRatingLabel(_rating),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
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
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      child: Text(widget.saveLabel),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Skill title is required.';
      });
      return;
    }

    Navigator.pop(
      context,
      SkillRatingDraft(
        name: name,
        rating: clampSkillRating(_rating),
      ),
    );
  }
}
