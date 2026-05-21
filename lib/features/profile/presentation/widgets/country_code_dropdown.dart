import 'package:flutter/material.dart';

class CountryCodeDropdown extends StatelessWidget {
  const CountryCodeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String?> onChanged;

  static const values = <String>[
    '+1',
    '+44',
    '+61',
    '+81',
    '+91',
    '+971',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: values.contains(value) ? value : values.first,
      decoration: const InputDecoration(labelText: 'Country code'),
      items: values
          .map(
            (code) => DropdownMenuItem<String>(
              value: code,
              child: Text(code),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
