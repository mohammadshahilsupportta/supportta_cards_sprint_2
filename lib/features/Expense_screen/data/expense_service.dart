import 'package:taproot_admin/core/api/base_url_constant.dart';
import 'package:taproot_admin/core/api/dio_helper.dart';
import 'package:taproot_admin/core/logger.dart';
import 'package:taproot_admin/features/Expense_screen/data/expense_model.dart';

class ExpenseService {
  static Future<ExpenseResponse> getExpense(
    int page, {
    String? category,
    String? searchQuery,
    String? startDate
  }) async {
    try {
      final response = await DioHelper().get(
        '/expense',
        type: ApiType.baseUrl,
        queryParameters: {
          'page': page,
          'limit': 5,
          if (category != null && category != 'All') 'category': category,
          if (searchQuery != null && searchQuery.isNotEmpty)
            'search': searchQuery,
                    if (startDate != null && startDate.isNotEmpty) 'startDate': startDate,

        },
      );

      if (response.statusCode == 200) {
        return ExpenseResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load expenses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching expenses: $e');
    }
  }

  static Future<ExpenseResponse> addExpense({
    required String category,
    required String name,
    required double amount,
    required String description,
    required DateTime date,
  }) async {
    try {
      final data = {
        'category': category,
        'name': name,
        'amount': amount,
        'description': description,
        'date': date.toIso8601String(),
      };

      logInfo('Adding expense with data: $data');

      final response = await DioHelper().post(
        '/expense',
        type: ApiType.baseUrl,
        data: data,
      );

      logInfo('Add expense response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ExpenseResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to add expense: ${response.statusMessage}');
      }
    } catch (e) {
      logError('Error adding expense: $e');
      throw Exception('Failed to add expense: $e');
    }
  }
static Future<ExpenseResponse> editExpense({
    required Expense expense,
    String? category,
    String? name,
    double? amount,
    String? description,
    DateTime? date,
  }) async {
    try {
      
      final updatedExpense = expense.copyWith(
        category: category,
        name: name,
        amount: amount,
        description: description,
        date: date,
      );

      final data = updatedExpense.toJson();
      
      data.remove('_id');
      data.remove('isDeleted');
      data.remove('createdAt');

      logInfo('Editing expense: ${expense.id} with data: $data');

      final response = await DioHelper().patch(
        '/expense/${expense.id}',
        type: ApiType.baseUrl,
        data: data,
      );

      logInfo('Edit expense response: ${response.data}');

      if (response.statusCode == 200) {
        return ExpenseResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to edit expense: ${response.statusMessage}');
      }
    } catch (e) {
      logError('Error editing expense: $e');
      throw Exception('Failed to edit expense: $e');
    }
  }

}
