import 'package:bayamsalam/domain/core/entities/expense.dart';
import 'package:bayamsalam/domain/core/entities/month.dart';
import 'package:hive/hive.dart';

class ExpenseStore {

  Future<Expense> addExpenseToMonth(Month month, String description, double amount, ExpenseCategory category) async {
    final newExpense = Expense.create(
      description: description,
      amount: amount,
      category: category,
    );

    final expenseBox = Hive.box<Expense>('expenses');
    await expenseBox.put(newExpense.id, newExpense);

    month.expenses.add(newExpense);
    await month.save();

    return newExpense;
  }

  Future<void> updateExpense(Expense expense, String newDescription, double newAmount, ExpenseCategory newCategory) async {
    expense.description = newDescription;
    expense.amount = newAmount;
    expense.category = newCategory;
    await expense.save();
  }

  Future<void> deleteExpenseFromMonth(Month month, Expense expense) async {
    month.expenses.remove(expense);
    await month.save();
    await expense.delete();
  }
}
