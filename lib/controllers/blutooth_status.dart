// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:barcodeinventory/utils/global_context_key.dart';
import 'package:barcodeinventory/widgets/app_snakbar.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf_image_renderer/pdf_image_renderer.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfPrinter {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  Future<void> printText(
      Uint8List generatedPDFBytes, BuildContext context) async {
    try {
      // // final pdf = pw.Document();
      // // pdf.addPage(pw.Page(
      // //   build: (pw.Context context) {
      // //     return pw.Image(pw.MemoryImage(generatedPDFBytes));
      // //   },
      // // ));
      // final output = await getTemporaryDirectory();
      // final file = File('${output.path}/example.pdf');
      // await file.writeAsBytes(generatedPDFBytes);

      // // Initialize the renderer
      // final pdf = PdfImageRendererPdf(path: file.path);

      // // open the pdf document
      // await pdf.open();

      // // open a page from the pdf document using the page index
      // await pdf.openPage(pageIndex: 0);

      // // get the render size after the page is loaded
      // final size = await pdf.getPageSize(pageIndex: 0);

      // //
      // // // get the actual image of the page
      // // Reduce the scale for smaller image size
      // final img = await pdf.renderPage(
      //   pageIndex: 0,
      //   x: 0,
      //   y: 0,
      //   width: size.width,
      //   // you can pass a custom size here to crop the image
      //   height: size.height,
      //   // you can pass a custom size here to crop the image
      //   scale: 1,
      //   // increase the scale for better quality (e.g. for zooming)
      //   background: Colors.white,
      // );
      // if (img == null) throw ();
      // // close the page again
      // await pdf.closePage(pageIndex: 0);

      // // close the PDF after rendering the page
      // await pdf.close();

      // final imgFile = File('${output.path}/example.jpg');
      // // await imgFile.writeAsBytes(img);
      // await imgFile.writeAsBytes(
      //     img.buffer.asUint8List(img.offsetInBytes, img.lengthInBytes));
      // final imageProvider = Image.file(imgFile);
      // // await showImageViewer(context, imageProvider.image,
      // //     onViewerDismissed: () {});

      // // final imgFile2 = await _getImageFromAsset('assets/image/barCodeLogo2.png');

      // await bluetooth.printImage(imgFile.path);
      await bluetooth.printImageBytes(generatedPDFBytes);
    } catch (e) {
      debugPrint('Error printing PDF: $e');
      snaki(msg: 'PrintError: $e');
    }
  }

  Future<Uint8List> _getImageFromAsset(String assetName) async {
    final ByteData data = await rootBundle.load(assetName);
    final Uint8List bytes = data.buffer.asUint8List();
    // return pw.Image(pw.MemoryImage(bytes));
    return bytes;
  }

  Future<void> initBluetooth() async {
    PermissionStatus status = await Permission.bluetooth.request();

    if (status != PermissionStatus.granted) {
      debugPrint('Bluetooth permission not granted');
      return;
    }

    bool? isAvailable = await bluetooth.isOn;
    if (isAvailable == null || !isAvailable) {
      debugPrint('Bluetooth is not available');
      return;
    }

    bool? isConnected = await bluetooth.isConnected;
    if (isConnected == null || !isConnected) {
      debugPrint('Bluetooth is not connected, attempting to connect...');
      try {
        List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
        if (devices.isNotEmpty) {
          BluetoothDevice? connectedDevice = await showDialog(
            context: navigatorKey.currentState!.overlay!
                .context, // Assuming context is valid here
            builder: (BuildContext context) {
              return BluetoothDeviceSelectionDialog(devices: devices);
            },
          );
          if (connectedDevice != null) {
            await bluetooth.connect(connectedDevice);

            debugPrint(
                'Bluetooth connected successfully to ${connectedDevice.name}');
          } else {
            debugPrint('Failed to connect to Bluetooth device');
          }
        } else {
          debugPrint('No bonded Bluetooth devices found');
          snaki(msg: "No bonded Bluetooth devices found");
        }
      } catch (e) {
        debugPrint('Failed to connect to Bluetooth: $e');
        return;
      }
    }
  }
}

class BluetoothDeviceSelectionDialog extends StatefulWidget {
  final List<BluetoothDevice> devices;

  BluetoothDeviceSelectionDialog({required this.devices});

  @override
  State<BluetoothDeviceSelectionDialog> createState() =>
      _BluetoothDeviceSelectionDialogState();
}

class _BluetoothDeviceSelectionDialogState
    extends State<BluetoothDeviceSelectionDialog> {
  int? selectedDeviceIndex;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a device'),
      content: SizedBox(
        // height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < widget.devices.length; i++) ...{
              ListTile(
                title: Text(widget.devices[i].name ?? ""),
                subtitle: Text(widget.devices[i].address ?? ""),
                trailing: selectedDeviceIndex == i
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator())
                    : const SizedBox(),
                onTap: () async {
                  setState(() {
                    selectedDeviceIndex = i;
                  });
                  try {
                    await bluetooth.connect(widget.devices[i]).whenComplete(
                        () => debugPrint(
                            'Bluetooth connected to ${widget.devices[i].name}'));

                    Navigator.pop(context); // Close the dialog
                  } catch (e) {
                    snaki(msg: "Failed to connect");
                    debugPrint(
                        'Failed to connect to ${widget.devices[i].name}: $e');
                  } finally {
                    setState(() {
                      selectedDeviceIndex = null;
                    });
                  }
                },
              )
            },
          ],
        ),
      ),
    );
  }
}
