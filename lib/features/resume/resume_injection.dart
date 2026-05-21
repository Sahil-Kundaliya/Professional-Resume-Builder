import 'package:get_it/get_it.dart';
import '../profile/domain/repositories/profile_repository.dart';
import 'data/mappers/profile_to_resume_prefill_mapper.dart';
import 'data/repositories/profile_prefill_repository_impl.dart';
import 'data/datasources/resume_local_datasource.dart';
import 'data/datasources/resume_local_datasource_impl.dart';
import 'data/repositories/resume_repository_impl.dart';
import 'domain/repositories/profile_prefill_repository.dart';
import 'domain/services/profile_availability_evaluator.dart';
import 'domain/services/profile_value_guards.dart';
import 'domain/repositories/resume_repository.dart';
import 'presentation/bloc/resume_bloc.dart';

void setupResumeFeature() {
  final getIt = GetIt.instance;
  // Datasources
  getIt.registerSingleton<IResumeLocalDatasource>(
    ResumeLocalDatasourceImpl(),
  );

  // Repositories
  getIt.registerSingleton<IResumeRepository>(
    ResumeRepositoryImpl(
      localDatasource: getIt<IResumeLocalDatasource>(),
    ),
  );

  if (!getIt.isRegistered<ProfileValueGuards>()) {
    getIt.registerLazySingleton<ProfileValueGuards>(ProfileValueGuards.new);
  }

  if (!getIt.isRegistered<ProfileAvailabilityEvaluator>()) {
    getIt.registerLazySingleton<ProfileAvailabilityEvaluator>(
      () => ProfileAvailabilityEvaluator(
        guards: getIt<ProfileValueGuards>(),
      ),
    );
  }

  if (!getIt.isRegistered<ProfileToResumePrefillMapper>()) {
    getIt.registerLazySingleton<ProfileToResumePrefillMapper>(
      () => ProfileToResumePrefillMapper(
        guards: getIt<ProfileValueGuards>(),
      ),
    );
  }

  if (!getIt.isRegistered<IProfilePrefillRepository>()) {
    getIt.registerLazySingleton<IProfilePrefillRepository>(
      () => ProfilePrefillRepositoryImpl(
        profileRepository: getIt<IProfileRepository>(),
      ),
    );
  }

  // Blocs
  getIt.registerFactory<ResumeBloc>(
    () => ResumeBloc(
      repository: getIt<IResumeRepository>(),
      prefillMapper: getIt<ProfileToResumePrefillMapper>(),
    ),
  );
}
