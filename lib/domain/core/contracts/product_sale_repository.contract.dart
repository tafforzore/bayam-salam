import 'package:bayamsalam/domain/core/entities/product_sale.dart';

abstract class ProductSaleRepositoryContract {
  Future<void> saveProductSale(ProductSale sale);
  Future<ProductSale?> getProductSale(String id);
  Future<void> updateProductSale(ProductSale sale);
  Future<void> deleteProductSale(String id);
}
