import 'package:flutter/material.dart';

import '../../domain/entities/resume_document.dart';
import 'resume_dynamic_record_tile.dart';
import 'resume_work_experience_bottom_sheet.dart';

class ResumeWorkExperienceSection extends StatelessWidget {
  const ResumeWorkExperienceSection({
    super.key,
    required this.items,
    required this.onChanged,
  });

  final List<WorkExperienceEntry> items;
  final ValueChanged<List<WorkExperienceEntry>> onChanged;

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
                    'Work Experience',
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
              const Text('No work experience entries yet.')
            else
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return ResumeDynamicRecordTile(
                  title: '${item.position} at ${item.companyName}',
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
    final item = await ResumeWorkExperienceBottomSheet.show(context);
    if (item == null) return;
    onChanged([...items, item]);
  }

  Future<void> _openEdit(
    BuildContext context,
    int index,
    WorkExperienceEntry current,
  ) async {
    final updatedItem = await ResumeWorkExperienceBottomSheet.show(
      context,
      initialValue: current,
    );
    if (updatedItem == null) return;
    final updated = [...items];
    updated[index] = updatedItem;
    onChanged(updated);
  }
}
