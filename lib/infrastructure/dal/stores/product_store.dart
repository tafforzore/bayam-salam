import 'package:bayamsalam/domain/core/entities/month.dart';
import 'package:bayamsalam/domain/core/entities/product.dart';
import 'package:hive/hive.dart';

class ProductStore {

  Future<Product> addProductToMonth(Month month, String name, double purchasePrice) async {
    // 1. Créer le nouvel objet "enfant" en mémoire.
    final newProduct = Product.create(
      name: name,
      purchasePrice: purchasePrice,
    );

    // 2. Le sauvegarder dans sa propre boîte pour le rendre "officiel".
    final productBox = Hive.box<Product>('products');
    await productBox.put(newProduct.id, newProduct);

    // 3. Maintenant, lier l'enfant au parent.
    month.products.add(newProduct);

    // 4. Sauvegarder le parent pour persister la relation.
    await month.save();

    return newProduct;
  }

  Future<void> updateProduct(Product product, String newName, double newPurchasePrice) async {
    product.name = newName;
    product.purchasePrice = newPurchasePrice;
    await product.save();
  }

  Future<void> deleteProductFromMonth(Month month, Product product) async {
    month.products.remove(product);
    await month.save();
    await product.delete();
  }
}
