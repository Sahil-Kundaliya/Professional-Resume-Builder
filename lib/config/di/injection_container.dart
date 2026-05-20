import 'package:get_it/get_it.dart';
import '../../features/home/home_injection.dart' as home_injection;
import '../../features/resume/resume_injection.dart' as resume_injection;

final getIt = GetIt.instance;

void setupDependencies() {
  home_injection.setupHomeFeature();
  resume_injection.setupResumeFeature();
}
