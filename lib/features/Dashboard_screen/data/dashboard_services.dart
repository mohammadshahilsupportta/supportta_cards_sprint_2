import 'package:taproot_admin/features/Dashboard_screen/data/chart_data.dart';
import 'package:taproot_admin/features/Dashboard_screen/data/dashboard_model.dart';

import '../../../core/api/base_url_constant.dart';
import '../../../core/api/dio_helper.dart';
import '../../../core/api/error_exception_handler.dart';

class DashboardServices with ErrorExceptionHandler {
  static Future<DashboardModel> getDashData(String? period) async {
    try {
      final response = await DioHelper().get(
        '/dashboard',
        type: ApiType.baseUrl,
        queryParameters: {
          'period':period
        }
      );
      return DashboardModel.fromJson(response.data);
    } catch (e) {
      throw DashboardServices().handleError(e);
    }
  }
  static Future<ChartData> getChartData() async {
    try {
      final response = await DioHelper().get(
        '/dashboard/graph',
        type: ApiType.baseUrl,
      );
      return ChartData.fromJson(response.data);
    } catch (e) {
      throw DashboardServices().handleError(e);
    }
  }
}
