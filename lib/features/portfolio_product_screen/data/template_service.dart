import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import 'package:taproot_admin/core/api/dio_helper.dart';
import 'package:taproot_admin/core/api/error_exception_handler.dart';
import 'package:taproot_admin/core/logger.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_category_models.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_model.dart';

import '../../../core/api/base_url_constant.dart';

class TemplateService with ErrorExceptionHandler {
  static Future<TemplateResponse> getTemplates({
    required int page,
    String? searchQuery,
    String? sort,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        if (searchQuery != null && searchQuery.isNotEmpty)
          'search': searchQuery,
        if (sort != null && sort != 'all') 'sort': sort,
      };

      final response = await DioHelper().get(
        '/template',
        type: ApiType.baseUrl,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return TemplateResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load templates');
      }
    } catch (e) {
      throw TemplateService().handleError('Failed to load templates, $e');
    }
  }

  static Future<Template> getTemplateById({String? templateId}) async {
    try {
      final response = await DioHelper().get(
        '/template/$templateId',
        type: ApiType.baseUrl,
      );

      if (response.statusCode == 200) {
        logSuccess("Response Data: ${response.data}");
        return Template.fromJson(response.data['result']);
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw TemplateService().handleError('Failed to load product, $e');
    }
  }

  static Future<List<TemplateCategory>> getTemplateCategory() async {
    try {
      final response = await DioHelper().get(
        '/template-category',
        type: ApiType.baseUrl,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'];
        return data.map((item) => TemplateCategory.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load product categories');
      }
    } catch (e) {
      throw TemplateService().handleError(
        'Failed to load product categories, $e',
      );
    }
  }

  static Future<SingleTemplateResponse> editTemplate({
    required String templateId,
    required String name,

    required Thumbnail thumbnail,
    required String categoryId,
  }) async {
    final body = {
      "name": name,

      "category": categoryId,
      "thumbnail": thumbnail.toJson(),
    };

    final response = await DioHelper().patch(
      '/template/$templateId',
      data: body,
      type: ApiType.baseUrl,
    );

    return SingleTemplateResponse.fromJson(response.data);
  }

  static Future<SingleTemplateResponse> addTemplate({
    required Template template,
  }) async {
    try {
      final body = template.toAddJson();
      logInfo(" Sending body: $body");

      final response = await DioHelper().post(
        '/template',
        data: body,
        type: ApiType.baseUrl,
      );

      logSuccess(" Template added: ${response.data}");
      return SingleTemplateResponse.fromJson(response.data);
    } catch (e, s) {
      logError(" Error adding template: $e");
      logError(" Stacktrace: $s");
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> uploadImageFile(
    Uint8List imageBytes,
    String filename,
  ) async {
    try {
      final formData = dio.FormData.fromMap({
        'image': dio.MultipartFile.fromBytes(
          imageBytes,
          filename: filename,
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      final response = await DioHelper().post(
        '/template/upload',
        type: ApiType.baseUrl,
        data: formData,
        options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.data != null && response.data['result'] != null) {
        final result = response.data['result'] as Map<String, dynamic>;
        logSuccess('Upload success: $result');
        return result;
      } else {
        throw Exception('Invalid upload response');
      }
    } catch (e) {
      logError('Upload failed: $e');
      throw TemplateService().handleError('Upload failed: $e');
    }
  }

  static Future<dynamic> addTemplateCategory({String? categoryName}) async {
    try {
      final response = await DioHelper().post(
        '/template-category',
        type: ApiType.baseUrl,
        data: {"name": categoryName},
      );
      logSuccess(response.data);
      return response.data;
    } catch (e) {
      logError('error: $e');
      return {'message': 'Something went wrong'};
    }
  }
static Future<dynamic> updateTemplateCategory({
  required String categoryId,
  required String categoryName,
}) async {
  try {
    final response = await DioHelper().patch(
      '/template-category/$categoryId',
      type: ApiType.baseUrl,
      data: {"name": categoryName},
    );
    logSuccess(response.data);
    return response.data;
  } catch (e) {
    logError('error: $e');
    return {'message': 'Something went wrong'};
  }
}

  static Future<bool> isTemplateEnable({required String templateId}) async {
    try {
      final response = await DioHelper().patch(
        '/template/change-status/$templateId',
        type: ApiType.baseUrl,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      logError('Template status update failed: $e');
      rethrow;
    }
  }
}
