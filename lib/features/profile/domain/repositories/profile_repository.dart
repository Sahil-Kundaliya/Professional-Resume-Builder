import '../entities/resume_profile.dart';

abstract class IProfileRepository {
  Future<ResumeProfile> loadProfile();

  Future<ResumeProfile> saveProfile(ResumeProfile profile);
}
