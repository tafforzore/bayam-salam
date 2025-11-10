import 'package:bayamsalam/domain/core/contracts/expense_repository.contract.dart';
import 'package:bayamsalam/domain/core/contracts/month_repository.contract.dart';
import 'package:bayamsalam/domain/core/entities/expense.dart';

class ExpenseService {
  final ExpenseRepositoryContract _expenseRepository;
  final MonthRepositoryContract _monthRepository;

  ExpenseService(this._expenseRepository, this._monthRepository);

  Future<void> addExpenseToMonth(String monthId, Expense expense) async {
    final month = await _monthRepository.getMonth(monthId);
    if (month != null) {
      month.expenses.add(expense);
      await _monthRepository.updateMonth(month);
    }
  }

  // Autres logiques liées aux dépenses...
}
