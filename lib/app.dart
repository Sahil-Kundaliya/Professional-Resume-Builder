import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_routes.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/resume/presentation/pages/template_preview_page.dart';
import 'features/resume/presentation/pages/resume_editor_page.dart';
import 'features/resume/presentation/pages/pdf_preview_page.dart';

class ResumeBuilderApp extends StatelessWidget {
  const ResumeBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV Maker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00A86B)),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
      ),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => const HomePage(),
        AppRoutes.templatePreview: (_) => const TemplatePreviewPage(),
        AppRoutes.editor: (_) => const ResumeEditorPage(),
        AppRoutes.pdfPreview: (_) => const PdfPreviewPage(),
      },
    );
  }
}
