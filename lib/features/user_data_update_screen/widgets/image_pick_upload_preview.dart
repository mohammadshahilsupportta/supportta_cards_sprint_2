import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:taproot_admin/core/api/base_url_constant.dart';
import 'package:taproot_admin/core/api/dio_helper.dart';
import 'package:taproot_admin/core/logger.dart';

class PickedImage {
  final Uint8List bytes;
  final String filename;
  final int size;

  PickedImage({
    required this.bytes,
    required this.filename,
    required this.size,
  });
}

class UploadedFileInfo {
  final String key;
  final String name;
  final String mimeType;
  final int size;
  final String? url; // Made optional since it's not in the API response

  UploadedFileInfo({
    required this.key,
    required this.name,
    required this.mimeType,
    required this.size,
    this.url, // Made optional
  });

  factory UploadedFileInfo.fromJson(Map<String, dynamic> json) {
    return UploadedFileInfo(
      key: json['key'] as String,
      name: json['name'] as String,
      mimeType: json['mimetype'] as String, // Changed to match API response
      size: json['size'] as int,
      url: json['url'] as String?, // Made optional
    );
  }
}


class ImagePickerService {
  static Future<PickedImage?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final file = result.files.single;
      return PickedImage(
        bytes: file.bytes!,
        filename: file.name,
        size: file.size,
      );
    }
    return null;
  }

  // static Future<UploadedFileInfo> uploadImageFile(
  //   Uint8List imageBytes,
  //   String filename, {
  //   bool isOrder = false,
  // }) async {
  //   try {
  //     final String fileExtension = filename.split('.').last.toLowerCase();
  //     final String mimeType = (fileExtension == 'png') ? 'png' : 'jpeg';

  //     final formData = FormData.fromMap({
  //       'file': MultipartFile.fromBytes(
  //         imageBytes,
  //         filename: filename,
  //         contentType: MediaType('image', mimeType),
  //       ),
  //     });

  //     final endpoint = isOrder ? '/order/upload' : '/portfolio/upload';

  //     logWarning('Uploading to endpoint: $endpoint');

  //     final response = await DioHelper().post(
  //       endpoint,
  //       type: ApiType.baseUrl,
  //       data: formData,
  //       options: Options(headers: {'Content-Type': 'multipart/form-data'}),
  //     );

  //     if (response.data != null && response.data['result'] != null) {
  //       final result = response.data['result'] as Map<String, dynamic>;
  //       logSuccess('Upload success: $result');
  //       return UploadedFileInfo.fromJson(result);
  //     } else {
  //       throw Exception('Invalid upload response');
  //     }
  //   } catch (e) {
  //     logError('Upload failed: $e');
  //     if (e is DioException) {
  //       logError('Request data: ${e.requestOptions.data}');
  //       logError('Response data: ${e.response?.data}');
  //     }
  //     rethrow;
  //   }
  // }


  static Future<UploadedFileInfo> uploadImageFile(
    Uint8List imageBytes,
    String filename,
  ) async {
    try {
      final String fileExtension = filename.split('.').last.toLowerCase();
      final String mimeType = (fileExtension == 'png') ? 'png' : 'jpeg';

      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          imageBytes,
          filename: filename,
          contentType: MediaType('image', mimeType),
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
        return UploadedFileInfo.fromJson(result);
      } else {
        throw Exception('Invalid upload response');
      }
    } catch (e) {
      logError('Upload failed: $e');
      rethrow; // or replace with custom error handler if needed
    }
  }
}
