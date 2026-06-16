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
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic details',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
              color: const Color(0xFF080D32),
            ),
          ),
          const SizedBox(height: 22),
          ProfileImagePickerField(
            imagePath: imagePath,
            onPickImage: onPickImage,
          ),
          const SizedBox(height: 22),
          TextField(
            controller: fullNameController,
            decoration: _fieldDecoration('Full name'),
            textInputAction: TextInputAction.next,
            style: _valueStyle(),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: jobTitleController,
            decoration: _fieldDecoration('Job title'),
            textInputAction: TextInputAction.next,
            style: _valueStyle(),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: summaryController,
            decoration: _fieldDecoration('Summary'),
            minLines: 3,
            maxLines: 5,
            style: _valueStyle(),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: emailController,
            decoration: _fieldDecoration('Email'),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: _valueStyle(),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: addressController,
            decoration: _fieldDecoration('Address'),
            textInputAction: TextInputAction.next,
            style: _valueStyle(),
          ),
          const SizedBox(height: 14),
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
                  decoration: _fieldDecoration('Phone number'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  style: _valueStyle(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: portfolioController,
            decoration: _fieldDecoration('Portfolio link'),
            keyboardType: TextInputType.url,
            style: _valueStyle(),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: onPickBirthDate,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF242947),
              side: const BorderSide(color: Color(0xFFD6D8E6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            icon: const Icon(Icons.calendar_today_outlined, size: 18),
            label: Text(birthDateLabel),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        color: const Color(0xFF353B5B),
      ),
      floatingLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF353B5B),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD6D8E6)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF5B2ECC), width: 1.6),
      ),
      contentPadding: const EdgeInsets.only(bottom: 12),
    );
  }

  TextStyle _valueStyle() {
    return GoogleFonts.inter(
      fontSize: 18,
      height: 1.42,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF0B102B),
    );
  }
}
