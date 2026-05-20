import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/template_repository.dart';
import '../../domain/usecases/get_templates.dart';
import '../../domain/usecases/toggle_favorite.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ITemplateRepository repository;

  HomeBloc(this.repository) : super(const HomeState.initial()) {
    on<LoadTemplates>(_onLoadTemplates);
    on<ToggleFavorite>(_onToggleFavorite);
    on<LoadFavorites>(_onLoadFavorites);
  }

  Future<void> _onLoadTemplates(
      LoadTemplates event, Emitter<HomeState> emit) async {
    emit(const HomeState.loading());
    try {
      final usecase = GetTemplatesUsecase(repository);
      final templates = await usecase();
      emit(HomeState.loaded(templates: templates));
    } catch (e) {
      emit(HomeState.error(
          message: 'Failed to load templates: ${e.toString()}'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final usecase = ToggleFavoriteUsecase(repository);
      await usecase(event.templateId);
      // Reload templates after toggling favorite
      final getTemplatesUsecase = GetTemplatesUsecase(repository);
      final templates = await getTemplatesUsecase();
      emit(HomeState.loaded(templates: templates));
    } catch (e) {
      emit(HomeState.error(
          message: 'Failed to toggle favorite: ${e.toString()}'));
    }
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final usecase = GetTemplatesUsecase(repository);
      final templates = await usecase();
      final favorites = templates.where((t) => t.isFavorite).toList();
      emit(HomeState.loaded(templates: favorites));
    } catch (e) {
      emit(HomeState.error(
          message: 'Failed to load favorites: ${e.toString()}'));
    }
  }
}
