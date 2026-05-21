import 'package:get_it/get_it.dart';

import 'data/datasources/profile_local_data_source.dart';
import 'data/mappers/resume_profile_mapper.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/repositories/profile_repository.dart';
import 'presentation/bloc/profile_bloc.dart';

final getIt = GetIt.instance;

void setupProfileFeature() {
  if (!getIt.isRegistered<ProfileLocalDataSource>()) {
    getIt.registerLazySingleton<ProfileLocalDataSource>(
      ProfileLocalDataSource.new,
    );
  }

  if (!getIt.isRegistered<ResumeProfileMapper>()) {
    getIt.registerLazySingleton<ResumeProfileMapper>(
      ResumeProfileMapper.new,
    );
  }

  if (!getIt.isRegistered<IProfileRepository>()) {
    getIt.registerLazySingleton<IProfileRepository>(
      () => ProfileRepositoryImpl(
        getIt<ProfileLocalDataSource>(),
        getIt<ResumeProfileMapper>(),
      ),
    );
  }

  if (!getIt.isRegistered<ProfileBloc>()) {
    getIt.registerFactory<ProfileBloc>(
      () => ProfileBloc(repository: getIt<IProfileRepository>()),
    );
  }
}
