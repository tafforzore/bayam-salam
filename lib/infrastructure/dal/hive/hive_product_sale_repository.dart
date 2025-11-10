import 'package:bayamsalam/domain/core/contracts/product_sale_repository.contract.dart';
import 'package:bayamsalam/domain/core/entities/product_sale.dart';
import 'package:hive/hive.dart';

class HiveProductSaleRepository implements ProductSaleRepositoryContract {
  final Box<ProductSale> _productSaleBox;

  HiveProductSaleRepository(this._productSaleBox);

  @override
  Future<void> saveProductSale(ProductSale sale) async {
    await _productSaleBox.put(sale.id, sale);
  }

  @override
  Future<ProductSale?> getProductSale(String id) async {
    return _productSaleBox.get(id);
  }

  @override
  Future<void> updateProductSale(ProductSale sale) async {
    await sale.save();
  }

  @override
  Future<void> deleteProductSale(String id) async {
    await _productSaleBox.delete(id);
  }
}
