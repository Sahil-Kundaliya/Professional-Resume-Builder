import '../../../profile/domain/entities/resume_profile.dart';

abstract class IProfilePrefillRepository {
  Future<ResumeProfile> loadProfile();
}
