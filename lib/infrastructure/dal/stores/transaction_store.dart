import 'package:bayamsalam/domain/core/entities/expense.dart';
import 'package:bayamsalam/domain/core/entities/product_sale.dart';
import 'package:bayamsalam/domain/core/entities/year.dart';
import 'package:hive/hive.dart';

class TransactionStore {
  /// Récupère toutes les transactions (ventes et dépenses) de la base de données.
  Future<List<dynamic>> getAllTransactions() async {
    final yearBox = Hive.box<Year>('years');
    final List<dynamic> allTransactions = [];

    // Parcourt toutes les années, puis tous les mois
    for (var year in yearBox.values) {
      for (var month in year.months) {
        // Ajoute toutes les ventes de tous les produits de ce mois
        allTransactions.addAll(month.products.expand((p) => p.sales));
        // Ajoute toutes les dépenses de ce mois
        allTransactions.addAll(month.expenses);
      }
    }

    // Trie la liste globale par date, du plus récent au plus ancien
    allTransactions.sort((a, b) {
      final dateA = a is ProductSale ? a.saleDate : (a as Expense).createdAt;
      final dateB = b is ProductSale ? b.saleDate : (b as Expense).createdAt;
      return dateB.compareTo(dateA); // Ordre décroissant
    });

    return allTransactions;
  }
}
