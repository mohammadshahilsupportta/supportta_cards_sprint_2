import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/widgets/snakbar_helper.dart';

Future<void> downloadQrCode(GlobalKey key, BuildContext context,String username) async {
  try {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    final Size widgetSize = box.size;

    const double targetSize = 1000;
    final pixelRatio = targetSize / widgetSize.shortestSide;

    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      Directory? directory;
      if (kIsWeb) {
        throw UnsupportedError(
          "Saving QR code on Web is not supported this way.",
        );
      } else if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) return;

        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      final sanitizedUsername = username
          .replaceAll(RegExp(r'[^\w\s]+'), '')
          .replaceAll(' ', '_');
      // final filePath =
      //     '${directory!.path}/qr_code_${DateTime.now().millisecondsSinceEpoch}.png';
       final filePath =
          '${directory!.path}/qr_code_${sanitizedUsername}_${DateTime.now().millisecondsSinceEpoch}.png';

      final file = File(filePath);
      await file.writeAsBytes(pngBytes);
      if (context.mounted) {
        SnackbarHelper.showSuccess(context, 'QR Code Downloaded Successfully');
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
      }

      logSuccess(' QR code saved to: $filePath');
    }
  } catch (e) {
    logError(' Error downloading QR: $e');
  }
}
