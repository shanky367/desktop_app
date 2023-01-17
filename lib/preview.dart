import 'dart:convert';

import 'package:desktop_app/response_add_to_cart.dart';
import 'package:desktop_app/response_cart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfPreview11 extends StatefulWidget {
  static const String id = 'preview';

  const PdfPreview11({Key? key}) : super(key: key);

  @override
  _PdfPreview11State createState() => _PdfPreview11State();
}

class _PdfPreview11State extends State<PdfPreview11> {
  static const _defaultPageFormats = <String, PdfPageFormat>{
    'A4': PdfPageFormat.a4,
    //'Letter': PdfPageFormat.letter,
    // 'Roll80': PdfPageFormat.roll80,
    // 'Roll57': PdfPageFormat.roll57,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter PDF Demo'),
        // bottom: TabBar(
        //   controller: _tabController,
        //   tabs: examples.map<Tab>((e) => Tab(text: e.name)).toList(),
        //   isScrollable: true,
        // ),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        canDebug: false,
        dynamicLayout: true,
        canChangeOrientation: false,
        canChangePageFormat: false,
        allowSharing: false,
        allowPrinting: true,
        build: (format) => _generateTablePdf(format, "Tax Invoice(Original)"),
        pageFormats: _defaultPageFormats,
        //actions: actions,
        // onPrinted: _showPrintedToast,
        // onShared: _showSharedToast,
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.deepOrange,
      //   onPressed: _showSources,
      //   child: const Icon(Icons.code),
      // ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final fontExtraLight = await PdfGoogleFonts.nunitoExtraLight();
    final fontRegular = await PdfGoogleFonts.numansRegular();
    final fontMediumItalic = await PdfGoogleFonts.nunitoMediumItalic();
    final fontMedium = await PdfGoogleFonts.nunitoMedium();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.Center(
                child: pw.Text(title,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Row( mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                pw.Expanded(
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Invoice No.:",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 10),
                            pw.Text("IN003/23/00017308",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.normal)),
                          ]),
                          pw.SizedBox(height: 10),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Invoice Date:",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 10),
                            pw.Text("08-Dec-2023 \n21:39:03",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.normal)),
                          ]),
                          pw.SizedBox(height: 10),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Payment Mode:",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 10),
                            pw.Text("WALLET",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.normal)),
                          ]),
                    ])),
                pw.Expanded(
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Reference\nNo.:",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(height: 10),
                                pw.Text("10784832",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal)),
                              ]),
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Order Date:",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(height: 10),
                                pw.Text("08-Dec-2023",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal)),
                              ]),

                        ])),
                pw.Expanded(
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,                        children: [
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Order Number.:",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(height: 10),
                                pw.Text("31413413434234",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal)),
                              ]),
                          pw.SizedBox(height: 10),



                        ])),
                pw.Expanded(
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                      pw.Text("IBO",
                          style: pw.TextStyle(
                              color: PdfColors.red,
                              fontSize: 38,
                              fontWeight: pw.FontWeight.bold))
                    ])),
              ])
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
  Future<Uint8List> _generateTablePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final fontExtraLight = await PdfGoogleFonts.nunitoExtraLight();
    final fontRegular = await PdfGoogleFonts.numansRegular();
    final fontMediumItalic = await PdfGoogleFonts.nunitoMediumItalic();
    final fontMedium = await PdfGoogleFonts.nunitoMedium();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: const <int, pw.TableColumnWidth>{
                0: pw.IntrinsicColumnWidth(),
                1: pw.FlexColumnWidth(),
                2: pw.FixedColumnWidth(64),
              },
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: <pw.TableRow>[
                pw.TableRow(
                  children: < pw.Widget>[
                    pw. Container(
                      color: PdfColors.blue
                    ),
                  ],
                ),
                pw.TableRow(
                  children: < pw.Widget>[
                    pw. Container(
                        color: PdfColors.blue
                    ),
                  ],
                ),
                pw.TableRow(
                  children: < pw.Widget>[
                    pw. Container(
                        color: PdfColors.blue
                    ),
                  ],
                ),
              ],
            );
        },
      ),
    );

    return pdf.save();
  }
}
