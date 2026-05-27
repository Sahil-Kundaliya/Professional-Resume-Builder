import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_routes.dart';
import '../bloc/resume_bloc.dart';
import '../bloc/resume_event.dart';
import '../bloc/resume_state.dart';
import '../widgets/resume_canvas.dart';
import '../widgets/formatting_toolbar.dart';

class ResumeEditorPage extends StatefulWidget {
  const ResumeEditorPage({super.key});

  @override
  State<ResumeEditorPage> createState() => _ResumeEditorPageState();
}

class _ResumeEditorPageState extends State<ResumeEditorPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResumeBloc, ResumeState>(
      builder: (context, state) {
        return state.whenOrNull(
              loaded:
                  (document, selectedFieldId, undoStack, redoStack, template) {
                final selectedStyle = document.styleForFieldId(selectedFieldId);
                final isFormattingEnabled =
                    ResumeCanvasFieldIds.supportsFormatting(selectedFieldId);
                final selectedTextSize = (selectedStyle.fontSize ??
                        document.baseFontSizeForFieldId(selectedFieldId))
                    .toDouble();

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
                      'Edit resume',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    centerTitle: false,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.download_outlined,
                            color: Colors.black87),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.pdfPreview);
                        },
                        tooltip: 'Download PDF',
                      ),
                    ],
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            context
                                .read<ResumeBloc>()
                                .add(const SelectField(null));
                          },
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 12,
                            ),
                            child: Center(
                              child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
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
                                  document: document,
                                  template: template,
                                  isEditable: true,
                                  selectedFieldId: selectedFieldId,
                                  onFieldSelected: (fieldId) {
                                    context
                                        .read<ResumeBloc>()
                                        .add(SelectField(fieldId));
                                  },
                                  onDocumentChanged: (updated) {
                                    context
                                        .read<ResumeBloc>()
                                        .add(UpdateDocument(updated));
                                  },
                                  onActionFeedback: (message) {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(content: Text(message)),
                                      );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FormattingToolbar(
                        isBold: selectedStyle.isBold,
                        isItalic: selectedStyle.isItalic,
                        isUnderline: selectedStyle.isUnderline,
                        selectedTextSize: selectedTextSize,
                        selectedFont: selectedStyle.fontFamily,
                        selectedColorValue: selectedStyle.textColorValue,
                        isEnabled: isFormattingEnabled,
                        canUndo: undoStack.isNotEmpty,
                        canRedo: redoStack.isNotEmpty,
                        onBold: () => context
                            .read<ResumeBloc>()
                            .add(const ToggleSelectedBold()),
                        onItalic: () => context
                            .read<ResumeBloc>()
                            .add(const ToggleSelectedItalic()),
                        onUnderline: () => context
                            .read<ResumeBloc>()
                            .add(const ToggleSelectedUnderline()),
                        onIncreaseTextSize: () => context
                            .read<ResumeBloc>()
                            .add(const IncreaseSelectedTextSize()),
                        onDecreaseTextSize: () => context
                            .read<ResumeBloc>()
                            .add(const DecreaseSelectedTextSize()),
                        onUndo: () => context
                            .read<ResumeBloc>()
                            .add(const UndoHeaderEdit()),
                        onRedo: () => context
                            .read<ResumeBloc>()
                            .add(const RedoHeaderEdit()),
                        onFontChanged: (fontFamily) => context
                            .read<ResumeBloc>()
                            .add(ChangeSelectedFontFamily(fontFamily)),
                        onTextColorChanged: (textColorValue) => context
                            .read<ResumeBloc>()
                            .add(ChangeSelectedTextColor(textColorValue)),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
              error: (message) => Scaffold(
                body: Center(child: Text('Error: $message')),
              ),
            ) ??
            const Scaffold();
      },
    );
  }
}
