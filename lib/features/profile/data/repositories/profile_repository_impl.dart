import '../../domain/entities/resume_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../mappers/resume_profile_mapper.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  ProfileRepositoryImpl(this.localDataSource, this.mapper);

  final ProfileLocalDataSource localDataSource;
  final ResumeProfileMapper mapper;

  @override
  Future<ResumeProfile> loadProfile() async {
    final model = await localDataSource.loadProfile();
    return mapper.toDomain(model);
  }

  @override
  Future<ResumeProfile> saveProfile(ResumeProfile profile) async {
    final normalizedProfile = profile.copyWith(
      updatedAt: DateTime.now(),
    );
    final model = mapper.toModel(normalizedProfile);
    final savedModel = await localDataSource.saveProfile(model);
    return mapper.toDomain(savedModel);
  }
}
