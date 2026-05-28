import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'favorite_templates_store.dart';
import '../models/resume_template_model.dart';
import 'template_local_datasource.dart';

class TemplateLocalDatasourceImpl implements ITemplateLocalDatasource {
  TemplateLocalDatasourceImpl(this._favoriteStore);

  final IFavoriteTemplatesStore _favoriteStore;

  static final List<ResumeTemplateModel> _catalog = [
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
    final favoriteIds = await _loadFavoriteIdsSafely();
    return _withFavoriteState(favoriteIds);
  }

  @override
  Future<List<ResumeTemplateModel>> toggleFavorite(String templateId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final favoriteIds = await _loadFavoriteIdsSafely();
    if (favoriteIds.contains(templateId)) {
      favoriteIds.remove(templateId);
    } else {
      favoriteIds.add(templateId);
    }

    await _saveFavoriteIdsSafely(favoriteIds);
    return _withFavoriteState(favoriteIds);
  }

  @override
  Future<List<ResumeTemplateModel>> getFavoriteTemplates() async {
    final templates = await getTemplates();
    return templates.where((t) => t.isFavorite).toList(growable: false);
  }

  @override
  Future<Set<String>> getFavoriteTemplateIds() async {
    return _loadFavoriteIdsSafely();
  }

  Future<Set<String>> _loadFavoriteIdsSafely() async {
    try {
      final ids = await _favoriteStore.loadFavoriteTemplateIds();
      return ids;
    } catch (error) {
      debugPrint('Failed to load favorite template IDs: $error');
      return <String>{};
    }
  }

  Future<void> _saveFavoriteIdsSafely(Set<String> ids) async {
    try {
      await _favoriteStore.saveFavoriteTemplateIds(ids);
    } catch (error) {
      debugPrint('Failed to save favorite template IDs: $error');
    }
  }

  List<ResumeTemplateModel> _withFavoriteState(Set<String> favoriteIds) {
    return _catalog
        .map(
          (template) => template.copyWith(
            isFavorite: favoriteIds.contains(template.id),
          ),
        )
        .toList(growable: false);
  }
}
