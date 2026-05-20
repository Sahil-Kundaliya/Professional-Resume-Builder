import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_event.freezed.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.loadTemplates() = LoadTemplates;
  const factory HomeEvent.toggleFavorite(String templateId) = ToggleFavorite;
  const factory HomeEvent.loadFavorites() = LoadFavorites;
}
