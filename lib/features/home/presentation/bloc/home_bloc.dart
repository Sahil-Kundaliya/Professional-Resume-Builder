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
    on<FavoritesFilterChanged>(_onFavoritesFilterChanged);
  }

  Future<void> _onLoadTemplates(
      LoadTemplates event, Emitter<HomeState> emit) async {
    final currentState = state;
    final favoritesOnly =
        currentState is Loaded ? currentState.favoritesOnly : false;

    emit(const HomeState.loading());
    try {
      final usecase = GetTemplatesUsecase(repository);
      final templates = await usecase();
      emit(
        HomeState.loaded(
          templates: templates,
          favoritesOnly: favoritesOnly,
        ),
      );
    } catch (e) {
      emit(HomeState.error(
          message: 'Failed to load templates: ${e.toString()}'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    final favoritesOnly =
        currentState is Loaded ? currentState.favoritesOnly : false;

    try {
      final usecase = ToggleFavoriteUsecase(repository);
      final templates = await usecase(event.templateId);
      emit(
        HomeState.loaded(
          templates: templates,
          favoritesOnly: favoritesOnly,
        ),
      );
    } catch (e) {
      emit(HomeState.error(
          message: 'Failed to toggle favorite: ${e.toString()}'));
    }
  }

  Future<void> _onFavoritesFilterChanged(
    FavoritesFilterChanged event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is Loaded) {
      emit(
        currentState.copyWith(
          favoritesOnly: event.favoritesOnly,
        ),
      );
    }
  }
}
