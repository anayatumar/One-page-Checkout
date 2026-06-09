import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/resume.dart';

class ExecutiveTemplate {
  static Future<Uint8List> generate(Resume resume) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.latoRegular();
    final fontBold = await PdfGoogleFonts.latoBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(20),
                decoration: const pw.BoxDecoration(color: PdfColors.blueGrey900),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('${resume.personalInfo.firstName} ${resume.personalInfo.lastName}'.toUpperCase(),
                        style: pw.TextStyle(font: fontBold, fontSize: 26, color: PdfColors.white, letterSpacing: 2)),
                    pw.SizedBox(height: 5),
                    pw.Text(resume.title.toUpperCase(),
                        style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.blueGrey100, letterSpacing: 1.5)),
                  ],
                ),
              ),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(vertical: 10),
                decoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    _buildContactItem(font, resume.personalInfo.email),
                    pw.Padding(padding: const pw.EdgeInsets.symmetric(horizontal: 10), child: pw.Text('|', style: const pw.TextStyle(color: PdfColors.white))),
                    _buildContactItem(font, resume.personalInfo.phone),
                    if (resume.personalInfo.address != null) ...[
                      pw.Padding(padding: const pw.EdgeInsets.symmetric(horizontal: 10), child: pw.Text('|', style: const pw.TextStyle(color: PdfColors.white))),
                      _buildContactItem(font, resume.personalInfo.address!),
                    ],
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(30),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (resume.summary != null && resume.summary!.isNotEmpty) ...[
                      _buildHeader(fontBold, 'EXECUTIVE SUMMARY'),
                      pw.Text(resume.summary!, style: pw.TextStyle(font: font, fontSize: 11, color: PdfColors.grey900), textAlign: pw.TextAlign.justify),
                      pw.SizedBox(height: 25),
                    ],

                    if (resume.experience.isNotEmpty) ...[
                      _buildHeader(fontBold, 'PROFESSIONAL EXPERIENCE'),
                      ...resume.experience.map((exp) => pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text(exp.position, style: pw.TextStyle(font: fontBold, fontSize: 13, color: PdfColors.blueGrey800)),
                                  pw.Text('${exp.startDate} - ${exp.isCurrent ? 'PRESENT' : exp.endDate?.toUpperCase()}',
                                      style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey700)),
                                ],
                              ),
                              pw.Text(exp.company.toUpperCase(), style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.blueGrey700)),
                              if (exp.description != null) ...[
                                pw.SizedBox(height: 6),
                                pw.Text(exp.description!, style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey800)),
                              ],
                              pw.SizedBox(height: 15),
                            ],
                          )),
                    ],

                    if (resume.education.isNotEmpty) ...[
                      _buildHeader(fontBold, 'EDUCATION'),
                      ...resume.education.map((edu) => pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text(edu.degree, style: pw.TextStyle(font: fontBold, fontSize: 12, color: PdfColors.blueGrey800)),
                                  pw.Text('${edu.startDate} - ${edu.endDate}', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey700)),
                                ],
                              ),
                              pw.Text(edu.institution, style: pw.TextStyle(font: font, fontSize: 11, color: PdfColors.blueGrey700)),
                              pw.SizedBox(height: 10),
                            ],
                          )),
                    ],

                    if (resume.skills.isNotEmpty) ...[
                      _buildHeader(fontBold, 'CORE COMPETENCIES'),
                      pw.Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        children: resume.skills.map((s) => pw.Row(
                          mainAxisSize: pw.MainAxisSize.min,
                          children: [
                            pw.Container(width: 5, height: 5, decoration: const pw.BoxDecoration(color: PdfColors.blueGrey800, shape: pw.BoxShape.circle)),
                            pw.SizedBox(width: 8),
                            pw.Text(s.name, style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey900)),
                          ],
                        )).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildContactItem(pw.Font font, String text) {
    return pw.Text(text, style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.white));
  }

  static pw.Widget _buildHeader(pw.Font fontBold, String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.blueGrey900, letterSpacing: 1.5)),
        pw.SizedBox(height: 4),
        pw.Container(width: double.infinity, height: 1, color: PdfColors.blueGrey200),
        pw.SizedBox(height: 12),
      ],
    );
  }
}
