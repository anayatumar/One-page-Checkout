import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/resume.dart';

class ClassicTemplate {
  static Future<Uint8List> generate(Resume resume) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.merriweatherRegular();
    final fontBold = await PdfGoogleFonts.merriweatherBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header
              pw.Text('${resume.personalInfo.firstName} ${resume.personalInfo.lastName}'.toUpperCase(),
                  style: pw.TextStyle(font: fontBold, fontSize: 20)),
              pw.SizedBox(height: 4),
              pw.Text('${resume.personalInfo.address ?? ''} | ${resume.personalInfo.phone} | ${resume.personalInfo.email}',
                  style: pw.TextStyle(font: font, fontSize: 10)),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 10),

              // Summary
              if (resume.summary != null && resume.summary!.isNotEmpty) ...[
                _buildHeader(fontBold, 'PROFESSIONAL SUMMARY'),
                pw.Text(resume.summary!, style: pw.TextStyle(font: font, fontSize: 11), textAlign: pw.TextAlign.justify),
                pw.SizedBox(height: 15),
              ],

              // Experience
              if (resume.experience.isNotEmpty) ...[
                _buildHeader(fontBold, 'EXPERIENCE'),
                ...resume.experience.map((exp) => pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(exp.company, style: pw.TextStyle(font: fontBold, fontSize: 11)),
                            pw.Text('${exp.startDate} - ${exp.isCurrent ? 'Present' : exp.endDate}',
                                style: pw.TextStyle(font: font, fontSize: 10)),
                          ],
                        ),
                        pw.Text(exp.position, style: pw.TextStyle(font: font, fontSize: 11, fontStyle: pw.FontStyle.italic)),
                        if (exp.description != null) ...[
                          pw.SizedBox(height: 4),
                          pw.Text(exp.description!, style: pw.TextStyle(font: font, fontSize: 10)),
                        ],
                        pw.SizedBox(height: 10),
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
                            pw.Text(edu.institution, style: pw.TextStyle(font: fontBold, fontSize: 11)),
                            pw.Text('${edu.startDate} - ${edu.endDate}', style: pw.TextStyle(font: font, fontSize: 10)),
                          ],
                        ),
                        pw.Text(edu.degree, style: pw.TextStyle(font: font, fontSize: 11)),
                        pw.SizedBox(height: 8),
                      ],
                    )),
              ],

              // Skills
              if (resume.skills.isNotEmpty) ...[
                _buildHeader(fontBold, 'SKILLS'),
                pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text(
                    resume.skills.map((s) => s.name).join(', '),
                    style: pw.TextStyle(font: font, fontSize: 11),
                  ),
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
      width: double.infinity,
      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      margin: const pw.EdgeInsets.only(bottom: 8, top: 4),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          font: fontBold,
          fontSize: 12,
        ),
      ),
    );
  }
}
