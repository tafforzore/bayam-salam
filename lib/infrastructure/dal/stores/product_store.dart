import 'package:bayamsalam/domain/core/entities/expense.dart';
import 'package:bayamsalam/domain/core/entities/month.dart';
import 'package:bayamsalam/domain/core/entities/product.dart';
import 'package:hive/hive.dart';

class ProductStore {

  Future<Product> addProductToMonth(Month month, String name, double purchasePrice) async {
    // 1. Créer le nouvel objet produit
    final newProduct = Product.create(
      name: name,
      purchasePrice: purchasePrice,
    );
    // 2. Le sauvegarder dans sa propre boîte pour le rendre "officiel"
    final productBox = Hive.box<Product>('products');
    await productBox.put(newProduct.id, newProduct);

    // 3. CRÉER LA DÉPENSE ASSOCIÉE
    final newExpense = Expense.create(
      description: 'Achat stock: ${newProduct.name}',
      amount: purchasePrice,
      category: ExpenseCategory.other, // On pourrait créer une catégorie "Stock"
    );
    // 4. Sauvegarder la dépense dans sa propre boîte
    final expenseBox = Hive.box<Expense>('expenses');
    await expenseBox.put(newExpense.id, newExpense);

    // 5. Ajouter les deux nouveaux objets aux listes du mois parent
    month.products.add(newProduct);
    month.expenses.add(newExpense);
    
    // 6. Sauvegarder le mois pour persister les nouvelles relations
    await month.save();

    return newProduct;
  }

  Future<void> updateProduct(Product product, String newName, double newPurchasePrice) async {
    product.name = newName;
    product.purchasePrice = newPurchasePrice;
    await product.save();
  }

  Future<void> deleteProductFromMonth(Month month, Product product) async {
    // Note: Cela ne supprime pas la dépense d'achat associée.
    month.products.remove(product);
    await month.save();
    await product.delete();
  }
}
