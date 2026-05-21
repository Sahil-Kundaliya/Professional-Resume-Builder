import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/resume_profile.dart';
import 'profile_empty_state.dart';
import 'profile_section_card.dart';

class ProfileContactSection extends StatelessWidget {
  const ProfileContactSection({super.key, required this.profile});

  final ResumeProfile profile;

  @override
  Widget build(BuildContext context) {
    final items = <_ContactItem>[
      if (profile.email.trim().isNotEmpty)
        _ContactItem(label: 'Email', value: profile.email),
      if (profile.phoneNumber.trim().isNotEmpty)
        _ContactItem(
          label: 'Phone',
          value: '${profile.phoneCountryCode} ${profile.phoneNumber}'.trim(),
        ),
      if (profile.address.trim().isNotEmpty)
        _ContactItem(label: 'Address', value: profile.address),
      if (profile.portfolioLink.trim().isNotEmpty)
        _ContactItem(label: 'Portfolio', value: profile.portfolioLink),
      if (profile.birthDate != null)
        _ContactItem(
          label: 'Birth date',
          value: DateFormat('dd MMM yyyy').format(profile.birthDate!),
        ),
    ];

    return ProfileSectionCard(
      child: items.isEmpty
          ? const ProfileEmptyState(
              title: 'Contact information',
              message:
                  'Email, phone number, address, birth date, and portfolio link will appear here.',
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact information',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 88,
                          child: Text(
                            item.label,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item.value,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              height: 1.4,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ContactItem {
  const _ContactItem({required this.label, required this.value});

  final String label;
  final String value;
}
