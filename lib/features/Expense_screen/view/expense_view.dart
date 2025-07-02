import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/Expense_screen/data/expense_model.dart';
import 'package:taproot_admin/features/Expense_screen/data/expense_service.dart';
import 'package:taproot_admin/features/Expense_screen/widgets/add_expense.dart';
import 'package:taproot_admin/features/Expense_screen/widgets/edit_expense.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';
import 'package:taproot_admin/widgets/not_found_widget.dart';
import 'package:taproot_admin/widgets/snakbar_helper.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});
  static const path = '/expenseScreen';

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  int _currentPage = 1;
  final int _rowsPerPage = 5;
  bool _isLoading = false;
  late ExpenseResponse _expenseResponse;
  List<Expense> _expenses = [];
  String? _currentCategory;
  String searchQuery = '';
  Timer? _debounce;
  // final _tableKey = GlobalKey<PaginatedDataTableState>();

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _fetchExpensesWithDate(String? pickedDate) async {
    setState(() => _isLoading = true);
    try {
      logInfo('Fetching page: $_currentPage');
      final response = await ExpenseService.getExpense(
        _currentPage,
        category: _currentCategory,
        searchQuery: searchQuery,
        startDate: pickedDate,
      );
      logInfo(
        'Response received: ${response.results.length} items, Total pages: ${response.totalPages}',
      );

      if (mounted) {
        setState(() {
          _expenseResponse = response;
          _expenses = response.results;
          _isLoading = false;
        });
      }
    } catch (e) {
      logError('Error fetching expenses: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        // SnackbarHelper.showError(context, 'Error loading expenses: $e');
      }
    }
  }

  Future<void> _fetchExpenses() async {
    setState(() => _isLoading = true);
    try {
      logInfo('Fetching page: $_currentPage');
      final response = await ExpenseService.getExpense(
        _currentPage,
        category: _currentCategory,
        searchQuery: searchQuery,
      );
      logInfo(
        'Response received: ${response.results.length} items, Total pages: ${response.totalPages}',
      );

      if (mounted) {
        setState(() {
          _expenseResponse = response;
          _expenses = response.results;
          _isLoading = false;
        });
      }
    } catch (e) {
      logError('Error fetching expenses: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        SnackbarHelper.showError(context, 'Error loading expenses: $e');
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        // appBar: AppBar(title: const Text('Expense')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Gap(CustomPadding.paddingLarge.v),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MiniLoadingButton(
                    icon: Icons.add,
                    text: 'Add Expense',
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddExpense()),
                      );
                      if (result == true) {
                        _fetchExpenses();
                      }
                      // Add expense logic
                    },
                    useGradient: true,
                    gradientColors: CustomColors.borderGradient.colors,
                  ),
                  Gap(CustomPadding.paddingXL.v),
                ],
              ),
              Gap(CustomPadding.paddingLarge.v),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: CustomPadding.paddingLarge.v,
                  vertical: CustomPadding.paddingLarge.v,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: CustomPadding.paddingLarge.v,
                ),
                decoration: BoxDecoration(
                  boxShadow: floatingShadowLarge,

                  color: CustomColors.secondaryColor,
                  borderRadius: BorderRadius.circular(
                    CustomPadding.paddingLarge * 2,
                  ),
                ),
                width: double.infinity,
                height: 900.v,
                // height: SizeUtils.height / 1.1,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        // SortButton(),
                        Gap(CustomPadding.padding.v),
                        GestureDetector(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime.utc(2020),
                              lastDate: DateTime.now(),
                            ).then((selectedDate) {
                              _fetchExpensesWithDate(selectedDate.toString());

                              if (selectedDate != null) {
                                // Handle the selected date here
                                logInfo('Selected date: $selectedDate');
                              }
                            });
                          },
                          child: Container(
                            width: 110.v,
                            height: 40.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                CustomPadding.paddingXXL.v,
                              ),
                              border: Border.all(
                                color: CustomColors.textColorLightGrey,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Filter', style: context.inter50014),
                                Gap(CustomPadding.padding.v),
                                Icon(
                                  LucideIcons.filter,
                                  color: CustomColors.textColorGrey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    TabBar(
                      unselectedLabelColor: CustomColors.hintGrey,
                      unselectedLabelStyle: context.inter50016,
                      labelColor: CustomColors.textColor,
                      labelStyle: context.inter50016,
                      isScrollable: true,
                      indicatorColor: CustomColors.greenDark,
                      indicatorWeight: 4,
                      dragStartBehavior: DragStartBehavior.start,
                      onTap: (index) {
                        setState(() {
                          _currentPage = 1;
                          _currentCategory =
                              index == 0
                                  ? null
                                  : ['All', 'Order', 'Shop', 'Other'][index];
                        });
                        _fetchExpenses();
                      },
                      tabs: [
                        Tab(text: 'All'),
                        Tab(text: 'Order'),
                        Tab(text: 'Shop'),
                        Tab(text: 'Other'),
                      ],
                    ),
                    Gap(CustomPadding.paddingXL.v),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildPaginatedDataTable(),
                          _buildPaginatedDataTable(),

                          _buildPaginatedDataTable(),

                          _buildPaginatedDataTable(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Gap(CustomPadding.paddingXXL.v),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaginatedDataTable() {
    TextStyle headingTextStyle = context.inter50016.copyWith(
      fontSize: 16.fSize,
      // color: Colors.red,
      // fontWeight: FontWeight
    );
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_expenses.isEmpty) {
      return const NotFoundWidget();
    }

    return SizedBox(
      height: 70.v,
      child: PaginatedDataTable(
        arrowHeadColor: CustomColors.borderGradient.colors.first,

        dataRowMaxHeight: SizeUtils.height * 0.11,
        source: ExpenseDataSource(
          _expenses,
          _expenseResponse.totalCount,
          context,
          _fetchExpenses,
        ),
        header: null,
        rowsPerPage: _rowsPerPage,
        availableRowsPerPage: [5],
        initialFirstRowIndex: (_currentPage - 1) * _rowsPerPage,
        showFirstLastButtons: true,
        onPageChanged: (firstRowIndex) {
          final newPage = (firstRowIndex ~/ _rowsPerPage) + 1;
          logInfo('Changing to page: $newPage');

          if (newPage != _currentPage) {
            setState(() {
              _currentPage = newPage;
            });
            _fetchExpenses();
          }
        },
        columns: [
          DataColumn(label: Text('Expense Category', style: headingTextStyle)),
          DataColumn(
            label: Text('Order ID /Expense name', style: headingTextStyle),
          ),
          DataColumn(label: Text('Description', style: headingTextStyle)),
          DataColumn(label: Text('Amount', style: headingTextStyle)),
          DataColumn(label: Text('Date', style: headingTextStyle)),
          DataColumn(label: Text('Edit', style: headingTextStyle)),
        ],
      ),
    );
  }

  // Widget _buildPaginatedDataTable() {
  //   return _isLoading
  //       ? Center(child: CircularProgressIndicator())
  //       : SizedBox(
  //         height: 70.v,
  //         child: PaginatedDataTable(
  //           dataRowMaxHeight: 100,
  //           source: ExpenseDataSource(
  //             _expenses,
  //             _expenseResponse.totalCount,
  //             context,
  //             _fetchExpenses,
  //           ),
  //           header: null,
  //           rowsPerPage: _rowsPerPage,
  //           availableRowsPerPage: [5],
  //           initialFirstRowIndex: (_currentPage - 1) * _rowsPerPage,
  //           showFirstLastButtons: true,
  //           onPageChanged: (firstRowIndex) {
  //             // Calculate the new page number (1-based)
  //             final newPage = (firstRowIndex ~/ _rowsPerPage) + 1;
  //             logInfo('Changing to page: $newPage');

  //             // Only fetch if we're actually changing pages
  //             if (newPage != _currentPage) {
  //               setState(() {
  //                 _currentPage = newPage;
  //               });
  //               _fetchExpenses();
  //             }
  //           },
  //           columns: [
  //             DataColumn(label: Text('Expense Category')),
  //             DataColumn(label: Text('Order ID /Expense name')),
  //             DataColumn(label: Text('Description')),
  //             DataColumn(label: Text('Amount')),
  //             DataColumn(label: Text('Date')),
  //             DataColumn(label: Text('Edit')),
  //           ],
  //         ),
  //       );
  // }
}

class ExpenseDataSource extends DataTableSource {
  final List<Expense> _expenses;
  final int totalCount;
  final BuildContext context;
  final VoidCallback? onRefresh;

  ExpenseDataSource(
    this._expenses,
    this.totalCount,
    this.context,
    this.onRefresh,
  );

  @override
  DataRow? getRow(int index) {
    // Calculate the relative index within the current page
    final relativeIndex = index % _expenses.length;

    // Only return rows for valid indices
    if (relativeIndex >= _expenses.length) {
      return null;
    }

    final expense = _expenses[relativeIndex];
    return DataRow(
      cells: [
        DataCell(
          Center(
            child: Text(expense.category, style: TextStyle(fontSize: 16.fSize)),
          ),
        ),
        DataCell(
          Center(
            child: Text(expense.name, style: TextStyle(fontSize: 16.fSize)),
          ),
        ),
        DataCell(
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (BuildContext context) => AlertDialog(
                      title: const Text("Lead Description"),
                      content: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 700,
                          maxHeight: 300,
                        ),
                        child: Scrollbar(
                          thickness: 2,
                          radius: const Radius.circular(4),
                          child: SingleChildScrollView(
                            child: Text(
                              expense.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: CustomColors.hintGrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Close"),
                        ),
                      ],
                    ),
              );
            },
            child: Center(
              child: const Text(
                "View",
                style: TextStyle(
                  color: CustomColors.buttonColor1,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        // DataCell(
        //   ExpenseDescriptionContainer(children: [Text(expense.description)]),
        // ),
        DataCell(
          Center(
            child: Text(
              '₹${expense.amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16.fSize),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              DateFormat('MMM dd, yyyy').format(expense.date),
              style: TextStyle(fontSize: 16.fSize),
            ),
          ),
        ),
        DataCell(
          Center(
            child: IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditExpense(expense: expense),
                  ),
                );
                if (result == true) {
                  onRefresh?.call();
                }
              },
              icon: Icon(LucideIcons.edit, color: CustomColors.buttonColor1),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => totalCount;

  @override
  int get selectedRowCount => 0;
}

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:taproot_admin/exporter/exporter.dart';
// import 'package:taproot_admin/features/Expense_screen/widgets/expense_description_container.dart';
// import 'package:taproot_admin/features/Expense_screen/widgets/filter_button.dart';
// import 'package:taproot_admin/features/product_screen/widgets/search_widget.dart';
// import 'package:taproot_admin/features/product_screen/widgets/sort_button.dart';
// import 'package:taproot_admin/widgets/mini_loading_button.dart';

// class ExpenseView extends StatefulWidget {
//   const ExpenseView({super.key});
//   static const path = '/expenseScreen';

//   @override
//   State<ExpenseView> createState() => _ExpenseViewState();
// }

// class _ExpenseViewState extends State<ExpenseView> {
//   List<Map<String, String>> expenses = [];
//   //  void addExpense(Map<String, String> expense) {
//   //   setState(() {
//   //     expenses.add(expense);
//   //   });
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Gap(CustomPadding.paddingLarge.v),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   MiniLoadingButton(
//                     icon: Icons.add,
//                     text: 'Add Expense',
//                     onPressed: () {},
//                     // onPressed: () async{
//                     //    final newExpense = await Navigator.of(context).push(
//                     //     MaterialPageRoute(
//                     //       builder: (context) => AddExpense(),
//                     //     ),
//                     //   );
//                     //   if (newExpense != null) {
//                     //     addExpense(newExpense); // Add the new expense to the list
//                     //   }
//                     // },
//                     useGradient: true,
//                     gradientColors: CustomColors.borderGradient.colors,
//                   ),
//                   Gap(CustomPadding.paddingXL.v),
//                 ],
//               ),
//               Gap(CustomPadding.paddingLarge.v),

//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: CustomPadding.paddingLarge.v,
//                   vertical: CustomPadding.paddingLarge.v,
//                 ),
//                 margin: EdgeInsets.symmetric(
//                   horizontal: CustomPadding.paddingLarge.v,
//                 ),
//                 decoration: BoxDecoration(
//                   color: CustomColors.secondaryColor,
//                   borderRadius: BorderRadius.circular(
//                     CustomPadding.paddingLarge.v,
//                   ),
//                 ),
//                 width: double.infinity,
//                 height: SizeUtils.height / 1.3,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         SearchWidget(hintText: 'Search Order ID, Username'),
//                         Spacer(),
//                         SortButton(),
//                         Gap(CustomPadding.padding.v),

//                         FilterButton(),
//                       ],
//                     ),

//                     TabBar(
//                       unselectedLabelColor: CustomColors.hintGrey,

//                       unselectedLabelStyle: context.inter50016,
//                       labelColor: CustomColors.textColor,
//                       labelStyle: context.inter50016,
//                       isScrollable: true,
//                       indicatorColor: CustomColors.greenDark,
//                       indicatorWeight: 4,
//                       dragStartBehavior: DragStartBehavior.start,
//                       tabs: [
//                         Tab(text: 'All'),
//                         Tab(text: 'Order'),
//                         Tab(text: 'Shop'),
//                         Tab(text: 'Other'),
//                       ],
//                     ),
//                     Gap(CustomPadding.paddingXL.v),
//                     Expanded(
//                       child: TabBarView(
//                         children: [
//                           DataTable(
//                             dataRowMaxHeight: 110,
//                             columns: [
//                               DataColumn(label: Text('Expense Category')),
//                               DataColumn(label: Text('Expense name')),
//                               DataColumn(label: Text('Description')),
//                               DataColumn(label: Text('Amount')),
//                               DataColumn(label: Text('Date')),
//                             ],
//                             rows:
//                                 expenses.map((expense) {
//                                   return DataRow(
//                                     cells: [
//                                       DataCell(
//                                         Center(
//                                           child: Text(
//                                             expense['category'] ?? '',
//                                           ),
//                                         ),
//                                       ),
//                                       DataCell(
//                                         Center(
//                                           child: Text(expense['name'] ?? ''),
//                                         ),
//                                       ),
//                                       DataCell(
//                                         ExpenseDescriptionContainer(
//                                           children: [
//                                             Text(expense['description'] ?? ''),
//                                           ],
//                                         ),
//                                       ),
//                                       DataCell(
//                                         Center(
//                                           child: Text(
//                                             expense['amount'] ?? '₹0',
//                                           ),
//                                         ),
//                                       ),
//                                       DataCell(
//                                         Center(
//                                           child: Text(expense['date'] ?? ''),
//                                         ),
//                                       ),
//                                     ],
//                                   );
//                                 }).toList(),
//                           ),
//                           Center(child: Text('Order')),
//                           Center(child: Text('Shop')),
//                           Center(child: Text('other')),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
