import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import '../../../../core/utils/pdf_generator.dart';
import '../bloc/resume_bloc.dart';

class PdfPreviewPage extends StatelessWidget {
  const PdfPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<ResumeBloc>().state;
    final loaded = state.mapOrNull(loaded: (value) => value);

    if (loaded == null) {
      return const Scaffold(
        body: Center(child: Text('No resume loaded.')),
      );
    }

    if (!loaded.canPreview) {
      return Scaffold(
        appBar: AppBar(title: const Text('PDF Preview')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Preview is not available yet.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Please complete the required fields in the form before opening preview.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to form'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final document = loaded.document;
    final template = loaded.template;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'PDF Preview',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87),
            tooltip: 'Share PDF',
            onPressed: () async {
              final bytes = await PdfGenerator.generate(template, document);
              await Printing.sharePdf(
                bytes: bytes,
                filename: 'resume.pdf',
              );
            },
          ),
        ],
      ),
      body: PdfPreview(
        build: (_) => PdfGenerator.generate(template, document),
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
      ),
    );
  }
}
