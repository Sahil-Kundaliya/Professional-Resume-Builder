import '../entities/resume_profile.dart';
import '../repositories/profile_repository.dart';

class SaveResumeProfileUsecase {
  SaveResumeProfileUsecase(this.repository);

  final IProfileRepository repository;

  Future<ResumeProfile> call(ResumeProfile profile) =>
      repository.saveProfile(profile);
}
