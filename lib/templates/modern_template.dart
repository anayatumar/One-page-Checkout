import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/resume.dart';

class ModernTemplate {
  static Future<Uint8List> generate(Resume resume) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 20),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(width: 2, color: PdfColors.blue900)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('${resume.personalInfo.firstName} ${resume.personalInfo.lastName}',
                            style: pw.TextStyle(font: fontBold, fontSize: 24, color: PdfColors.blue900)),
                        pw.Text(resume.title, style: pw.TextStyle(font: font, fontSize: 16)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(resume.personalInfo.email, style: pw.TextStyle(font: font, fontSize: 10)),
                        pw.Text(resume.personalInfo.phone, style: pw.TextStyle(font: font, fontSize: 10)),
                        if (resume.personalInfo.address != null)
                          pw.Text(resume.personalInfo.address!, style: pw.TextStyle(font: font, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Summary
              if (resume.summary != null && resume.summary!.isNotEmpty) ...[
                _buildHeader(fontBold, 'PROFESSIONAL SUMMARY'),
                pw.Text(resume.summary!, style: pw.TextStyle(font: font, fontSize: 11)),
                pw.SizedBox(height: 20),
              ],

              // Experience
              if (resume.experience.isNotEmpty) ...[
                _buildHeader(fontBold, 'WORK EXPERIENCE'),
                ...resume.experience.map((exp) => pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(exp.position, style: pw.TextStyle(font: fontBold, fontSize: 12)),
                            pw.Text('${exp.startDate} - ${exp.isCurrent ? 'Present' : exp.endDate}',
                                style: pw.TextStyle(font: font, fontSize: 10)),
                          ],
                        ),
                        pw.Text(exp.company, style: pw.TextStyle(font: font, fontSize: 11, color: PdfColors.blue800)),
                        if (exp.description != null) ...[
                          pw.SizedBox(height: 4),
                          pw.Text(exp.description!, style: pw.TextStyle(font: font, fontSize: 10)),
                        ],
                        pw.SizedBox(height: 12),
                      ],
                    )),
              ],

              // Education
              if (resume.education.isNotEmpty) ...[
                _buildHeader(fontBold, 'EDUCATION'),
                ...resume.education.map((edu) => pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(edu.degree, style: pw.TextStyle(font: fontBold, fontSize: 12)),
                            pw.Text('${edu.startDate} - ${edu.endDate}', style: pw.TextStyle(font: font, fontSize: 10)),
                          ],
                        ),
                        pw.Text(edu.institution, style: pw.TextStyle(font: font, fontSize: 11, color: PdfColors.blue800)),
                        pw.SizedBox(height: 8),
                      ],
                    )),
              ],

              // Skills
              if (resume.skills.isNotEmpty) ...[
                _buildHeader(fontBold, 'SKILLS'),
                pw.Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  children: resume.skills
                      .map((s) => pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.grey200,
                              borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
                            ),
                            child: pw.Text(s.name, style: pw.TextStyle(font: font, fontSize: 10)),
                          ))
                      .toList(),
                ),
              ],
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(pw.Font fontBold, String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8, top: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          font: fontBold,
          fontSize: 14,
          color: PdfColors.blue900,
        ),
      ),
    );
  }
}
