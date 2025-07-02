import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:taproot_admin/core/api/base_url_constant.dart';
import 'package:taproot_admin/core/api/dio_helper.dart';
import 'package:taproot_admin/core/api/error_exception_handler.dart';
import 'package:taproot_admin/services/shared_pref_services.dart';

class AuthService with ErrorExceptionHandler {
  static Future<bool> loginAdmin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await DioHelper().patch(
        '/admin/login',
        data: {'email': email, 'password': password},
        type: ApiType.baseUrl,
      );

      final token = response.data['result']?['token'];
      if (token == null || !_isTokenValid(token)) return false;

      await SharedPreferencesService.i.setValue(key: 'token', value: token);
      return true;
    } catch (e) {
      throw AuthService().handleError(e);
    }
  }

  static bool _isTokenValid(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64.normalize(parts[1]))),
      );

      final exp = payload['exp'];
      if (exp == null) return false;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isBefore(expiryDate);
    } catch (_) {
      return false;
    }
  }

  static Future<void> sessionLogout(BuildContext context) async {
    await SharedPreferencesService.i.clear();

    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
    }
  }

  // static Future<void> loginAdmin({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final response = await DioHelper().patch(
  //       '/admin/login',
  //       data: {'email': email, 'password': password},
  //       type: ApiType.baseUrl,
  //     );
  //     String token = response.data['result']['token'];
  //     await SharedPreferencesService.i.setValue(key: 'token', value: token);
  //   } catch (e) {
  //     throw AuthService().handleError(e);
  //   }
  // }
}
