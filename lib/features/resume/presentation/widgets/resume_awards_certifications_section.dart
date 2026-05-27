import 'package:flutter/material.dart';

import '../../domain/entities/resume_document.dart';

class ResumeAwardsCertificationsSection extends StatelessWidget {
  const ResumeAwardsCertificationsSection({
    super.key,
    required this.awards,
    required this.certifications,
    required this.onAwardsChanged,
    required this.onCertificationsChanged,
  });

  final List<AwardEntry> awards;
  final List<CertEntry> certifications;
  final ValueChanged<List<AwardEntry>> onAwardsChanged;
  final ValueChanged<List<CertEntry>> onCertificationsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAwardCard(),
        const SizedBox(height: 10),
        _buildCertificationCard(),
      ],
    );
  }

  Widget _buildAwardCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              title: 'Awards',
              onAdd: () => onAwardsChanged(
                  [...awards, const AwardEntry(year: '', name: '')]),
            ),
            const SizedBox(height: 8),
            if (awards.isEmpty)
              const Text('No awards added yet.')
            else
              ...awards.asMap().entries.map((entry) {
                final index = entry.key;
                final value = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: value.name,
                          decoration:
                              const InputDecoration(labelText: 'Award title'),
                          onChanged: (next) {
                            final updated = [...awards];
                            updated[index] = value.copyWith(name: next);
                            onAwardsChanged(updated);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 90,
                        child: TextFormField(
                          initialValue: value.year,
                          decoration: const InputDecoration(labelText: 'Year'),
                          onChanged: (next) {
                            final updated = [...awards];
                            updated[index] = value.copyWith(year: next);
                            onAwardsChanged(updated);
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          final updated = [...awards]..removeAt(index);
                          onAwardsChanged(updated);
                        },
                        icon: const Icon(Icons.delete_outline),
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

  Widget _buildCertificationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              title: 'Certifications',
              onAdd: () => onCertificationsChanged([
                ...certifications,
                const CertEntry(year: '', name: ''),
              ]),
            ),
            const SizedBox(height: 8),
            if (certifications.isEmpty)
              const Text('No certifications added yet.')
            else
              ...certifications.asMap().entries.map((entry) {
                final index = entry.key;
                final value = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: value.name,
                          decoration: const InputDecoration(
                              labelText: 'Certification title'),
                          onChanged: (next) {
                            final updated = [...certifications];
                            updated[index] = value.copyWith(name: next);
                            onCertificationsChanged(updated);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 90,
                        child: TextFormField(
                          initialValue: value.year,
                          decoration: const InputDecoration(labelText: 'Year'),
                          onChanged: (next) {
                            final updated = [...certifications];
                            updated[index] = value.copyWith(year: next);
                            onCertificationsChanged(updated);
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          final updated = [...certifications]..removeAt(index);
                          onCertificationsChanged(updated);
                        },
                        icon: const Icon(Icons.delete_outline),
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

  Widget _sectionHeader({required String title, required VoidCallback onAdd}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          tooltip: 'Add',
        ),
      ],
    );
  }
}
