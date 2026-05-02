import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_routes.dart';
import '../../models/resume_document.dart';
import '../../providers/resume_provider.dart';
import '../editor/widgets/resume_canvas.dart';

class TemplatePreviewScreen extends StatelessWidget {
  const TemplatePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ResumeProvider>();
    final template = provider.selectedTemplate;
    final sampleDoc = ResumeDocument.sampleJohnDoe();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Template preview',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
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
          // Bottom action bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            color: Colors.white,
            child: Row(
              children: [
                // Favourite button
                Consumer<ResumeProvider>(
                  builder: (ctx, prov, _) {
                    final isFav = template?.isFavorite ?? false;
                    return GestureDetector(
                      onTap: () {
                        if (template != null) {
                          prov.toggleFavorite(template.id);
                        }
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.editor);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A86B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Use this template',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
