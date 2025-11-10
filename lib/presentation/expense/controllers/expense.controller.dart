import 'package:bayamsalam/domain/core/entities/expense.dart';
import 'package:bayamsalam/domain/core/entities/month.dart';
import 'package:bayamsalam/infrastructure/dal/stores/expense_store.dart';
import 'package:bayamsalam/infrastructure/dal/stores/month_store.dart';
import 'package:bayamsalam/infrastructure/dal/stores/year_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExpenseController extends GetxController {
  final YearStore _yearStore = Get.find();
  final MonthStore _monthStore = Get.find();
  final ExpenseStore _expenseStore = Get.find();

  final descriptionController = TextEditingController();
  final amountController = TextEditingController();

  final isLoading = true.obs;
  final isEditing = false.obs;
  final expenses = <Expense>[].obs;
  final selectedCategory = Rxn<ExpenseCategory>();

  late Month _currentMonth;
  Expense? _editingExpense;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      final now = DateTime.now();
      final year = await _yearStore.getOrCreate(now.year);
      _currentMonth = await _monthStore.getOrCreateInYear(year, DateFormat.MMMM('fr_FR').format(now));
      expenses.assignAll(_currentMonth.expenses.toList());
    } catch (e) {
      Get.snackbar('Erreur Critique', 'Impossible de charger l\'environnement: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addExpense() async {
    final category = selectedCategory.value;
    final amount = double.tryParse(amountController.text);
    if (category != null && amount != null && descriptionController.text.isNotEmpty) {
      final newExpense = await _expenseStore.addExpenseToMonth(
        _currentMonth,
        descriptionController.text,
        amount,
        category,
      );
      expenses.add(newExpense);
      _clearForm();
    }
  }

  void startEditing(Expense expense) {
    descriptionController.text = expense.description;
    amountController.text = expense.amount.toString();
    selectedCategory.value = expense.category;
    isEditing.value = true;
    _editingExpense = expense;
  }

  Future<void> updateExpense() async {
    final category = selectedCategory.value;
    final amount = double.tryParse(amountController.text);
    if (_editingExpense != null && category != null && amount != null) {
      await _expenseStore.updateExpense(_editingExpense!, descriptionController.text, amount, category);
      expenses.refresh();
      _clearForm();
    }
  }

  Future<void> deleteExpense(Expense expense) async {
    await _expenseStore.deleteExpenseFromMonth(_currentMonth, expense);
    expenses.remove(expense);
  }

  void _clearForm() {
    descriptionController.clear();
    amountController.clear();
    selectedCategory.value = null;
    isEditing.value = false;
    _editingExpense = null;
  }

  String getCategoryName(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.rent: return 'Loyer';
      case ExpenseCategory.transport: return 'Transport';
      case ExpenseCategory.food: return 'Nourriture';
      case ExpenseCategory.other: return 'Autre';
      case ExpenseCategory.equipment: return 'Matériel';
      case ExpenseCategory.marketing: return 'Marketing';
      case ExpenseCategory.utilities: return 'Utilitaires';
      case ExpenseCategory.salary: return 'Salaire';
      case ExpenseCategory.supplies: return 'Fournitures';
    }
  }

  IconData getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.rent: return Icons.house_outlined;
      case ExpenseCategory.transport: return Icons.directions_car_outlined;
      case ExpenseCategory.food: return Icons.restaurant_outlined;
      case ExpenseCategory.other: return Icons.receipt_long_outlined;
      case ExpenseCategory.equipment: return Icons.build_outlined;
      case ExpenseCategory.marketing: return Icons.shopping_cart_outlined;
      case ExpenseCategory.utilities: return Icons.umbrella_outlined;
      case ExpenseCategory.rent: return Icons.house_outlined;
      case ExpenseCategory.salary: return Icons.money_off_csred_outlined;
      case ExpenseCategory.supplies: return Icons.contact_support_rounded;
    }
  }
}
