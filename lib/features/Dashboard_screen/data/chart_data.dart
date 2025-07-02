// chart_data.dart
class ChartData {
  bool? success;
  String? message;
  Result? result;

  ChartData({this.success, this.message, this.result});

  ChartData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
}

class Result {
  List<MonthlyData>? lastSixMonthsData;

  Result({this.lastSixMonthsData});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['lastSixMonthsData'] != null) {
      lastSixMonthsData = <MonthlyData>[];
      json['lastSixMonthsData'].forEach((v) {
        lastSixMonthsData!.add(MonthlyData.fromJson(v));
      });
    }
  }
}

class MonthlyData {
  String? month;
  double? revenue;
  double? expense;
  double? profit;
  int? totalOrder;
  int? deliveredOrder;
  int? cancelledOrder;

  MonthlyData({
    this.month,
    this.revenue,
    this.expense,
    this.profit,
    this.totalOrder,
    this.deliveredOrder,
    this.cancelledOrder,
  });

  MonthlyData.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    revenue = json['revenue']?.toDouble();
    expense = json['expense']?.toDouble();
    profit = json['profit']?.toDouble();
    totalOrder = json['totalOrder'];
    deliveredOrder = json['deliveredOrder'];
    cancelledOrder = json['cancelledOrder'];
  }
}
