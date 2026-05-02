import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/resume_provider.dart';
import 'widgets/resume_canvas.dart';
import 'widgets/formatting_toolbar.dart';

class ResumeEditorScreen extends StatefulWidget {
  const ResumeEditorScreen({super.key});

  @override
  State<ResumeEditorScreen> createState() => _ResumeEditorScreenState();
}

class _ResumeEditorScreenState extends State<ResumeEditorScreen> {
  String _selectedFont = 'SansSerif';
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Resume saved!'),
        backgroundColor: Color(0xFF00A86B),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _download() {
    Navigator.pushNamed(context, AppRoutes.pdfPreview);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ResumeProvider>();
    final template = provider.selectedTemplate;

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
            icon: const Icon(Icons.save_outlined, color: Colors.black87),
            onPressed: _save,
            tooltip: 'Save',
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined, color: Colors.black87),
            onPressed: _download,
            tooltip: 'Download PDF',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Scrollable resume canvas ─────────────────────────────────
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Deselect when tapping empty area
                context.read<ResumeProvider>().selectField(null);
              },
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
                    child: Consumer<ResumeProvider>(
                      builder: (context, prov, _) => ResumeCanvas(
                        document: prov.document,
                        template: template,
                        isEditable: true,
                        selectedFieldId: prov.selectedFieldId,
                        onFieldSelected: prov.selectField,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // ── Formatting toolbar ────────────────────────────────────────
          FormattingToolbar(
            isBold: _isBold,
            isItalic: _isItalic,
            isUnderline: _isUnderline,
            selectedFont: _selectedFont,
            onBold: () => setState(() => _isBold = !_isBold),
            onItalic: () => setState(() => _isItalic = !_isItalic),
            onUnderline: () => setState(() => _isUnderline = !_isUnderline),
            onUndo: () {},
            onRedo: () {},
            onFontChanged: (f) => setState(() => _selectedFont = f),
          ),
        ],
      ),
    );
  }
}
