import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'core/config/di/injection_container.dart';
import 'features/resume/presentation/bloc/resume_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(
    BlocProvider(
      create: (_) => getIt<ResumeBloc>(),
      child: const ResumeBuilderApp(),
    ),
  );
}
