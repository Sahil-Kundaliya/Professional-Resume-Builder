import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder/config/routes/route_names.dart';

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
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FilterChip(
                        label: const Text('Favorites Only'),
                        selected: favoritesOnly,
                        onSelected: (value) {
                          context.read<HomeBloc>().add(
                                HomeEvent.favoritesFilterChanged(value),
                              );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: visibleTemplates.isEmpty && favoritesOnly
                        ? const Center(
                            child: Text(
                              'No favorite templates yet. Mark templates with the heart icon to see them here.',
                              textAlign: TextAlign.center,
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
