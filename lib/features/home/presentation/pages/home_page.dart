import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder/core/config/di/injection_container.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import 'home_page_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = getIt<HomeBloc>();
        bloc.add(const HomeEvent.loadTemplates());
        return bloc;
      },
      child: const HomePageView(),
    );
  }
}
