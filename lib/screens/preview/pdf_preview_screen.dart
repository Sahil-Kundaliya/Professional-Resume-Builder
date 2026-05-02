import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../../core/utils/pdf_generator.dart';
import '../../providers/resume_provider.dart';

class PdfPreviewScreen extends StatefulWidget {
  const PdfPreviewScreen({super.key});

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  Uint8List? _pdfBytes;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _generate());
  }

  Future<void> _generate() async {
    setState(() { _loading = true; _error = null; });
    try {
      final provider = context.read<ResumeProvider>();
      final bytes = await PdfGenerator.generate(
        provider.selectedTemplate,
        provider.document,
      );
      if (mounted) setState(() { _pdfBytes = bytes; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _download() async {
    if (_pdfBytes == null) return;
    await Printing.sharePdf(bytes: _pdfBytes!, filename: 'resume.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Preview', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        centerTitle: false,
        actions: [
          if (_pdfBytes != null)
            IconButton(
              icon: const Icon(Icons.download_outlined),
              onPressed: _download,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00A86B)))
          : _error != null
              ? Center(child: Text(_error!))
              : PdfPreview(
                  build: (_) async => _pdfBytes!,
                  allowPrinting: true,
                  allowSharing: true,
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  canDebug: false,
                ),
      bottomNavigationBar: _pdfBytes != null
          ? Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              color: Colors.white,
              child: ElevatedButton.icon(
                onPressed: _download,
                icon: const Icon(Icons.download_rounded),
                label: Text(
                  'Download PDF',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A86B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            )
          : null,
    );
  }
}
