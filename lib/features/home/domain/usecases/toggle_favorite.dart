import '../repositories/template_repository.dart';

class ToggleFavoriteUsecase {
  final ITemplateRepository repository;

  ToggleFavoriteUsecase(this.repository);

  Future<void> call(String templateId) async {
    await repository.toggleFavorite(templateId);
  }
}
