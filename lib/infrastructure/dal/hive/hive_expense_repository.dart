import 'package:bayamsalam/domain/core/contracts/expense_repository.contract.dart';
import 'package:bayamsalam/domain/core/entities/expense.dart';
import 'package:hive/hive.dart';

class HiveExpenseRepository implements ExpenseRepositoryContract {
  final Box<Expense> _expenseBox;

  HiveExpenseRepository(this._expenseBox);

  @override
  Future<void> saveExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense);
  }

  @override
  Future<Expense?> getExpense(String id) async {
    return _expenseBox.get(id);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    await expense.save();
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _expenseBox.delete(id);
  }
}
