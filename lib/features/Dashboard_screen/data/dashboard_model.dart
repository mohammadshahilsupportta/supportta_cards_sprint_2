class DashboardModel {
  final bool success;
  final String message;
  final DashboardResult result;

  DashboardModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      success: json['success'],
      message: json['message'],
      result: DashboardResult.fromJson(json['result']),
    );
  }
}

class DashboardResult {
  final DashboardData result;

  DashboardResult({
    required this.result,
  });

  factory DashboardResult.fromJson(Map<String, dynamic> json) {
    return DashboardResult(
      result: DashboardData.fromJson(json['result']),
    );
  }
}

class DashboardData {
  final String period;
  final double revenue;
  final double expense;
  final double profit;
  final double revenueChange;
  final double expenseChange;
  final double profitChange;
  final int totalOrder;
  final int deliveredOrder;
  final int cancelledOrder;
  final double refundAmount;

  DashboardData({
    required this.period,
    required this.revenue,
    required this.expense,
    required this.profit,
    required this.revenueChange,
    required this.expenseChange,
    required this.profitChange,
    required this.totalOrder,
    required this.deliveredOrder,
    required this.cancelledOrder,
    required this.refundAmount,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      period: json['period'],
      revenue: (json['revenue'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
      revenueChange: (json['revenueChange'] as num).toDouble(),
      expenseChange: (json['expenseChange'] as num).toDouble(),
      profitChange: (json['profitChange'] as num).toDouble(),
      totalOrder: json['totalOrder'],
      deliveredOrder: json['deliveredOrder'],
      cancelledOrder: json['cancelledOrder'],
      refundAmount: (json['refundAmount'] as num).toDouble(),
    );
  }
}