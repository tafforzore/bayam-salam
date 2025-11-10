import 'package:bayamsalam/domain/core/contracts/month_repository.contract.dart';
import 'package:bayamsalam/domain/core/contracts/product_repository.contract.dart';
import 'package:bayamsalam/domain/core/contracts/product_sale_repository.contract.dart';
import 'package:bayamsalam/domain/core/entities/product.dart';
import 'package:bayamsalam/domain/core/entities/product_sale.dart';

class ProductService {
  final ProductRepositoryContract _productRepository;
  final ProductSaleRepositoryContract _productSaleRepository;
  final MonthRepositoryContract _monthRepository;

  ProductService(
      this._productRepository,
      this._productSaleRepository,
      this._monthRepository,
      );

  // Ajouter un produit à un mois
  Future<void> addProductToMonth(String monthId, Product product) async {
    final month = await _monthRepository.getMonth(monthId);
    if (month != null) {
      month.products.add(product);
      await _monthRepository.updateMonth(month);
    }
  }

  // Ajouter une vente à un produit
  Future<void> addSaleToProduct(String productId, ProductSale sale) async {
    final product = await _productRepository.getProduct(productId);
    if (product != null) {
      product.sales.add(sale);
      await _productRepository.updateProduct(product);
    }
  }

  // ✅ Créer un nouveau produit
  // Future<Product> createProduct(Product product) async {
  //   return await _productRepository.createProduct(product);
  // }
  //
  // ✅ Obtenir un produit par son ID
  Future<Product?> getProductById(String productId) async {
    return await _productRepository.getProduct(productId);
  }
  //
  // // ✅ Obtenir tous les produits
  // Future<List<Product>> getAllProducts() async {
  //   return await _productRepository.getAllProducts();
  // }

  // ✅ Mettre à jour un produit existant
  Future<void> updateProduct(Product product) async {
    await _productRepository.updateProduct(product);
  }

  // ✅ Supprimer un produit
  Future<void> deleteProduct(String productId) async {
    await _productRepository.deleteProduct(productId);
  }

  // ✅ Obtenir toutes les ventes d’un produit
  Future<List<ProductSale>> getSalesForProduct(String productId) async {
    final product = await _productRepository.getProduct(productId);
    return product?.sales ?? [];
  }

  // ✅ Calculer le total des ventes d’un produit
  Future<double> getTotalSalesAmount(String productId) async {
    final sales = await getSalesForProduct(productId);
    double total = 0.0;
    for (final sale in sales) {
      final price = await sale.salePrice; // si c’est Future<double>
      total += price;
    }
    return total;
  }


  // ✅ Obtenir les produits d’un mois donné
  Future<List<Product>> getProductsByMonth(String monthId) async {
    final month = await _monthRepository.getMonth(monthId);
    return month?.products ?? [];
  }

  // ✅ Supprimer un produit d’un mois
  Future<void> removeProductFromMonth(String monthId, String productId) async {
    final month = await _monthRepository.getMonth(monthId);
    if (month != null) {
      month.products.removeWhere((p) => p.id == productId);
      await _monthRepository.updateMonth(month);
    }
  }

  // ✅ Supprimer une vente d’un produit
  Future<void> removeSaleFromProduct(String productId, String saleId) async {
    final product = await _productRepository.getProduct(productId);
    if (product != null) {
      product.sales.removeWhere((s) => s.id == saleId);
      await _productRepository.updateProduct(product);
    }
  }

  // ✅ Calculer le total des ventes d’un mois
  Future<double> getTotalSalesForMonth(String monthId) async {
    final month = await _monthRepository.getMonth(monthId);
    if (month == null) return 0.0;

    double total = 0.0;
    for (final product in month.products) {
      final sales = await getSalesForProduct(product.id);
      total += sales.fold(0.0, (sum, sale) => sum + sale.salePrice);
    }
    return total;
  }

  // ✅ Obtenir les meilleures ventes d’un mois (top produits)
  Future<List<Product>> getTopSellingProducts(String monthId,
      {int limit = 5}) async {
    final month = await _monthRepository.getMonth(monthId);
    if (month == null) return [];

    final products = month.products;

    products.sort((a, b) {
      final totalA = a.sales.fold(0.0, (sum, s) => sum + s.salePrice);
      final totalB = b.sales.fold(0.0, (sum, s) => sum + s.salePrice);
      return totalB.compareTo(totalA);
    });

    return products.take(limit).toList();
  }
}
