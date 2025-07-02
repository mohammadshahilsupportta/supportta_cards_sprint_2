import '/core/api/base_url_constant.dart';
import '/core/api/dio_helper.dart';
import 'package:dio/dio.dart';

class CoffeeService {
  static Future getCofee() async {
    try {
      Response response =
          await DioHelper().get('/coffee/hot', type: ApiType.coffee);
      return response.data;
    } catch (e) {
      throw DioHelper().handleError(e);
    }
  }
}
