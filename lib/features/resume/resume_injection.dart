import 'package:get_it/get_it.dart';
import 'data/datasources/resume_local_datasource.dart';
import 'data/datasources/resume_local_datasource_impl.dart';
import 'data/repositories/resume_repository_impl.dart';
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

  // Blocs
  getIt.registerFactory<ResumeBloc>(
    () => ResumeBloc(repository: getIt<IResumeRepository>()),
  );
}
