import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'country_code_dropdown.dart';
import 'profile_image_picker_field.dart';
import 'profile_section_card.dart';

class BasicDetailsSection extends StatelessWidget {
  const BasicDetailsSection({
    super.key,
    required this.fullNameController,
    required this.jobTitleController,
    required this.summaryController,
    required this.emailController,
    required this.addressController,
    required this.phoneController,
    required this.portfolioController,
    required this.imagePath,
    required this.countryCode,
    required this.birthDateLabel,
    required this.onPickImage,
    required this.onCountryCodeChanged,
    required this.onPickBirthDate,
  });

  final TextEditingController fullNameController;
  final TextEditingController jobTitleController;
  final TextEditingController summaryController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController portfolioController;
  final String imagePath;
  final String countryCode;
  final String birthDateLabel;
  final VoidCallback onPickImage;
  final ValueChanged<String?> onCountryCodeChanged;
  final VoidCallback onPickBirthDate;

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic details',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ProfileImagePickerField(
            imagePath: imagePath,
            onPickImage: onPickImage,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: fullNameController,
            decoration: const InputDecoration(labelText: 'Full name'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: jobTitleController,
            decoration: const InputDecoration(labelText: 'Job title'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: summaryController,
            decoration: const InputDecoration(labelText: 'Summary'),
            minLines: 3,
            maxLines: 5,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: addressController,
            decoration: const InputDecoration(labelText: 'Address'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: CountryCodeDropdown(
                  value: countryCode,
                  onChanged: onCountryCodeChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone number'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: portfolioController,
            decoration: const InputDecoration(labelText: 'Portfolio link'),
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onPickBirthDate,
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text(birthDateLabel),
          ),
        ],
      ),
    );
  }
}
