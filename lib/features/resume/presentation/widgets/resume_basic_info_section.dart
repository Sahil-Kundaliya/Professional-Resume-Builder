import 'package:flutter/material.dart';

import '../../domain/entities/resume_document.dart';

class ResumeBasicInfoSection extends StatelessWidget {
  const ResumeBasicInfoSection({
    super.key,
    required this.document,
    required this.onUpdateFullName,
    required this.onUpdateJobPosition,
    required this.onUpdateSummary,
    required this.onUpdateBirthDate,
    required this.onUpdateEmail,
    required this.onUpdatePhone,
    required this.onUpdateAddress,
    required this.onUpdatePortfolio,
    required this.onPickImage,
    required this.isImageSupported,
  });

  final ResumeDocument document;
  final ValueChanged<String> onUpdateFullName;
  final ValueChanged<String> onUpdateJobPosition;
  final ValueChanged<String> onUpdateSummary;
  final ValueChanged<String> onUpdateBirthDate;
  final ValueChanged<String> onUpdateEmail;
  final ValueChanged<String> onUpdatePhone;
  final ValueChanged<String> onUpdateAddress;
  final ValueChanged<String> onUpdatePortfolio;
  final VoidCallback onPickImage;
  final bool isImageSupported;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            if (isImageSupported) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      document.photoPath.trim().isEmpty
                          ? 'No profile image selected'
                          : document.photoPath,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: onPickImage,
                    child: const Text('Select image'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            TextFormField(
              initialValue: document.fullName,
              decoration: const InputDecoration(labelText: 'Full name'),
              onChanged: onUpdateFullName,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: document.jobPosition,
              decoration: const InputDecoration(labelText: 'Job position'),
              onChanged: onUpdateJobPosition,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: document.careerGoals,
              decoration: const InputDecoration(labelText: 'Summary'),
              minLines: 3,
              maxLines: 5,
              onChanged: onUpdateSummary,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: document.birthday,
              decoration: const InputDecoration(labelText: 'Birth date'),
              onChanged: onUpdateBirthDate,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: document.email,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              onChanged: onUpdateEmail,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: document.phone,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
              onChanged: onUpdatePhone,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: document.address,
              decoration: const InputDecoration(labelText: 'Address'),
              onChanged: onUpdateAddress,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: document.website,
              decoration: const InputDecoration(labelText: 'Portfolio'),
              onChanged: onUpdatePortfolio,
            ),
          ],
        ),
      ),
    );
  }
}
