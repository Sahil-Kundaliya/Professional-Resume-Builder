import '../entities/resume_profile.dart';
import '../repositories/profile_repository.dart';

class LoadResumeProfileUsecase {
  LoadResumeProfileUsecase(this.repository);

  final IProfileRepository repository;

  Future<ResumeProfile> call() => repository.loadProfile();
}
