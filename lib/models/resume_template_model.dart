import 'package:flutter/material.dart';

enum TemplateLayout { albany, amsterdam, barcelona, berlin, boston, calgary }

class ResumeTemplateModel {
  final String id;
  final String name;
  final TemplateLayout layout;
  final Color accentColor;
  final Color headerBgColor;
  final bool hasPhoto;
  final bool hasSidebar;
  bool isFavorite;

  ResumeTemplateModel({
    required this.id,
    required this.name,
    required this.layout,
    required this.accentColor,
    required this.headerBgColor,
    this.hasPhoto = true,
    this.hasSidebar = true,
    this.isFavorite = false,
  });
}

class ResumeTemplatesRegistry {
  static final List<ResumeTemplateModel> all = [
    ResumeTemplateModel(
      id: 'albany',
      name: 'Albany',
      layout: TemplateLayout.albany,
      accentColor: const Color(0xFF444444),
      headerBgColor: Colors.white,
      hasPhoto: true,
      hasSidebar: true,
    ),
    ResumeTemplateModel(
      id: 'amsterdam',
      name: 'Amsterdam',
      layout: TemplateLayout.amsterdam,
      accentColor: const Color(0xFF6B7FD4),
      headerBgColor: const Color(0xFFEEF0FB),
      hasPhoto: true,
      hasSidebar: true,
    ),
    ResumeTemplateModel(
      id: 'barcelona',
      name: 'Barcelona',
      layout: TemplateLayout.barcelona,
      accentColor: const Color(0xFF444444),
      headerBgColor: Colors.white,
      hasPhoto: true,
      hasSidebar: true,
    ),
    ResumeTemplateModel(
      id: 'berlin',
      name: 'Berlin',
      layout: TemplateLayout.berlin,
      accentColor: const Color(0xFF1E4D8C),
      headerBgColor: const Color(0xFF1E4D8C),
      hasPhoto: true,
      hasSidebar: false,
    ),
    ResumeTemplateModel(
      id: 'boston',
      name: 'Boston',
      layout: TemplateLayout.boston,
      accentColor: const Color(0xFF2E7D32),
      headerBgColor: Colors.white,
      hasPhoto: false,
      hasSidebar: false,
    ),
    ResumeTemplateModel(
      id: 'calgary',
      name: 'Calgary',
      layout: TemplateLayout.calgary,
      accentColor: const Color(0xFF880E4F),
      headerBgColor: const Color(0xFF880E4F),
      hasPhoto: true,
      hasSidebar: true,
    ),
  ];
}
