import '../entities/resume_template.dart';
import '../repositories/template_repository.dart';

class GetTemplatesUsecase {
  final ITemplateRepository repository;

  GetTemplatesUsecase(this.repository);

  Future<List<ResumeTemplate>> call() async {
    return await repository.getTemplates();
  }
}
