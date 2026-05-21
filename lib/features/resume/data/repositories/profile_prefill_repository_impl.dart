import '../../../profile/domain/entities/resume_profile.dart';
import '../../../profile/domain/repositories/profile_repository.dart';
import '../../domain/repositories/profile_prefill_repository.dart';

class ProfilePrefillRepositoryImpl implements IProfilePrefillRepository {
  ProfilePrefillRepositoryImpl({
    required this.profileRepository,
  });

  final IProfileRepository profileRepository;

  @override
  Future<ResumeProfile> loadProfile() {
    return profileRepository.loadProfile();
  }
}
