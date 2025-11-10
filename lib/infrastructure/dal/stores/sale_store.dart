import 'package:bayamsalam/domain/core/entities/month.dart';
import 'package:bayamsalam/domain/core/entities/product.dart';
import 'package:bayamsalam/domain/core/entities/product_sale.dart';
import 'package:hive/hive.dart';

class SaleStore {

  Future<ProductSale> addSale(Product product, double salePrice) async {
    final newSale = ProductSale.create(salePrice: salePrice);

    // On doit d'abord enregistrer l'objet "enfant" dans sa propre boîte
    final saleBox = Hive.box<ProductSale>('product_sales');
    await saleBox.put(newSale.id, newSale);

    // Puis on le lie au parent et on sauvegarde le parent
    product.sales.add(newSale);
    await product.save();

    return newSale;
  }

  Future<void> updateSale(ProductSale sale, double newSalePrice) async {
    sale.salePrice = newSalePrice;
    await sale.save();
  }

  /// La suppression est l'opération la plus complexe.
  Future<void> deleteSale(Month month, ProductSale saleToDelete) async {
    // 1. Trouver le produit parent qui contient cette vente
    Product? parentProduct;
    for (var product in month.products) {
      if (product.sales.any((s) => s.id == saleToDelete.id)) {
        parentProduct = product;
        break;
      }
    }

    if (parentProduct != null) {
      // 2. Retirer la référence de la liste du parent et sauvegarder
      parentProduct.sales.remove(saleToDelete);
      await parentProduct.save();
    }

    // 3. Supprimer l'objet vente de sa propre boîte
    await saleToDelete.delete();
  }
}
