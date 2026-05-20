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
  String _selectedFont = 'SansSerif';
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResumeBloc, ResumeState>(
      builder: (context, state) {
        return state.whenOrNull(
              loaded: (document, selectedFieldId, template) {
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
                        icon: const Icon(Icons.save_outlined,
                            color: Colors.black87),
                        onPressed: () {
                          context.read<ResumeBloc>().add(const SaveResume());
                        },
                        tooltip: 'Save',
                      ),
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
                          onTap: () {
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
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FormattingToolbar(
                        isBold: _isBold,
                        isItalic: _isItalic,
                        isUnderline: _isUnderline,
                        selectedFont: _selectedFont,
                        onBold: () => setState(() => _isBold = !_isBold),
                        onItalic: () => setState(() => _isItalic = !_isItalic),
                        onUnderline: () =>
                            setState(() => _isUnderline = !_isUnderline),
                        onUndo: () {},
                        onRedo: () {},
                        onFontChanged: (f) => setState(() => _selectedFont = f),
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
