import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resume_builder/core/config/di/injection_container.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../home/domain/repositories/template_repository.dart';
import '../../../profile/domain/entities/resume_profile.dart';
import '../../domain/entities/resume_creation_choice.dart';
import '../../domain/entities/resume_document.dart';
import '../../domain/entities/resume_template.dart';
import '../../domain/repositories/profile_prefill_repository.dart';
import '../../domain/services/profile_availability_evaluator.dart';
import '../bloc/resume_bloc.dart';
import '../bloc/resume_event.dart';
import '../constants/resume_prefill_flow_labels.dart';
import '../widgets/resume_canvas.dart';

/// Static registry of all available resume templates.
class ResumeTemplatesRegistry {
  ResumeTemplatesRegistry._();

  static final Map<String, ResumeTemplate> _all = {
    'albany': const ResumeTemplate(
      id: 'albany',
      name: 'Albany',
      layout: TemplateLayout.albany,
      accentColor: Color(0xFF2B4A9F),
      headerBgColor: Color(0xFF2B4A9F),
      hasPhoto: true,
      hasSidebar: false,
      isFavorite: false,
    ),
    'amsterdam': const ResumeTemplate(
      id: 'amsterdam',
      name: 'Amsterdam',
      layout: TemplateLayout.amsterdam,
      accentColor: Color(0xFF6C3483),
      headerBgColor: Color(0xFF6C3483),
      hasPhoto: true,
      hasSidebar: true,
      isFavorite: false,
    ),
    'barcelona': const ResumeTemplate(
      id: 'barcelona',
      name: 'Barcelona',
      layout: TemplateLayout.barcelona,
      accentColor: Color(0xFF1A7A4A),
      headerBgColor: Color(0xFF1A7A4A),
      hasPhoto: false,
      hasSidebar: true,
      isFavorite: false,
    ),
    'berlin': const ResumeTemplate(
      id: 'berlin',
      name: 'Berlin',
      layout: TemplateLayout.berlin,
      accentColor: Color(0xFF333333),
      headerBgColor: Color(0xFFEEEEEE),
      hasPhoto: false,
      hasSidebar: false,
      isFavorite: false,
    ),
    'boston': const ResumeTemplate(
      id: 'boston',
      name: 'Boston',
      layout: TemplateLayout.boston,
      accentColor: Color(0xFFB5451B),
      headerBgColor: Color(0xFFB5451B),
      hasPhoto: true,
      hasSidebar: false,
      isFavorite: false,
    ),
    'calgary': const ResumeTemplate(
      id: 'calgary',
      name: 'Calgary',
      layout: TemplateLayout.calgary,
      accentColor: Color(0xFF0E7490),
      headerBgColor: Color(0xFF0E7490),
      hasPhoto: true,
      hasSidebar: true,
      isFavorite: false,
    ),
  };

  static ResumeTemplate? find(String id) => _all[id];
  static List<ResumeTemplate> get all => _all.values.toList();
}

class TemplatePreviewPage extends StatefulWidget {
  const TemplatePreviewPage({super.key});

  @override
  State<TemplatePreviewPage> createState() => _TemplatePreviewPageState();
}

class _TemplatePreviewPageState extends State<TemplatePreviewPage> {
  ResumeTemplate? _template;
  bool _isSubmitting = false;
  bool _isTogglingFavorite = false;
  bool _didLoadTemplate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoadTemplate) {
      _didLoadTemplate = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        _loadTemplate(args);
      }
    }
  }

  Future<void> _loadTemplate(String templateId) async {
    final baseTemplate = ResumeTemplatesRegistry.find(templateId);
    if (baseTemplate == null) {
      return;
    }

    setState(() {
      _template = baseTemplate;
    });

    try {
      final repository = getIt<ITemplateRepository>();
      final favoriteIds = await repository.getFavoriteTemplateIds();
      if (!mounted) {
        return;
      }
      setState(() {
        _template = baseTemplate.copyWith(
          isFavorite: favoriteIds.contains(templateId),
        );
      });
    } catch (_) {
      // Keep the preview available even if persisted favorites cannot be read.
    }
  }

  @override
  Widget build(BuildContext context) {
    final template = _template;

    if (template == null) {
      return const Scaffold(
        body: Center(child: Text('Template not found.')),
      );
    }

    final sampleDoc = ResumeDocument.sampleJohnDoe();

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          template.name,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              template.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: template.isFavorite ? Colors.redAccent : Colors.black87,
            ),
            tooltip: 'Favourite',
            onPressed: _isTogglingFavorite ? null : _toggleFavorite,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ResumeCanvas(
                    document: sampleDoc,
                    template: template,
                    isEditable: false,
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: template.accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  _handleUseTemplate(template);
                },
                child: Text(
                  'Use this template',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleUseTemplate(ResumeTemplate template) async {
    // Prevent duplicate create/navigation when users tap rapidly.
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final resumeBloc = context.read<ResumeBloc>();
    final navigator = Navigator.of(context);

    try {
      final profileRepository = GetIt.instance<IProfilePrefillRepository>();
      final availabilityEvaluator =
          GetIt.instance<ProfileAvailabilityEvaluator>();

      ResumeProfile? profile;
      ResumeCreationChoice? choice = ResumeCreationChoice.createNew;

      try {
        final loadedProfile = await profileRepository.loadProfile();
        final availability = availabilityEvaluator.evaluate(loadedProfile);

        if (availability.hasUsableData) {
          choice = await _showCreationChoiceDialog();
          if (choice == null) {
            return;
          }
          if (choice == ResumeCreationChoice.useProfileData) {
            profile = loadedProfile;
          }
        }
      } catch (_) {
        // Fail-safe behavior: create a blank resume when profile load fails.
        choice = ResumeCreationChoice.createNew;
      }

      resumeBloc.add(
        CreateResume(
          template,
          prefillProfile:
              choice == ResumeCreationChoice.useProfileData ? profile : null,
        ),
      );
      if (mounted) {
        navigator.pushReplacementNamed(AppRoutes.resumeForm);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final template = _template;
    if (template == null || _isTogglingFavorite) {
      return;
    }

    final previous = template;
    final optimistic = previous.copyWith(isFavorite: !previous.isFavorite);
    setState(() {
      _template = optimistic;
      _isTogglingFavorite = true;
    });

    try {
      final repository = getIt<ITemplateRepository>();
      await repository.toggleFavorite(previous.id);
      final favoriteIds = await repository.getFavoriteTemplateIds();

      if (!mounted) {
        return;
      }

      setState(() {
        _template = optimistic.copyWith(
          isFavorite: favoriteIds.contains(previous.id),
        );
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _template = previous;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isTogglingFavorite = false;
        });
      }
    }
  }

  Future<ResumeCreationChoice?> _showCreationChoiceDialog() {
    return showDialog<ResumeCreationChoice>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(ResumePrefillFlowLabels.dialogTitle),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(ResumeCreationChoice.createNew);
              },
              child: const Text(ResumePrefillFlowLabels.createNew),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(ResumeCreationChoice.useProfileData);
              },
              child: const Text(ResumePrefillFlowLabels.useProfileData),
            ),
          ],
        );
      },
    );
  }
}
