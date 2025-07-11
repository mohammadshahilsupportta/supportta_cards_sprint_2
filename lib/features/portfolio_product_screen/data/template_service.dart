import 'package:taproot_admin/core/api/dio_helper.dart';
import 'package:taproot_admin/core/api/error_exception_handler.dart';
import 'package:taproot_admin/core/logger.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_category_models.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_model.dart';
import 'package:taproot_admin/features/product_screen/data/product_model.dart';

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

  static Future<Template> getTemplateById(String productId) async {
    try {
      final response = await DioHelper().get(
        '/product/$productId',
        type: ApiType.baseUrl,
      );

      if (response.statusCode == 200) {
        logSuccess("Response Data: ${response.data}");
        return Template.fromJson(response.data['results']);
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
    required double actualPrice,
    required double discountPrice,
    required double discountPercentage,
    required List<ProductImage> productImages,
    required String description,
    required String categoryId,
  }) async {
    final body = {
      "name": name,
      "actualPrice": actualPrice,
      "discountPrice": discountPrice,
      "discountPercentage": discountPercentage,
      "description": description,
      "categoryId": categoryId,
      "productImages": productImages.map((img) => img.toJson()).toList(),
    };

    final response = await DioHelper().patch(
      '/template/$templateId',
      data: body,
    );

    return SingleTemplateResponse.fromJson(response.data);
  }
}
