import 'package:bayamsalam/domain/core/entities/expense.dart';
import 'package:bayamsalam/domain/core/entities/product_sale.dart';
import 'package:bayamsalam/infrastructure/dal/stores/dashboard_store.dart';
import 'package:bayamsalam/infrastructure/dal/stores/month_store.dart';
import 'package:bayamsalam/infrastructure/dal/stores/year_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController with WidgetsBindingObserver {
  final YearStore _yearStore = Get.find();
  final MonthStore _monthStore = Get.find();
  final DashboardStore _dashboardStore = Get.find();

  final isLoading = true.obs;
  final currentMonthName = ''.obs;
  final stats = DashboardStats().obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadDashboard();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  /// Détecte quand l'application revient au premier plan
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadDashboard();
    }
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    try {
      final now = DateTime.now();
      currentMonthName.value = DateFormat.MMMM('fr_FR').format(now);

      final year = await _yearStore.getOrCreate(now.year);
      final month = await _monthStore.getOrCreateInYear(year, currentMonthName.value);
      
      stats.value = _dashboardStore.getStatsForMonth(month);

    } catch (e) {
      Get.snackbar('Erreur de chargement', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Fonctions utilitaires pour la vue
  bool isSale(dynamic transaction) => transaction is ProductSale;
  String getTransactionTitle(dynamic transaction) {
    if (isSale(transaction)) {
      return 'Nouvelle vente'; // On pourrait chercher le nom du produit si nécessaire
    }
    return (transaction as Expense).description;
  }

  String getTransactionAmount(dynamic transaction) {
    if (isSale(transaction)) {
      return '+ ${(transaction as ProductSale).salePrice.toStringAsFixed(2)} FCFA';
    }
    return '- ${(transaction as Expense).amount.toStringAsFixed(2)} FCFA';
  }

  DateTime getTransactionDate(dynamic transaction) {
    return isSale(transaction) ? (transaction as ProductSale).saleDate : (transaction as Expense).createdAt;
  }
}
