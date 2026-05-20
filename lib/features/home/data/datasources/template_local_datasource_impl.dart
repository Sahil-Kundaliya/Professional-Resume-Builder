import 'package:flutter/material.dart';
import '../models/resume_template_model.dart';
import 'template_local_datasource.dart';

class TemplateLocalDatasourceImpl implements ITemplateLocalDatasource {
  // In-memory storage for templates
  static final List<ResumeTemplateModel> _templates = [
    ResumeTemplateModel(
      id: 'albany',
      name: 'Albany',
      description: 'Clean single-column layout with blue accent',
      accentColor: const Color(0xFF2B4A9F).value,
      isFavorite: false,
      thumbnailPath: 'assets/templates/albany.png',
    ),
    ResumeTemplateModel(
      id: 'amsterdam',
      name: 'Amsterdam',
      description: 'Two-column layout with purple sidebar',
      accentColor: const Color(0xFF6C3483).value,
      isFavorite: false,
      thumbnailPath: 'assets/templates/amsterdam.png',
    ),
    ResumeTemplateModel(
      id: 'barcelona',
      name: 'Barcelona',
      description: 'Modern two-column design with green accents',
      accentColor: const Color(0xFF1A7A4A).value,
      isFavorite: false,
      thumbnailPath: 'assets/templates/barcelona.png',
    ),
    ResumeTemplateModel(
      id: 'berlin',
      name: 'Berlin',
      description: 'Minimal monochrome single-column layout',
      accentColor: const Color(0xFF333333).value,
      isFavorite: false,
      thumbnailPath: 'assets/templates/berlin.png',
    ),
    ResumeTemplateModel(
      id: 'boston',
      name: 'Boston',
      description: 'Bold header with red-orange accent',
      accentColor: const Color(0xFFB5451B).value,
      isFavorite: false,
      thumbnailPath: 'assets/templates/boston.png',
    ),
    ResumeTemplateModel(
      id: 'calgary',
      name: 'Calgary',
      description: 'Professional two-column with teal sidebar',
      accentColor: const Color(0xFF0E7490).value,
      isFavorite: false,
      thumbnailPath: 'assets/templates/calgary.png',
    ),
  ];

  @override
  Future<List<ResumeTemplateModel>> getTemplates() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_templates);
  }

  @override
  Future<void> toggleFavorite(String templateId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _templates.indexWhere((t) => t.id == templateId);
    if (index != -1) {
      final template = _templates[index];
      _templates[index] = template.copyWith(isFavorite: !template.isFavorite);
    }
  }

  @override
  Future<List<ResumeTemplateModel>> getFavoriteTemplates() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _templates.where((t) => t.isFavorite).toList();
  }
}
