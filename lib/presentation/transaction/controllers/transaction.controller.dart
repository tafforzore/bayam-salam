import 'package:bayamsalam/domain/core/entities/expense.dart';
import 'package:bayamsalam/domain/core/entities/product_sale.dart';
import 'package:bayamsalam/infrastructure/dal/stores/transaction_store.dart';
import 'package:get/get.dart';

enum PeriodFilter { day, week, month, all }
enum TypeFilter { all, sales, expenses }

class TransactionController extends GetxController {
  final TransactionStore _transactionStore = Get.find();

  final isLoading = true.obs;
  final periodFilter = PeriodFilter.all.obs;
  final typeFilter = TypeFilter.all.obs;

  final _allTransactions = <dynamic>[].obs;
  final filteredTransactions = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadAllTransactions();
  }

  Future<void> _loadAllTransactions() async {
    isLoading.value = true;
    try {
      _allTransactions.assignAll(await _transactionStore.getAllTransactions());
      _applyFilters();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger l\'historique.');
    } finally {
      isLoading.value = false;
    }
  }

  void setPeriodFilter(PeriodFilter filter) {
    periodFilter.value = filter;
    _applyFilters();
  }

  void setTypeFilter(TypeFilter filter) {
    typeFilter.value = filter;
    _applyFilters();
  }

  void _applyFilters() {
    List<dynamic> temp = _allTransactions;

    // 1. Filtrer par type
    if (typeFilter.value == TypeFilter.sales) {
      temp = temp.where((t) => isSale(t)).toList();
    } else if (typeFilter.value == TypeFilter.expenses) {
      temp = temp.where((t) => !isSale(t)).toList();
    }

    // 2. Filtrer par période
    final now = DateTime.now();
    if (periodFilter.value == PeriodFilter.day) {
      temp = temp.where((t) => getTransactionDate(t).day == now.day && getTransactionDate(t).month == now.month && getTransactionDate(t).year == now.year).toList();
    } else if (periodFilter.value == PeriodFilter.week) {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      temp = temp.where((t) => getTransactionDate(t).isAfter(startOfWeek)).toList();
    } else if (periodFilter.value == PeriodFilter.month) {
      temp = temp.where((t) => getTransactionDate(t).month == now.month && getTransactionDate(t).year == now.year).toList();
    }

    filteredTransactions.assignAll(temp);
  }

  // Fonctions utilitaires pour la vue
  bool isSale(dynamic transaction) => transaction is ProductSale;
  DateTime getTransactionDate(dynamic transaction) => isSale(transaction) ? (transaction as ProductSale).saleDate : (transaction as Expense).createdAt;
  String getTransactionTitle(dynamic transaction) => isSale(transaction) ? 'Vente' : (transaction as Expense).description;
  String getTransactionAmount(dynamic transaction) {
    final amount = isSale(transaction) ? (transaction as ProductSale).salePrice : (transaction as Expense).amount;
    final sign = isSale(transaction) ? '+' : '-';
    return '$sign ${amount.toStringAsFixed(0)} FCFA';
  }
}
