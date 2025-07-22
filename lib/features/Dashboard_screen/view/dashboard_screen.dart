import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/Dashboard_screen/data/chart_data.dart';
import 'package:taproot_admin/features/Dashboard_screen/data/dashboard_model.dart';
import 'package:taproot_admin/features/Dashboard_screen/widgets/financial_returns_widget.dart';
import 'package:taproot_admin/features/Dashboard_screen/widgets/line_graph_widget.dart';

import '../data/dashboard_services.dart';
import '../widgets/logistic_data_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const path = '/dashboardScreen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardModel? dashboardModel;
  ChartData? chartData;
  bool isLoading = true;
  bool isFieldsLoading = false;
  String? error;
  String selectedValue = 'thisMonth';

  final Map<String, String> dateFilters = {
    'Today': 'today',
    'Yesterday': 'yesterday',
    'This Week': 'thisWeek',
    'Last Week': 'lastWeek',
    'This Month': 'thisMonth',
    'Last Month': 'lastMonth',
    'All Time': 'allTime',
  };
  String getDropdownLabel(String value) {
    return dateFilters.entries.firstWhere((entry) => entry.value == value).key;
  }

  Future<void> _initialLoad() async {
    try {
      final response = await DashboardServices.getDashData(selectedValue);
      final chartResponse = await DashboardServices.getChartData();

      if (response.success && chartResponse.success!) {
        logSuccess(response.message);
        setState(() {
          chartData = chartResponse;
          dashboardModel = response;
          isLoading = false;
        });
      }
    } catch (e) {
      logError('Error fetching dashboard data: $e');
      setState(() {
        isLoading = false;
        error = e.toString();
      });
    }
  }

  Future<void> _refreshFields(String period) async {
    setState(() {
      isFieldsLoading = true;
    });

    try {
      final response = await DashboardServices.getDashData(period);

      if (response.success) {
        setState(() {
          dashboardModel = response;
          isFieldsLoading = false;
        });
      }
    } catch (e) {
      logError('Error fetching dashboard data: $e');
      setState(() {
        isFieldsLoading = false;
        error = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initialLoad();
  }

  @override
  Widget build(BuildContext context) {
    double normalPadding = CustomPadding.padding * 2.2;
    double tileWidgetBorderRadius = CustomPadding.padding * 2.5;

    if (error != null || dashboardModel == null || chartData == null) {
      return Scaffold(
        body: ShimmerDashboard(), // Full page shimmer for initial load
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(normalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.only(left: CustomPadding.paddingLarge),
                  //   child: Text('Dashboard', style: context.inter60024),
                  // ),
                  Spacer(),
                  Container(
                    width: 200,

                    padding: EdgeInsets.only(
                      right: CustomPadding.paddingLarge,
                      left: CustomPadding.paddingLarge,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: DropdownButton<String>(
                      value: selectedValue,
                      focusColor: CustomColors.backgroundColor,

                      isExpanded: true,
                      underline: Container(),
                      items:
                          dateFilters.entries.map((entry) {
                            return DropdownMenuItem<String>(
                              value: entry.value,
                              child: Text(entry.key),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedValue = newValue;
                          });
                          _refreshFields(newValue);
                        }
                      },
                    ),
                  ),
                ],
              ),
              Gap(CustomPadding.paddingLarge),
              isFieldsLoading
                  ? ShimmerFields() // Shimmer only for fields when refreshing
                  : FinancialReturnsWidget(
                    dashboardModel: dashboardModel,
                    comparisonText: getDropdownLabel(selectedValue),
                  ),
              Gap(normalPadding),
              Row(
                children: [
                  Gap(normalPadding),
                  SizedBox(
                    width: (620 / 1440) * MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        LineGraphWidget(
                          data: chartData!.result!.lastSixMonthsData!,
                        ),
                      ],
                    ),
                  ),
                  Gap(normalPadding),
                  isFieldsLoading
                      ? ShimmerLogisticData() // Shimmer for logistic data when refreshing
                      : LogisticDataWidget(
                        data: dashboardModel!,
                        normalPadding: normalPadding,
                        tileWidgetBorderRadius: tileWidgetBorderRadius,
                      ),
                  Gap(CustomPadding.paddingLarge),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Shimmer widgets
class ShimmerDashboard extends StatelessWidget {
  const ShimmerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: true,
      period: Duration(seconds: 2),
      direction: ShimmerDirection.ltr,
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          // Add shimmer layout matching your dashboard layout
        ],
      ),
    );
  }
}

class ShimmerFields extends StatelessWidget {
  const ShimmerFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: List.generate(
            4,
            (index) => Expanded(
              child: Container(
                margin: EdgeInsets.all(8),
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerLogisticData extends StatelessWidget {
  const ShimmerLogisticData({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 300,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// class _DashboardScreenState extends State<DashboardScreen> {
//   DashboardModel? dashboardModel;
//   ChartData? chartData;
//   bool isLoading = true;
//   String? error;
//   String selectedValue = 'today';

//   final Map<String, String> dateFilters = {
//     'Today': 'today',
//     'Yesterday': 'yesterday',
//     'This Week': 'thisWeek',
//     'Last Week': 'lastWeek',
//     'This Month': 'thisMonth',
//     'Last Month': 'lastMonth',
//   };

//   Future<void> _fetchDashboardData([String? period]) async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final response = await DashboardServices.getDashData(period);
//       final chartResponse = await DashboardServices.getChartData();

//       if (response.success && chartResponse.success!) {
//         logSuccess(response.message);
//         setState(() {
//           chartData = chartResponse;
//           dashboardModel = response;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       logError('Error fetching dashboard data: $e');
//       setState(() {
//         isLoading = false;
//         error = e.toString();
//       });
//     }
//   }

//   Future<void> _refreshData() async {
//     await _fetchDashboardData(selectedValue);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchDashboardData(selectedValue);
//   }

//   @override
//   Widget build(BuildContext context) {
//     double normalPadding = CustomPadding.padding * 2.2;
//     double tileWidgetBorderRadius = CustomPadding.padding * 2.5;

//     if (isLoading && dashboardModel == null) {
//       return Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return RefreshIndicator(
//       onRefresh: _refreshData,
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(normalPadding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: CustomPadding.paddingLarge,
//                       ),
//                       child: Text('Dashboard', style: context.inter60024),
//                     ),
//                     Spacer(),
//                     // Add the dropdown here
//                     Container(
//                       width: 200,
//                       padding: EdgeInsets.only(
//                         right: CustomPadding.paddingLarge,
//                       ),
//                       child: DropdownButton<String>(
//                         value: selectedValue,
//                         isExpanded: true,
//                         items:
//                             dateFilters.entries.map((entry) {
//                               return DropdownMenuItem<String>(
//                                 value: entry.value,
//                                 child: Text(entry.key),
//                               );
//                             }).toList(),
//                         onChanged: (String? newValue) {
//                           if (newValue != null) {
//                             setState(() {
//                               selectedValue = newValue;
//                             });
//                             _fetchDashboardData(newValue);
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (isLoading)
//                   Center(child: CircularProgressIndicator())
//                 else ...[
//                   Gap(CustomPadding.paddingLarge),
//                   FinancialReturnsWidget(dashboardModel: dashboardModel),
//                   Gap(normalPadding),
//                   Row(
//                     children: [
//                       Gap(normalPadding),
//                       SizedBox(
//                         width: (620 / 1440) * MediaQuery.of(context).size.width,
//                         child: Column(
//                           children: [
//                             LineGraphWidget(
//                               data: chartData!.result!.lastSixMonthsData!,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Gap(normalPadding),
//                       LogisticDataWidget(
//                         data: dashboardModel!,
//                         normalPadding: normalPadding,
//                         tileWidgetBorderRadius: tileWidgetBorderRadius,
//                       ),
//                       Gap(CustomPadding.paddingLarge),
//                     ],
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   DashboardModel? dashboardModel;
//   ChartData? chartData;
//   bool isLoading = true;
//   String? error;
//   String selectedValue = 'today'; // Default value
//   final Map<String, String> dateFilters = {
//     'Today': 'today',
//     'Yesterday': 'yesterday',
//     'This Week': 'thisWeek',
//     'Last Week': 'lastWeek',
//     'This Month': 'thisMonth',
//     'Last Month': 'lastMonth',
//   };
//   Future<void> _fetchDashboardData([String? period]) async {
//     try {
//       final response = await DashboardServices.getDashData(period);
//       final chartResponse = await DashboardServices.getChartData();

//       if (response.success && chartResponse.success!) {
//         logSuccess(response.message);
//         setState(() {
//           chartData = chartResponse;
//           dashboardModel = response;
//           isLoading = false;
//         });
//       } else {}
//     } catch (e) {
//       logError('Error fetching dashboard data: $e');
//     }
//   }

//   Future<void> _refreshData() async {
//     await _fetchDashboardData(selectedValue);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchDashboardData(selectedValue);
//   }

//   @override
//   Widget build(BuildContext context) {
//     double normalPadding = CustomPadding.padding * 2.2;
//     double tileWidgetBorderRadius = CustomPadding.padding * 2.5;
//     if (dashboardModel == null) {
//       return Scaffold(body: Center(child: CircularProgressIndicator()));
//     }
//     return RefreshIndicator(
//       onRefresh: _refreshData,
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(normalPadding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: CustomPadding.paddingLarge,
//                       ),
//                       child: Text('Dashboard', style: context.inter60024),
//                     ),
//                     Spacer(),
//                   ],
//                 ),
//                 Gap(CustomPadding.paddingLarge),
//                 FinancialReturnsWidget(dashboardModel: dashboardModel),
//                 Gap(normalPadding),
//                 Row(
//                   children: [
//                     Gap(normalPadding),
//                     SizedBox(
//                       width: (620 / 1440) * MediaQuery.of(context).size.width,

//                       child: Column(
//                         children: [
//                           //TODO data
//                           LineGraphWidget(
//                             data: chartData!.result!.lastSixMonthsData!,
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Spacer(),
//                     Gap(normalPadding),
//                     LogisticDataWidget(
//                       data: dashboardModel!,
//                       normalPadding: normalPadding,
//                       tileWidgetBorderRadius: tileWidgetBorderRadius,
//                     ),

//                     Gap(CustomPadding.paddingLarge),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
