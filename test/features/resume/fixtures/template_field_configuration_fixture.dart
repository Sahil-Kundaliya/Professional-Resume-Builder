Map<String, dynamic> templateFieldConfigurationFixture({
  String templateId = 'template-modern',
  List<String>? enabledFields,
  List<String>? hiddenFields,
  List<String>? requiredFields,
}) {
  return <String, dynamic>{
    'templateId': templateId,
    'enabledFields': enabledFields ??
        <String>[
          'fullName',
          'jobPosition',
          'summary',
          'birthDate',
          'email',
          'phone',
          'address',
        ],
    'hiddenFields': hiddenFields ?? <String>[],
    'requiredFields': requiredFields ??
        <String>[
          'fullName',
          'summary',
          'email',
          'phone',
        ],
  };
}
