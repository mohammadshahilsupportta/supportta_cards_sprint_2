import 'package:taproot_admin/core/api/base_url_constant.dart';
import 'package:taproot_admin/core/api/dio_helper.dart';
import 'package:taproot_admin/core/api/error_exception_handler.dart';
import 'package:taproot_admin/core/logger.dart';
import 'package:taproot_admin/features/Referral_screen/data/bank_detail_model.dart';
import 'package:taproot_admin/features/Referral_screen/data/refer_detail_model.dart';
import 'package:taproot_admin/features/Referral_screen/data/refer_model.dart';
import 'package:taproot_admin/features/Referral_screen/data/transaction_wallet_model.dart';

class ReferService with ErrorExceptionHandler {
  static Future<WalletResponse> fetchReferUser(
    int page,
    String? searchQuery,
  ) async {
    try {
      final response = await DioHelper().get(
        '/wallet',
        type: ApiType.baseUrl,
        queryParameters: {
          // 'limit': 1,
          'page': page,
          if (searchQuery != null && searchQuery.isNotEmpty)
            'search': searchQuery,
        },
      );

      final data = response.data;
      return WalletResponse.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<WalletDetailsResponse> fetchWalletDetails(String userId) async {
    try {
      final response = await DioHelper().get(
        '/wallet/user/$userId',
        type: ApiType.baseUrl,
      );

      return WalletDetailsResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<PaymentDetailsResponse> fetchPaymentDetails(
    String userId,
  ) async {
    try {
      final response = await DioHelper().get(
        '/bank-details/user/$userId',
        type: ApiType.baseUrl,
      );
      return PaymentDetailsResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<SimpleTransactionResponse?> fetchSimpleTransactions(
    String userId,
  ) async {
    try {
      final response = await DioHelper().get(
        '/wallet-transaction',
        type: ApiType.baseUrl,
        queryParameters: {'user': userId},
      );

      return SimpleTransactionResponse.fromJson(response.data);
    } catch (e) {
      logError('Error fetching transactions: $e');
      return null;
    }
  }
}
