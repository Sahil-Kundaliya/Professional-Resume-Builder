import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder/config/routes/route_names.dart';
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
            loaded: (templates) {
              if (templates.isEmpty) {
                return const Center(
                  child: Text('No templates available'),
                );
              }
              return TemplateGrid(
                templates: templates,
                onTemplateSelected: (template) {
                  Navigator.of(context).pushNamed(
                    RouteNames.templatePreview,
                    arguments: template.id,
                  );
                },
                onFavoriteToggled: (templateId) {
                  context.read<HomeBloc>().add(
                        HomeEvent.toggleFavorite(templateId),
                      );
                },
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
}
