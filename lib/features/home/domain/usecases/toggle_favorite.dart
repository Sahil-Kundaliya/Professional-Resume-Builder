import '../entities/resume_template.dart';
import '../repositories/template_repository.dart';

class ToggleFavoriteUsecase {
  final ITemplateRepository repository;

  ToggleFavoriteUsecase(this.repository);

  Future<List<ResumeTemplate>> call(String templateId) async {
    return repository.toggleFavorite(templateId);
  }
}
