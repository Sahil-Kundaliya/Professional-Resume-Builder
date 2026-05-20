import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/template_repository_impl.dart';
import '../../data/datasources/template_local_datasource_impl.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import 'home_page_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final datasource = TemplateLocalDatasourceImpl();
        final repository = TemplateRepositoryImpl(datasource);
        final bloc = HomeBloc(repository);
        bloc.add(const HomeEvent.loadTemplates());
        return bloc;
      },
      child: const HomePageView(),
    );
  }
}
