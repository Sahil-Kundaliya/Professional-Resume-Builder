import 'package:flutter/material.dart';

class ProfileBottomSheetActions extends StatelessWidget {
  const ProfileBottomSheetActions({
    super.key,
    required this.onCancel,
    required this.onSave,
    this.isSaving = false,
    this.saveLabel = 'Save',
  });

  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool isSaving;
  final String saveLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isSaving ? null : onCancel,
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: isSaving ? null : onSave,
            child: Text(isSaving ? 'Saving...' : saveLabel),
          ),
        ),
      ],
    );
  }
}
