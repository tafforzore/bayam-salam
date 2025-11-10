import 'package:bayamsalam/domain/core/entities/expense.dart';
import 'package:bayamsalam/domain/core/entities/month.dart';
import 'package:bayamsalam/domain/core/entities/product_sale.dart';
import 'package:collection/collection.dart';

// Un objet simple pour transporter les données du rapport
class MonthlyReport {
  final double totalRevenue;
  final double totalExpenses;
  final double netResult;
  final List<ProductSale> sales;
  final List<Expense> expenses;

  MonthlyReport({
    required this.totalRevenue,
    required this.totalExpenses,
    required this.netResult,
    required this.sales,
    required this.expenses,
  });
}

class ReportStore {

  MonthlyReport generateReportForMonth(Month month) {
    // Agréger toutes les ventes de tous les produits du mois
    final allSales = month.products.expand((p) => p.sales).toList();
    allSales.sort((a, b) => b.saleDate.compareTo(a.saleDate));

    final allExpenses = month.expenses.toList();
    allExpenses.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final totalRevenue = allSales.map((s) => s.salePrice).sum;
    final totalExpenses = allExpenses.map((e) => e.amount).sum;
    final netResult = totalRevenue - totalExpenses;

    return MonthlyReport(
      totalRevenue: totalRevenue,
      totalExpenses: totalExpenses,
      netResult: netResult,
      sales: allSales,
      expenses: allExpenses,
    );
  }
}
