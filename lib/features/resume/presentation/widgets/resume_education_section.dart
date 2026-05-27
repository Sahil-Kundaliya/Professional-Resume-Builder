import 'package:flutter/material.dart';

import '../../domain/entities/resume_document.dart';
import 'resume_dynamic_record_tile.dart';
import 'resume_education_bottom_sheet.dart';

class ResumeEducationSection extends StatelessWidget {
  const ResumeEducationSection({
    super.key,
    required this.items,
    required this.onChanged,
  });

  final List<EducationEntry> items;
  final ValueChanged<List<EducationEntry>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Education',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  onPressed: () => _openAdd(context),
                  icon: const Icon(Icons.add),
                  tooltip: 'Add',
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Text('No education entries yet.')
            else
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return ResumeDynamicRecordTile(
                  title: '${item.coursesSubjects} - ${item.schoolName}',
                  subtitle: item.dateRange,
                  onEdit: () => _openEdit(context, index, item),
                  onDelete: () {
                    final updated = [...items]..removeAt(index);
                    onChanged(updated);
                  },
                );
              }),
          ],
        ),
      ),
    );
  }

  Future<void> _openAdd(BuildContext context) async {
    final item = await ResumeEducationBottomSheet.show(context);
    if (item == null) return;
    onChanged([...items, item]);
  }

  Future<void> _openEdit(
    BuildContext context,
    int index,
    EducationEntry current,
  ) async {
    final updatedItem = await ResumeEducationBottomSheet.show(
      context,
      initialValue: current,
    );
    if (updatedItem == null) return;
    final updated = [...items];
    updated[index] = updatedItem;
    onChanged(updated);
  }
}
