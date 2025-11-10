import 'package:bayamsalam/domain/core/entities/expense.dart';
import 'package:bayamsalam/domain/core/entities/month.dart';
import 'package:bayamsalam/domain/core/entities/product_sale.dart';
import 'package:collection/collection.dart';

class DashboardStats {
  final double totalIncome;
  final double totalExpenses;
  final double netProfit;
  final List<dynamic> recentTransactions;

  DashboardStats({
    this.totalIncome = 0.0,
    this.totalExpenses = 0.0,
    this.netProfit = 0.0,
    this.recentTransactions = const [],
  });
}

class DashboardStore {

  DashboardStats getStatsForMonth(Month month) {
    final double totalIncome = month.products.expand((p) => p.sales).map((s) => s.salePrice).sum;
    final double totalExpenses = month.expenses.map((e) => e.amount).sum;
    final double netProfit = totalIncome - totalExpenses;

    final List<dynamic> allTransactions = [...month.products.expand((p) => p.sales), ...month.expenses];

    // CORRECTION : Tri correct en utilisant la date de chaque type de transaction
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
    );
  }
}
