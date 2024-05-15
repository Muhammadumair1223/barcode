// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:barcodeinventory/utils/global_context_key.dart';
import 'package:barcodeinventory/widgets/app_snakbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfPrinter {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  Future<void> printText(Uint8List generatedPDFBytes) async {
    try {
      final pdf = pw.Document();
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Image(pw.MemoryImage(generatedPDFBytes));
        },
      ));
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/example.pdf');
      await file.writeAsBytes(await pdf.save());

      List<int> bytes = await file.readAsBytes();
      String base64 = base64Encode(bytes);

      await bluetooth.printCustom(base64, 0, 0);
    } catch (e) {
      debugPrint('Error printing PDF: $e');
      snaki(msg: "Device Not Connected");
    }
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
