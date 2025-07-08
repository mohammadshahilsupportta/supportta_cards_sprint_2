import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:taproot_admin/core/api/base_url_constant.dart';
import 'package:taproot_admin/core/api/dio_helper.dart';
import 'package:taproot_admin/core/api/error_exception_handler.dart';
import 'package:taproot_admin/core/logger.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/product_porfolio_model.dart';

class PortfolioService with ErrorExceptionHandler {
  static Future<PortfolioDataModel?> getPortfolio({
    required String userid,
  }) async {
    try {
      final response = await DioHelper().get(
        '/portfolio/$userid',
        type: ApiType.baseUrl,
      );

      final model = PortfolioDataModel.fromJson(response.data);
      return model;
    } catch (e) {
      throw PortfolioService().handleError(e)!;
    }
  }

  static Future<Map<String, dynamic>?> postPortfolio({
    required String userid,
    required Map<String, dynamic> portfolioData,
  }) async {
    int retries = 3;
    while (retries > 0) {
      try {
        final response = await DioHelper().post(
          '/portfolio/$userid',
          type: ApiType.baseUrl,
          data: portfolioData,
        );

        if (response.statusCode == 404) {
          throw Exception('Portfolio not found for user ID: $userid');
        } else if (response.statusCode == 400) {
          throw Exception('Bad request: Invalid portfolio data');
        } else if (response.statusCode == 500) {
          throw Exception('Server error. Please try again later.');
        }

        if (response.data != null) {
          return response.data;
        } else {
          throw Exception("Response data is null");
        }
      } catch (e) {
        retries--;
        if (retries == 0) {
          logError('Error: $e');
          throw PortfolioService()
              .handleError(e)
              .copyWith(message: 'Post portfolio failed: $e');
        }
      }
    }
    return null;
  }

  static Future<Map<String, dynamic>> getDatafromPincode({
    required int pinCode,
  }) async {
    try {
      Response response = await DioHelper().get(
        '/pincode/$pinCode',
        type: ApiType.pincodeUrl,
      );
      return response.data;
    } catch (e) {
      throw PortfolioService().handleError(e);
    }
  }

  static Future<PortfolioDataModel?> editPortfolio({
    required String userid,
    required Map<String, dynamic> portfolioEditedData,
  }) async {
    try {
      final response = await DioHelper().patch(
        '/portfolio/$userid',
        type: ApiType.baseUrl,
        data: portfolioEditedData,
      );

      if (response.statusCode == 200) {
        return PortfolioDataModel.fromJson(response.data);
      } else if (response.statusCode == 400) {
        final msg = response.data['message'] as String?;
        throw Exception(msg ?? 'Invalid portfolio data');
      } else if (response.statusCode == 404) {
        throw Exception('Portfolio not found for user ID: $userid');
      } else {
        throw Exception('Failed to edit portfolio');
      }
    } catch (e) {
      logError('EditPortfolio Error: $e');
    }
    return null;
  }

  static Future<PortfolioDataModel> addService({
    required String userId,
    required String portfolioId,
    required Map<String, dynamic> serviceData,
  }) async {
    try {
      print('Making API call to add service');
      final response = await DioHelper().post(
        '/portfolio-service/$userId/service/$portfolioId',
        type: ApiType.baseUrl,
        data: serviceData,
      );

      print('API Response status: ${response.statusCode}');
      print('API Response data: ${response.data}');

      if (response.statusCode == 200) {
        // Get updated portfolio in same API call if possible
        final portfolioResponse = await DioHelper().get(
          '/portfolio/$userId',
          type: ApiType.baseUrl,
        );

        if (portfolioResponse.statusCode == 200) {
          return PortfolioDataModel.fromJson(portfolioResponse.data);
        } else {
          throw Exception('Failed to fetch updated portfolio');
        }
      } else {
        throw Exception('Failed to add service');
      }
    } catch (e) {
      logError('AddService Error: $e');
      throw PortfolioService().handleError(e);
    }
  }

  // static Future<PortfolioDataModel> addService({
  //   required String userId,
  //   required String portfolioId,
  //   required Map<String, dynamic> serviceData,
  // }) async {
  //   try {
  //     // final formData = FormData.fromMap(serviceData);
  //     final response = await DioHelper().post(
  //       '/portfolio-service/$userId/service/$portfolioId',
  //       type: ApiType.baseUrl,
  //       data: serviceData,
  //     );
  //     if (response.statusCode == 200) {
  //       return PortfolioDataModel.fromJson(response.data);
  //     } else {
  //       throw Exception('Failed to add service');
  //     }
  //   } catch (e) {
  //     logError('AddService Error: $e');
  //     throw PortfolioService().handleError(e);
  //   }
  // }
  static Future<PortfolioDataModel> editService({
    required String serviceId,
    required Map<String, dynamic> editServiceData,
    required String userId, // Add this parameter
  }) async {
    try {
      // First, edit the service
      final response = await DioHelper().patch(
        '/portfolio-service/service/$serviceId',
        type: ApiType.baseUrl,
        data: editServiceData,
      );

      if (response.statusCode == 200) {
        // Fetch the updated portfolio using the provided userId
        final portfolioResponse = await DioHelper().get(
          '/portfolio/$userId',
          type: ApiType.baseUrl,
        );

        if (portfolioResponse.statusCode == 200) {
          return PortfolioDataModel.fromJson(portfolioResponse.data);
        } else {
          throw Exception('Failed to fetch updated portfolio');
        }
      } else {
        throw Exception('Failed to edit service');
      }
    } catch (e) {
      logError('Edit service Error: $e');
      throw Exception('Edit service failed: $e');
    }
  }

  // static Future<PortfolioDataModel> editService({
  //   required String serviceId,
  //   required Map<String, dynamic> editServiceData,
  // }) async {
  //   try {
  //     final response = await DioHelper().patch(
  //       '/portfolio-service/service/$serviceId',
  //       type: ApiType.baseUrl,
  //       data: editServiceData,
  //     );
  //     if (response.statusCode == 200) {
  //       return PortfolioDataModel.fromJson(response.data);
  //     } else {
  //       throw Exception('failed');
  //     }
  //   } catch (e) {
  //     logError('Edit service Error:$e');
  //     throw Exception('Edit service failed: $e');
  //   }
  // }

  static Future<void> deleteService({required String serviceId}) async {
    try {
      final response = await DioHelper().delete(
        '/portfolio-service/service/$serviceId',
        type: ApiType.baseUrl,
      );
      if (response.statusCode == 200) {
        logSuccess('Deleted successfully');
      }
    } catch (e) {
      throw PortfolioService().handleError('Delete Error $e');
    }
  }

  static Future<Map<String, dynamic>> uploadImageFile(
    Uint8List imageBytes,
    String filename,
  ) async {
    try {
      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          imageBytes,
          filename: filename,
          contentType: MediaType('image', 'jpeg'), // adjust if PNG
        ),
      });

      final response = await DioHelper().post(
        '/portfolio/upload',
        type: ApiType.baseUrl,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
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
      throw PortfolioService().handleError('Upload failed: $e');
    }
  }

  static Future<Map<String, dynamic>> uploadServiceImageFile(
    Uint8List imageBytes,
    String filename,
  ) async {
    try {
      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          imageBytes,
          filename: filename,
          contentType: MediaType('image', 'jpeg'), // adjust if PNG
        ),
      });

      final response = await DioHelper().post(
        '/portfolio-service/upload',
        type: ApiType.baseUrl,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
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
      throw PortfolioService().handleError('Upload failed: $e');
    }
  }

  static Future<bool> isUserPremium({required String userId}) async {
    try {
      final response = await DioHelper().patch(
        '/user/change-premium-status/$userId',
        type: ApiType.baseUrl,
      );

      // Check if the response is successful (you might need to adjust this based on your API response structure)
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      logError('Premium status update failed: $e');
      rethrow;
    }
  }

  static Future<bool> isUserPaidPortfolio({required String userId}) async {
    try {
      final response = await DioHelper().get(
        '/order/portfolioorders/$userId',
        type: ApiType.baseUrl,
      );

      if (response.data != null) {
        return response.data['result'] == true;
      }
      return false;
    } catch (e) {
      logError('Paid portfolio check failed: $e');
      return false; // fallback to unpaid if error occurs
    }
  }

  static Future<List<PortfolioProductModel>> getPortfolioProducts() async {
    try {
      final response = await DioHelper().get(
        '/product',
        type: ApiType.baseUrl,
        queryParameters: {'type': 'Portfolio'},
      );

      if (response.data != null && response.data['results'] != null) {
        final List results = response.data['results'];
        return results
            .map((json) => PortfolioProductModel.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      logError('Error fetching portfolio products: $e');
      rethrow;
    }
  }

  static Future createPortfolioOrder({
    required String userId,
    required String productId,
    required String paymentServiceProvider,
    String? paymentMethod,
    String? referenceId,
  }) async {
    try {
      final data = {
        "paymentServiceProvider": paymentServiceProvider.toUpperCase(),
        "paymentMethod": paymentMethod?.toUpperCase(),
        if (referenceId != null && referenceId.isNotEmpty)
          "referenceId": referenceId,
      };
      // final data = {
      //   "paymentServiceProvider": paymentServiceProvider.toUpperCase(),
      //   if (paymentServiceProvider.toUpperCase() == 'OFFLINE' &&
      //       paymentMethod != null)
      //     "paymentMethod": paymentMethod.toUpperCase(),
      //   if (paymentServiceProvider.toUpperCase() == 'OFFLINE' &&
      //       paymentMethod?.toUpperCase() != 'CASH' &&
      //       referenceId != null)
      //     "referenceId": referenceId,
      // };

      logInfo("Sending data => $data");

      final response = await DioHelper().post(
        '/order/portfolio-order/$userId/$productId',
        data: data,
        type: ApiType.baseUrl,
      );

      return response;
    } catch (e) {
      logInfo("Error in createPortfolioOrder: $e");
      rethrow;
    }
  }

  // static Future createPortfolioOrder({
  //   required String userId,
  //   required String productId,
  //   required String paymentServiceProvider,
  //   String? paymentMethod,
  //   String? referenceId,
  // }) async {
  //   try {
  //     final data = {
  //       "paymentServiceProvider": paymentServiceProvider,
  //       if (paymentServiceProvider == 'Offline' && paymentMethod != null)
  //         "paymentMethod": paymentMethod,
  //       if (paymentServiceProvider == 'Offline' &&
  //           paymentMethod != 'Cash on hand' &&
  //           referenceId != null)
  //         "referenceId": referenceId,
  //     };

  //     final response = await DioHelper().post(
  //       '/order/portfolio-order/$userId/$productId',
  //       data: data,
  //       type: ApiType.baseUrl,
  //     );

  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}



// import 'package:taproot_admin/core/api/base_url_constant.dart';
// import 'package:taproot_admin/core/api/dio_helper.dart';
// import 'package:taproot_admin/core/api/error_exception_handler.dart';
// import 'package:taproot_admin/core/logger.dart';
// import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';

// class PortfolioService with ErrorExceptionHandler {
//   static Future<PortfolioDataModel?> getPortfolio({
//     required String userid,
//   }) async {
//     try {
//       final response = await DioHelper().get(
//         '/portfolio/$userid',
//         type: ApiType.baseUrl,
//       );

//       final model = PortfolioDataModel.fromJson(response.data);
//       return model;
//     } catch (e) {
//       throw PortfolioService().handleError(e);
//     }
//   }
//   static Future<Map<String, dynamic>?> postPortfolio({
//     required String userid,
//     required Map<String, dynamic>
//     portfolioData, // Send as a Map instead of using a model
//   }) async {
//     try {
//       final response = await DioHelper().post(
//         '/portfolio/$userid',
//         type: ApiType.baseUrl,
//         data: portfolioData, // Send the map directly
//       );

//       if (response.statusCode == 404) {
//         throw Exception('Portfolio not found for user ID: $userid');
//       }

//       if (response.data != null) {
//         return response.data; // Return raw response data
//       } else {
//         throw Exception("Response data is null");
//       }
//     } catch (e) {
//       logError('Error: $e');
//       throw PortfolioService().handleError(e);
//     }
//   }

  // static Future<PortfolioDataModel?> postPortfolio({
  //   required String userid,
  //   required PortfolioDataModel portfolioData,
  // }) async {
  //   try {
  //     final response = await DioHelper().post(
  //       '/portfolio/$userid',
  //       type: ApiType.baseUrl,
  //       data: portfolioData.toJson(),
  //     );

  //     if (response.statusCode == 404) {
  //       throw Exception('Portfolio not found for user ID: $userid');
  //     }

  //     if (response.data != null) {
  //       return PortfolioDataModel.fromJson(response.data);
  //     } else {
  //       throw Exception("Response data is null");
  //     }
  //   } catch (e) {
  //     logError('Error: $e');
  //     throw PortfolioService().handleError(e);
  //   }
  // }

