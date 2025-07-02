import 'package:taproot_admin/main.dart';
import 'package:taproot_admin/widgets/snakbar_helper.dart';

import '/core/api/base_url_constant.dart';
import '/core/api/error_exception_handler.dart';
import '/core/logger.dart';
import '/services/shared_pref_services.dart';
import 'package:dio/dio.dart';

class DioHelper with ErrorExceptionHandler {
  static final DioHelper _instance = DioHelper._internal();
  factory DioHelper() => _instance;
  DioHelper._internal();

  final Map<ApiType, Dio> _dioMap = {};

  Future<void> init() async {
    final token = SharedPreferencesService.i.token;

    for (var type in ApiType.values) {
      final dio = Dio(
        BaseOptions(
          baseUrl: BaseUrlConstant.getBaseUrl(type),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = SharedPreferencesService.i.token;

            // Always attach latest token just before the request
            if (token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }

            final fullUrl = '${options.baseUrl}${options.path}';
            logSuccess("Request URL: $fullUrl");
            logInfo("REQUEST[${options.method}] => PATH: ${options.path}");
            logSuccess("Headers: ${options.headers}");

            return handler.next(options);
          },
          // onRequest: (options, handler) {
          //   final fullUrl = '${options.baseUrl}${options.path}';
          //   logSuccess("Request URL: $fullUrl");
          //   logInfo("REQUEST[${options.method}] => PATH: ${options.path}");
          //   logSuccess("Headers: ${options.headers}");
          //   return handler.next(options);
          // },
          onResponse: (response, handler) {
            logInfo(
              "RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}",
            );
            logSuccess("Data: ${response.data}");
            return handler.next(response);
          },
          onError: (DioException err, handler) async {
            logError(
              "ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}",
            );
            logError("Message: ${err.message}");
            if (err.response?.statusCode == 403) {
              await SharedPreferencesService.i.clear();

              final context = navigatorKey.currentContext;
              if (context != null) {
                SnackbarHelper.showError(
                  context,
                  'Session expired. Please login again.',
                );
              }
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                '/auth',
                (route) => false,
              );
            }

            return handler.next(err);
          },
        ),
      );

      _dioMap[type] = dio;
    }
  }

  Dio getDio([ApiType type = ApiType.base]) => _dioMap[type]!;

  Future<Response> get(
    String path, {
    ApiType type = ApiType.base,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return getDio(
      type,
    ).get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(
    String path, {
    ApiType type = ApiType.base,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return getDio(type).post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> put(
    String path, {
    ApiType type = ApiType.base,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return getDio(
      type,
    ).put(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response> delete(
    String path, {
    ApiType type = ApiType.base,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return getDio(type).delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> patch(
    String path, {
    ApiType type = ApiType.base,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return getDio(type).patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
