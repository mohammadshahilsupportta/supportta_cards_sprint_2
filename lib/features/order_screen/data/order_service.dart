import 'package:taproot_admin/core/api/base_url_constant.dart';
import 'package:taproot_admin/core/api/dio_helper.dart';
import 'package:taproot_admin/core/api/error_exception_handler.dart';
import 'package:taproot_admin/core/logger.dart';
import 'package:taproot_admin/features/order_screen/data/order_detail_add.model.dart';
import 'package:taproot_admin/features/order_screen/data/order_details_model.dart';
import 'package:taproot_admin/features/order_screen/data/order_model.dart';
import 'package:taproot_admin/features/order_screen/data/order_status_model.dart';
import 'package:taproot_admin/features/order_screen/data/order_user_model.dart';
import 'package:taproot_admin/features/product_screen/data/product_model.dart';
import 'package:taproot_admin/features/users_screen/data/user_paginated_model.dart';

class OrderService with ErrorExceptionHandler {
  static Future<OrderResponse> getAllOrder({
    int page = 1,
    int limit = 5,
    String? search,
    String? orderStatus,
    String? startDate,
  }) async {
    try {
      final queryParameters = {
        'limit': limit,
        'page': page,
        if (search != null && search.isNotEmpty) 'search': search,
        if (orderStatus != null && orderStatus.isNotEmpty)
          'orderStatus': orderStatus,
        if (startDate != null && startDate.isNotEmpty) 'startDate': startDate,
      };

      final response = await DioHelper().get(
        '/order/all',
        type: ApiType.baseUrl,
        queryParameters: queryParameters,
      );
      return OrderResponse.fromJson(response.data);
    } catch (e) {
      throw OrderService().handleError(e);
    }
  }

  static Future<OrderDetailsResponse> getOrderDetails({
    required String orderId,
  }) async {
    try {
      final response = await DioHelper().get(
        '/order/order-details/$orderId',
        type: ApiType.baseUrl,
      );

      logInfo('API Response: ${response.data}');

      final Map<String, dynamic> responseData = Map<String, dynamic>.from(
        response.data,
      );

      if (responseData['result'] != null) {
        final Map<String, dynamic> result = Map<String, dynamic>.from(
          responseData['result'],
        );

        if (result['products'] != null) {
          final List<Map<String, dynamic>> products =
              (result['products'] as List)
                  .map((product) => Map<String, dynamic>.from(product))
                  .toList();

          result['products'] = products;
        }

        responseData['result'] = result;
      }

      return OrderDetailsResponse.fromJson(responseData);
    } catch (e) {
      logError('Error in getOrderDetails: $e');
      throw OrderService().handleError(e);
    }
  }

  static Future<OrderResponseUser?> getOrderedUser({
    required String orderId,
  }) async {
    try {
      final response = await DioHelper().get(
        '/order/userdetails/$orderId',
        type: ApiType.baseUrl,
      );

      if (response.statusCode == 200) {
        return OrderResponseUser.fromJson(response.data);
      }
      return null;
    } catch (e) {
      logError('Error in getOrderedUser: $e');
      return null;
    }
  }

  static Future<String> getOrderId() async {
    try {
      final response = await DioHelper().get(
        '/order/id',
        type: ApiType.baseUrl,
      );
      return response.data['result'] as String;
    } catch (e) {
      throw OrderService().handleError(e);
    }
  }

  static Future<PaginatedUserResponse> fetchUser(String? searchQuery) async {
    try {
      final response = await DioHelper().get(
        '/user',
        type: ApiType.baseUrl,
        queryParameters: {
          'limit': 4,

          if (searchQuery != null && searchQuery.isNotEmpty)
            'search': searchQuery,
        },
      );
      final data = response.data;
      return PaginatedUserResponse.fromJson(data);
    } catch (e) {
      throw OrderService().handleError(e);
    }
  }

  static Future<ProductResponse> fetchProduct(String? searchQuery) async {
    try {
      final response = await DioHelper().get(
        '/product',
        type: ApiType.baseUrl,
        queryParameters: {
          'limit': 4,

          if (searchQuery != null && searchQuery.isNotEmpty)
            'search': searchQuery,
        },
      );
      final data = response.data;
      return ProductResponse.fromJson(data);
    } catch (e) {
      throw OrderService().handleError(e);
    }
  }

  static Future<OrderDetailsResponse> editOrder({
    required String orderId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await DioHelper().patch(
        '/order/order-details/$orderId',
        type: ApiType.baseUrl,
        data: data,
      );
      return OrderDetailsResponse.fromJson(response.data);
    } catch (e) {
      throw OrderService().handleError(e);
    }
  }

  static Future<OrderPostModel> createOrder({
    required String userId,
    required OrderPostModel orderData,
  }) async {
    try {
      final response = await DioHelper().post(
        '/order/$userId',
        type: ApiType.baseUrl,
        data: orderData.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return orderData;
      } else {
        throw Exception(
          'Failed to create order. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      logError('Error creating order: $e');
      throw OrderService().handleError(e);
    }
  }

  static Future<bool> checkPortfolio({required String userid}) async {
    try {
      final response = await DioHelper().get(
        '/portfolio/$userid',
        type: ApiType.baseUrl,
      );

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      logError('Portfolio check error: $e');

      return false;
    }
  }
  // static Future<bool> checkPortfolioPaid()async{

  // }

  static Future<Map<String, dynamic>> cancelOrder({
    required String orderId,
    required int refundPercentage,
  }) async {
    try {
      final response = await DioHelper().patch(
        '/order/cancel-order/$orderId',
        type: ApiType.baseUrl,
        data: {'refundPercentage': refundPercentage},
      );

      return response.data;
    } catch (e) {
      logError('Error canceling order: $e');
      throw OrderService().handleError(e);
    }
  }

  static Future<OrderStatusResponse?> getOrderStatus({
    required String orderId,
  }) async {
    try {
      final response = await DioHelper().patch(
        '/order/order-status/$orderId',
        type: ApiType.baseUrl,
      );

      if (response.statusCode == 200 && response.data != null) {
        return OrderStatusResponse.fromJson(response.data);
      } else {
        logInfo('Failed to get order details. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logInfo('Exception in getOrderStatus: $e');
      return null;
    }
  }

  static Future<OrderStatusResponse?> retryOrder(String orderId) async {
    try {
      final response = await DioHelper().patch(
        '/order/retry-order/$orderId',
        type: ApiType.baseUrl,
      );

      if (response.statusCode == 200 && response.data != null) {
        return OrderStatusResponse.fromJson(response.data);
      }
    } catch (e) {
      logInfo('Retry Order API error: $e');
    }

    return null;
  }
}
