class ProfileAvailabilityResult {
  const ProfileAvailabilityResult({
    required this.hasUsableData,
    required this.usableFieldKeys,
    required this.sourceState,
  });

  final bool hasUsableData;
  final List<String> usableFieldKeys;
  final ProfileAvailabilitySourceState sourceState;

  factory ProfileAvailabilityResult.empty({
    ProfileAvailabilitySourceState sourceState =
        ProfileAvailabilitySourceState.empty,
  }) {
    return ProfileAvailabilityResult(
      hasUsableData: false,
      usableFieldKeys: const [],
      sourceState: sourceState,
    );
  }
}

enum ProfileAvailabilitySourceState {
  loaded,
  empty,
  error,
}
