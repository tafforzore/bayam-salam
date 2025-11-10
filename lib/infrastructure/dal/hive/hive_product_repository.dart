import 'package:bayamsalam/domain/core/contracts/product_repository.contract.dart';
import 'package:bayamsalam/domain/core/entities/product.dart';
import 'package:hive/hive.dart';

class HiveProductRepository implements ProductRepositoryContract {
  final Box<Product> _productBox;

  HiveProductRepository(this._productBox);

  @override
  Future<void> saveProduct(Product product) async {
    await _productBox.put(product.id, product);
  }

  @override
  Future<Product?> getProduct(String id) async {
    return _productBox.get(id);
  }

  @override
  Future<void> updateProduct(Product product) async {
    await product.save();
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _productBox.delete(id);
  }
}
