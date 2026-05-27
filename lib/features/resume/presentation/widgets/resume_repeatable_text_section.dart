import 'package:flutter/material.dart';

class ResumeRepeatableTextSection extends StatelessWidget {
  const ResumeRepeatableTextSection({
    super.key,
    required this.title,
    required this.items,
    required this.onChanged,
    this.hint = 'Item',
  });

  final String title;
  final List<String> items;
  final ValueChanged<List<String>> onChanged;
  final String hint;

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
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final updated = [...items, ''];
                    onChanged(updated);
                  },
                  icon: const Icon(Icons.add),
                  tooltip: 'Add',
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Text('No items yet. Tap + to add one.')
            else
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final value = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: value,
                          decoration: InputDecoration(
                            labelText: '$hint ${index + 1}',
                          ),
                          onChanged: (next) {
                            final updated = [...items];
                            updated[index] = next;
                            onChanged(updated);
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          final updated = [...items]..removeAt(index);
                          onChanged(updated);
                        },
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Remove',
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
