import 'package:flutter/material.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_service.dart';

class PincodeHelper {
  static Future<void> fetchAndSetLocationData({
    required String pincode,
    required TextEditingController districtController,
    required TextEditingController stateController,
    required void Function(String) logSuccess,
    required void Function(String) logError,
  }) async {
    try {
      final response = await PortfolioService.getDatafromPincode(
        pinCode: int.parse(pincode),
      );
      final postOffice = response['PostOffice']?.first;

      if (postOffice != null) {
        final district = postOffice['District'] ?? '';
        final state = postOffice['State'] ?? '';

        logSuccess('Fetched: $district, $state');

        districtController.text = district;
        stateController.text = state;
      } else {
        logError('No PostOffice data found.');
      }
    } catch (e) {
      logError("Failed to fetch pincode data: $e");
    }
  }
}
