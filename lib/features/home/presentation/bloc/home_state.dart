import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/resume_template.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = Initial;
  const factory HomeState.loading() = Loading;
  const factory HomeState.loaded({
    required List<ResumeTemplate> templates,
    @Default(false) bool favoritesOnly,
  }) = Loaded;
  const factory HomeState.error({required String message}) = Error;
}

extension LoadedHomeStateX on Loaded {
  List<ResumeTemplate> get visibleTemplates {
    if (!favoritesOnly) {
      return templates;
    }
    return templates.where((template) => template.isFavorite).toList();
  }
}
