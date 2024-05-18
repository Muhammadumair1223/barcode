// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcodeinventory/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import '../controllers/barcode_controller.dart';
import '../controllers/blutooth_status.dart';
import '../utils/color_resources.dart';
import '../utils/dimensions.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_drawer.dart';

class BarCodeGenerateScreen extends StatefulWidget {
  const BarCodeGenerateScreen({super.key});

  @override
  State<BarCodeGenerateScreen> createState() => _BarCodeGenerateScreenState();
}

class _BarCodeGenerateScreenState extends State<BarCodeGenerateScreen> {
  PdfPrinter printer = PdfPrinter();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();

    initialze();
  }

  Future<void> initialze() async {
    await PdfPrinter().initBluetooth();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BarcodeController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Generator'),
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              controller: controller.upcController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                hintText: "Now Press Image and scan Product",
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                labelText: 'Scan Product',
                prefixIcon: IconButton(
                  color: Colors.teal,
                  onPressed: controller.clearData,
                  icon: const Icon(Icons.clear),
                ),
                suffixIcon: IconButton(
                  color: Colors.teal,
                  onPressed: () =>
                      controller.searchProduct(controller.upcController.text),
                  icon: const Icon(Icons.search),
                ),
              ),
              onFieldSubmitted: controller.searchProduct,
            ),
            const SizedBox(height: 20),
            Text("Product: ${controller.productName}"),
            const SizedBox(height: 20),
            TextFormField(
              controller: controller.quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: Dimensions.fontSizeSmall),
                Expanded(
                  child: CustomButtonWidget(
                      buttonText:
                          controller.loadng ? 'Generating..' : 'Generate',
                      onPressed: () async {
                        // print(controller.upcController.text);

                        // print(product!.price.toString());
                        // print(product!.name.toString());
                        FocusScope.of(context).unfocus();
                        if (controller.quantityController.text == '') {
                          showSnackBarMessage(context, "Add Quantity");
                        } else {
                          controller.updateLoading(true);
                          Product? product = await controller
                              .searchProduct(controller.upcController.text);

                          if (product == null) {
                            showMessageDialog(context, 'Product not Available');
                          } else {
                            int quantity = int.parse(
                                "0${controller.quantityController.text}");
                            String upc = controller.upcController.text;
                            if (quantity > 0 && upc.isNotEmpty) {
                              await controller.generatePDF(
                                quantity,
                                upc,
                                product.name,
                                product.price.toString(),
                              );
                            }
                          }
                        }
                        controller.updateLoading(false);
                      }),
                ),
                const SizedBox(width: Dimensions.fontSizeSmall),
                Expanded(
                  child: CustomButtonWidget(
                    buttonText: 'Print',
                    // onPressed: () => controller.printPDF(context),
                    onPressed: () async {
                      final directory =
                          await getApplicationDocumentsDirectory();
                      final String path = directory.path;
                      String fileName =
                          DateTime.now().microsecondsSinceEpoch.toString();
                      // var image =
                      //     await screenshotController.capture(pixelRatio: 1.3);
                      await screenshotController.captureAndSave(
                        '$path/$fileName.jpg', // Set the path where the screenshot will be saved
                        pixelRatio: 1.3,
                        delay: Duration(seconds: 1),
                      );
                      printer.printText('$path/$fileName.jpg', context);
                    },
                    buttonColor: ColorResources.colorPrint,
                  ),
                ),
                const SizedBox(width: Dimensions.fontSizeSmall),
                Expanded(
                  child: CustomButtonWidget(
                    buttonText: 'Reset',
                    onPressed: () {},
                    buttonColor: ColorResources.getResetColor(),
                    textColor: ColorResources.getTextColor(),
                    isClear: true,
                  ),
                ),
                const SizedBox(width: Dimensions.fontSizeSmall),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Center(
              child: Screenshot(
                controller: screenshotController,
                child: Container(
                  width: 100,
                  child: Column(
                    children: [
                      BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: 'Hello Flutter',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // if (controller.generatedPDFBytes != null)
            //   Expanded(
            //     child: Screenshot(
            //       controller: screenshotController,
            //       child: Center(
            //         child: Text('Random Barcode'),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}

Future<void> showMessageDialog(context, String message) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Inventory Info'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showSnackBarMessage(BuildContext context, String message) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    ),
  );
}
