

import 'dart:convert';

import 'package:desktop_app/response_add_to_cart.dart';
import 'package:desktop_app/response_cart_model.dart';
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
        build: (format) => _generatePdf(format, "preview"),
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
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text(title, style: pw.TextStyle(font: font)),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
