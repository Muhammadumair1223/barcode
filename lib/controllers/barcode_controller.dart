import 'package:barcodeinventory/controllers/blutooth_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'base_controller.dart';

class BarcodeController extends BaseController {
  final quantityController = TextEditingController();
  bool loadng = false;

  updateLoading(bool value) {
    loadng = value;
    notifyListeners();
  }

  Uint8List? _generatedPDFBytes;
  Uint8List? get generatedPDFBytes => _generatedPDFBytes;

  String _productName = "";
  String get productName => _productName;

  int productId = 0;
  double productPrice = 0.0;

  BarcodeController(super.repository, super.sharedPreferences);

  void clearData() {
    _productName = "";
    productId = 0;
    productPrice = 0.0;
    notifyListeners();
  }

  Future<pw.Image> _getImageFromAsset(String assetName) async {
    final ByteData data = await rootBundle.load(assetName);
    final Uint8List bytes = data.buffer.asUint8List();
    return pw.Image(pw.MemoryImage(bytes));
  }

  Future<void> generatePDF(
      int quantity, String upc, String name, String price) async {
//     final pdf = pw.Document();
// // Load the asset image
//     // final netImage = await networkImage('https://www.nfet.net/nfet.jpg');
//     // final pw.Image image =
//     //     await _getImageFromAsset('assets/image/barCodeLogo.png');

//     final font = await PdfGoogleFonts.nunitoExtraLight();

//     for (int i = 0; i < quantity; i++) {
//       pdf.addPage(
//         pw.Page(
//           pageFormat: PdfPageFormat(250, 200),
//           build: (pw.Context context) {
//             return pw.Center(
//               child: pw.Column(
//                 mainAxisSize: pw.MainAxisSize.min,
//                 mainAxisAlignment: pw.MainAxisAlignment.center,
//                 crossAxisAlignment: pw.CrossAxisAlignment.center,
//                 children: [
//                   // pw.Text(
//                   //   name,
//                   //   style: pw.TextStyle(
//                   //       font: font,
//                   //       fontSize: 12,
//                   //       fontWeight: pw.FontWeight.bold),
//                   // ),
//                   // pw.SizedBox(height: 25),
//                   pw.Row(children: [
//                     // pw.Container(
//                     //   width: 240,
//                     //   child: image,
//                     // ),
//                     // pw.SizedBox(width: 10),
//                     pw.Column(
//                         mainAxisAlignment: pw.MainAxisAlignment.end,
//                         children: [
//                           pw.BarcodeWidget(
//                             barcode: pw.Barcode.upcA(),
//                             data: upc,
//                             width: 240,
//                             height: 60,
//                             textStyle: pw.TextStyle(font: font),
//                           ),
//                           pw.SizedBox(height: 10),
//                           pw.Container(
//                             width: 240,
//                             height: 80,
//                             decoration: pw.BoxDecoration(
//                                 color: PdfColor.fromHex('FF0000'),
//                                 borderRadius: const pw.BorderRadius.only(
//                                     bottomRight: pw.Radius.circular(20))),
//                             child: pw.Center(
//                                 child: pw.Text(
//                               "\$ $price",
//                               textAlign: pw.TextAlign.center,
//                               style: pw.TextStyle(
//                                   font: font,
//                                   fontSize: 38,
//                                   fontWeight: pw.FontWeight.bold),
//                             )),
//                           ),
//                         ]),
//                   ]),
//                 ],
//               ),
//             );
//           },
//         ),
//       );
//     }

//     _generatedPDFBytes = await pdf.save();

    notifyListeners();
  }

  Future<void> printPDF(BuildContext context) async {
    PdfPrinter printer = PdfPrinter();
    if (_generatedPDFBytes != null) {
      //await Printing.layoutPdf(onLayout: (format) async => _generatedPDFBytes!);
      await printer.printText(_generatedPDFBytes!, context);
    }
  }
}
