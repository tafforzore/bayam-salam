import 'package:bayamsalam/domain/core/entities/expense.dart';

abstract class ExpenseRepositoryContract {
  Future<void> saveExpense(Expense expense);
  Future<Expense?> getExpense(String id);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);
}
