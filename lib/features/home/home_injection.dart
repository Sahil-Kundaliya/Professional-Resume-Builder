import 'package:get_it/get_it.dart';
import 'data/datasources/favorite_templates_store.dart';
import 'data/datasources/favorite_templates_store_impl.dart';
import 'data/datasources/template_local_datasource_impl.dart';
import 'data/repositories/template_repository_impl.dart';
import 'domain/repositories/template_repository.dart';
import 'domain/usecases/get_templates.dart';
import 'domain/usecases/toggle_favorite.dart';
import 'presentation/bloc/home_bloc.dart';

final getIt = GetIt.instance;

void setupHomeFeature() {
  // Favorite store
  getIt.registerLazySingleton<IFavoriteTemplatesStore>(
    FavoriteTemplatesStoreImpl.new,
  );

  // Datasources
  getIt.registerLazySingleton<TemplateLocalDatasourceImpl>(
    () => TemplateLocalDatasourceImpl(getIt<IFavoriteTemplatesStore>()),
  );

  // Repositories
  getIt.registerLazySingleton<ITemplateRepository>(
    () => TemplateRepositoryImpl(getIt<TemplateLocalDatasourceImpl>()),
  );

  // Usecases
  getIt.registerLazySingleton<GetTemplatesUsecase>(
    () => GetTemplatesUsecase(getIt<ITemplateRepository>()),
  );

  getIt.registerLazySingleton<ToggleFavoriteUsecase>(
    () => ToggleFavoriteUsecase(getIt<ITemplateRepository>()),
  );

  // Blocs
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(getIt<ITemplateRepository>()),
  );
}
