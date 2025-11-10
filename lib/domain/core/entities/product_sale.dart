import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'product_sale.g.dart';

@HiveType(typeId: 3)
class ProductSale extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late double salePrice;

  @HiveField(2)
  late DateTime saleDate;

  ProductSale();

  factory ProductSale.create({required double salePrice}) {
    return ProductSale()
      ..id = const Uuid().v4()
      ..salePrice = salePrice
      ..saleDate = DateTime.now();
  }
}
