import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/pdf_generator.dart';
import '../bloc/resume_bloc.dart';
import '../bloc/resume_state.dart';

class PdfPreviewPage extends StatelessWidget {
  const PdfPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<ResumeBloc>().state;
    final loaded =
        state.whenOrNull(loaded: (doc, _, template) => (doc, template));

    if (loaded == null) {
      return const Scaffold(
        body: Center(child: Text('No resume loaded.')),
      );
    }

    final (document, template) = loaded;

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
