import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MatchReportGenerator {
  Future<Uint8List> generateReport(
    String homeTeam,
    String awayTeam,
    int scoreHome,
    int scoreAway,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  "Official Match Report",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Game Summary", style: pw.TextStyle(fontSize: 18)),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(homeTeam, style: pw.TextStyle(fontSize: 16)),
                  pw.Text(
                    "$scoreHome - $scoreAway",
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(awayTeam, style: pw.TextStyle(fontSize: 16)),
                ],
              ),
              pw.SizedBox(height: 40),
              pw.Text("Detailed Events", style: pw.TextStyle(fontSize: 18)),
              pw.Divider(),
              pw.TableHelper.fromTextArray(
                context: context,
                data: const <List<String>>[
                  <String>['Quarter', 'Time', 'Player', 'Event'],
                  <String>['Q1', '14:30', 'J. Doe', 'Goal'],
                  <String>['Q1', '12:15', 'A. Smith', 'Intercept'],
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // Example UI triggered method:
  // Future<void> shareReport() async {
  //   final bytes = await generateReport('Vipers', 'Swifts', 45, 42);
  //   await Printing.sharePdf(bytes: bytes, filename: 'match_report.pdf');
  // }
}
