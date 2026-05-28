import 'package:pdf/widgets.dart' as pw;

import 'pdf_section_context.dart';

typedef PdfSectionBuilderCallback = pw.Widget? Function(
  PdfSectionContext context,
);

class RegisteredPdfSectionBuilder {
  const RegisteredPdfSectionBuilder({
    required this.sectionKey,
    required this.build,
  });

  final String sectionKey;
  final PdfSectionBuilderCallback build;
}
