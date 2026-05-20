import 'package:get_it/get_it.dart';
import 'data/datasources/template_local_datasource_impl.dart';
import 'data/repositories/template_repository_impl.dart';
import 'domain/repositories/template_repository.dart';
import 'domain/usecases/get_templates.dart';
import 'domain/usecases/toggle_favorite.dart';
import 'presentation/bloc/home_bloc.dart';

final getIt = GetIt.instance;

void setupHomeFeature() {
  // Datasources
  getIt.registerSingleton<TemplateLocalDatasourceImpl>(
    TemplateLocalDatasourceImpl(),
  );

  // Repositories
  getIt.registerSingleton<ITemplateRepository>(
    TemplateRepositoryImpl(getIt<TemplateLocalDatasourceImpl>()),
  );

  // Usecases
  getIt.registerSingleton<GetTemplatesUsecase>(
    GetTemplatesUsecase(getIt<ITemplateRepository>()),
  );

  getIt.registerSingleton<ToggleFavoriteUsecase>(
    ToggleFavoriteUsecase(getIt<ITemplateRepository>()),
  );

  // Blocs
  getIt.registerSingleton<HomeBloc>(
    HomeBloc(getIt<ITemplateRepository>()),
  );
}
