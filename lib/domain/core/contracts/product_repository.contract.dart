import 'package:bayamsalam/domain/core/entities/product.dart';

abstract class ProductRepositoryContract {
  Future<void> saveProduct(Product product);
  Future<Product?> getProduct(String id);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}
