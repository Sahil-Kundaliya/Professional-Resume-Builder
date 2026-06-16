import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder/config/routes/route_names.dart';
import 'package:resume_builder/core/constants/app_colors.dart';
import 'package:resume_builder/core/constants/app_text_styles.dart';

import '../../domain/entities/resume_template.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/template_grid.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Templates'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: Text('Loading...')),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (templates, favoritesOnly) {
              final loadedState = Loaded(
                templates: templates,
                favoritesOnly: favoritesOnly,
              );
              final visibleTemplates = loadedState.visibleTemplates;

              if (templates.isEmpty) {
                return const Center(child: Text('No templates available'));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
                    child: Text(
                      'Resume Templates',
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: FilterChip(
                      label: Text(
                        'Favorites Only',
                        style: AppTextStyles.chipText.copyWith(
                          color: favoritesOnly
                              ? AppColors.surface
                              : AppColors.primary,
                        ),
                      ),
                      selected: favoritesOnly,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      side: BorderSide(
                        color: favoritesOnly
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      onSelected: (value) {
                        context.read<HomeBloc>().add(
                              HomeEvent.favoritesFilterChanged(value),
                            );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: visibleTemplates.isEmpty && favoritesOnly
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 36),
                              child: Text(
                                'No favorite templates yet. Mark templates with the heart icon to see them here.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : TemplateGrid(
                            templates: visibleTemplates,
                            onTemplateSelected: (template) {
                              _openTemplatePreview(context, template);
                            },
                            onFavoriteToggled: (templateId) {
                              context.read<HomeBloc>().add(
                                    HomeEvent.toggleFavorite(templateId),
                                  );
                            },
                          ),
                  ),
                ],
              );
            },
            error: (message) => Center(
              child: Text('Error: $message'),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openTemplatePreview(
    BuildContext context,
    ResumeTemplate template,
  ) async {
    await Navigator.of(context).pushNamed(
      RouteNames.templatePreview,
      arguments: template.id,
    );

    if (context.mounted) {
      context.read<HomeBloc>().add(const HomeEvent.loadTemplates());
    }
  }
}
