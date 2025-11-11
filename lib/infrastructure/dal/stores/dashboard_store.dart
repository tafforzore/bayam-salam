import 'package:bayamsalam/domain/core/entities/expense.dart';
import 'package:bayamsalam/domain/core/entities/month.dart';
import 'package:bayamsalam/domain/core/entities/product_sale.dart';
import 'package:collection/collection.dart';

class DashboardStats {
  final double totalIncome;
  final double totalExpenses;
  final double netProfit;
  final double totalProductCost;
  final List<dynamic> recentTransactions;

  DashboardStats({
    this.totalIncome = 0.0,
    this.totalExpenses = 0.0,
    this.netProfit = 0.0,
    this.totalProductCost = 0.0,
    this.recentTransactions = const [],
  });
}

class DashboardStore {
  DashboardStats getStatsForMonth(Month month) {
    // Total des revenus : somme des prix de vente de tous les produits vendus
    final double totalIncome =
        month.products.expand((p) => p.sales).map((s) => s.salePrice).sum;

    // Total du coût d’achat de tous les produits
    final double totalProductCost =
        month.products.map((p) => p.purchasePrice).sum;

    // Total des dépenses enregistrées manuellement
    final double manualExpenses =
        month.expenses.map((e) => e.amount).sum;

    // Total des dépenses = dépenses manuelles + coût d’achat produits
    final double totalExpenses = manualExpenses + totalProductCost;

    // Profit net
    final double netProfit = totalIncome - totalExpenses;

    // Transactions récentes : ventes + dépenses
    final List<dynamic> allTransactions = [
      ...month.products.expand((p) => p.sales),
      ...month.expenses
    ];

    // Tri décroissant par date
    allTransactions.sort((a, b) {
      final dateA = a is ProductSale ? a.saleDate : (a as Expense).createdAt;
      final dateB = b is ProductSale ? b.saleDate : (b as Expense).createdAt;
      return dateB.compareTo(dateA);
    });

    final recentTransactions = allTransactions.take(10).toList();

    return DashboardStats(
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      netProfit: netProfit,
      recentTransactions: recentTransactions,
      totalProductCost: totalProductCost,
    );
  }
}
