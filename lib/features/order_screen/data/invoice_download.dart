import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:taproot_admin/core/api/base_url_constant.dart';
import 'package:taproot_admin/core/api/dio_helper.dart';
import 'package:taproot_admin/core/logger.dart';
import 'package:taproot_admin/widgets/snakbar_helper.dart';

Future<void> downloadInvoicePdfWithoutPackage(
  BuildContext context,
  String orderId,
) async {
  try {
    final response = await DioHelper().get(
      '/order/invoice-admin/$orderId',
      type: ApiType.baseUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    final downloadsDir = Directory(
      '${Platform.environment['HOME'] ?? Platform.environment['USERPROFILE']}/Downloads',
    );
    final filePath = '${downloadsDir.path}/invoice-$orderId.pdf';

    final file = File(filePath);
    await file.writeAsBytes(response.data);

    logSuccess('Saved to: $filePath');

    if (context.mounted) {
      SnackbarHelper.showSuccess(context, 'Invoice downloaded successfully');
      
    }
  } catch (e) {
    logError('Error downloading invoice: $e');

    if (context.mounted) {
      SnackbarHelper.showError(context, 'Failed to download invoice');
     
    }
  }
}
