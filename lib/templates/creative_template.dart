import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/resume.dart';

class CreativeTemplate {
  static Future<Uint8List> generate(Resume resume) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.poppinsRegular();
    final fontBold = await PdfGoogleFonts.poppinsBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return [
            pw.FullPage(
              ignoreMargins: true,
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  // Left Column (Sidebar)
                  pw.Container(
                    width: 200,
                    color: PdfColor.fromHex('#2D3436'),
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 40),
                        pw.Text('${resume.personalInfo.firstName}\n${resume.personalInfo.lastName}'.toUpperCase(),
                            style: pw.TextStyle(font: fontBold, fontSize: 24, color: PdfColors.white)),
                        pw.SizedBox(height: 10),
                        pw.Text(resume.title, style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.blue200)),
                        pw.SizedBox(height: 40),
                        _buildSidebarHeader(fontBold, 'CONTACT'),
                        _buildSidebarItem(font, resume.personalInfo.email),
                        _buildSidebarItem(font, resume.personalInfo.phone),
                        if (resume.personalInfo.address != null)
                          _buildSidebarItem(font, resume.personalInfo.address!),
                        pw.SizedBox(height: 30),
                        _buildSidebarHeader(fontBold, 'SKILLS'),
                        ...resume.skills.map((s) => pw.Padding(
                              padding: const pw.EdgeInsets.only(bottom: 8),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(s.name, style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.white)),
                                  pw.SizedBox(height: 2),
                                  pw.LinearProgressIndicator(
                                    value: s.level,
                                    backgroundColor: PdfColors.grey700,
                                    // color: PdfColors.blue300, // LinearProgressIndicator in pdf package doesn't have color param in some versions
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  // Right Column (Main Content)
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(40),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          if (resume.summary != null && resume.summary!.isNotEmpty) ...[
                            _buildMainHeader(fontBold, 'ABOUT ME'),
                            pw.Text(resume.summary!, style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey800)),
                            pw.SizedBox(height: 30),
                          ],
                          if (resume.experience.isNotEmpty) ...[
                            _buildMainHeader(fontBold, 'EXPERIENCE'),
                            ...resume.experience.map((exp) => pw.Padding(
                                  padding: const pw.EdgeInsets.only(bottom: 20),
                                  child: pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Row(
                                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text(exp.position, style: pw.TextStyle(font: fontBold, fontSize: 12)),
                                          pw.Text('${exp.startDate} - ${exp.isCurrent ? 'Present' : exp.endDate}',
                                              style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600)),
                                        ],
                                      ),
                                      pw.Text(exp.company, style: pw.TextStyle(font: font, fontSize: 11, color: PdfColors.blue900)),
                                      if (exp.description != null) ...[
                                        pw.SizedBox(height: 6),
                                        pw.Text(exp.description!,
                                            style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey700)),
                                      ],
                                    ],
                                  ),
                                )),
                          ],
                          if (resume.education.isNotEmpty) ...[
                            _buildMainHeader(fontBold, 'EDUCATION'),
                            ...resume.education.map((edu) => pw.Padding(
                                  padding: const pw.EdgeInsets.only(bottom: 15),
                                  child: pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(edu.degree, style: pw.TextStyle(font: fontBold, fontSize: 11)),
                                      pw.Text(edu.institution, style: pw.TextStyle(font: font, fontSize: 10)),
                                      pw.Text('${edu.startDate} - ${edu.endDate}',
                                          style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600)),
                                    ],
                                  ),
                                )),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildSidebarHeader(pw.Font fontBold, String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(font: fontBold, fontSize: 12, color: PdfColors.blue300, letterSpacing: 1.5)),
          pw.Container(width: 30, height: 2, color: PdfColors.blue300, margin: const pw.EdgeInsets.only(top: 4)),
        ],
      ),
    );
  }

  static pw.Widget _buildSidebarItem(pw.Font font, String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey300)),
    );
  }

  static pw.Widget _buildMainHeader(pw.Font fontBold, String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 15),
      child: pw.Row(
        children: [
          pw.Text(title, style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.blue900, letterSpacing: 1.2)),
          pw.SizedBox(width: 10),
          pw.Expanded(child: pw.Divider(color: PdfColors.grey300, thickness: 1)),
        ],
      ),
    );
  }
}
