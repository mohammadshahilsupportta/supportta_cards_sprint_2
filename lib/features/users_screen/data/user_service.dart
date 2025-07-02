import 'package:dio/dio.dart';
import 'package:taproot_admin/core/api/base_url_constant.dart';
import 'package:taproot_admin/core/api/dio_helper.dart';
import 'package:taproot_admin/core/api/error_exception_handler.dart';
import 'package:taproot_admin/core/logger.dart';
import 'package:taproot_admin/features/users_screen/data/user_paginated_model.dart';

class UserService with ErrorExceptionHandler {
  static Future<PaginatedUserResponse> fetchUser(
    int page,
    String? searchQuery,
    bool? isPremiumOnly,
  ) async {
    try {
      final response = await DioHelper().get(
        '/user',
        type: ApiType.baseUrl,
        queryParameters: {
          'page': page,
          if (searchQuery != null && searchQuery.isNotEmpty)
            'search': searchQuery,
          if (isPremiumOnly == true) 'premium': true,
        },
      );
      final data = response.data;
      return PaginatedUserResponse.fromJson(data);
    } catch (e) {
      throw UserService().handleError(e);
    }
  }

  static Future<bool> createUser({
    required Map<String, dynamic> userData,
  }) async {
    try {
      final response = await DioHelper().post(
        '/user',
        type: ApiType.baseUrl,
        data: userData,
      );

      return response.statusCode == 201;
    } catch (e) {
      logError('Error creating user: $e');

      if (e is DioException && e.response != null) {
        // Assuming backend sends error message in 'message' field
        final errorMessage =
            e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Failed to create user';
        throw Exception(errorMessage);
      }

      throw Exception('Failed to create user');
    }
  }
  // static Future<bool> createUser({
  //   required Map<String, dynamic> userData,
  // }) async {
  //   try {
  //     final response = await DioHelper().post(
  //       '/user',
  //       type: ApiType.baseUrl,
  //       data: userData,
  //     );

  //     // Return true if successful
  //     return response.statusCode == 201;

  //   } catch (e) {

  //     logError('Error creating user: $e');
  //     throw UserService().handleError(e);
  //   }
  // }
}
