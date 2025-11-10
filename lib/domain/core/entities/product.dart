import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'product_sale.dart';

part 'product.g.dart';

@HiveType(typeId: 2)
class Product extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late double purchasePrice;

  @HiveField(3)
  late HiveList<ProductSale> sales;

  // Constructeur vide pour l'usage exclusif de Hive
  Product();

  // Factory pour créer de nouvelles instances
  factory Product.create({required String name, required double purchasePrice}) {
    final newProduct = Product()
      ..id = const Uuid().v4()
      ..name = name
      ..purchasePrice = purchasePrice
      ..sales = HiveList(Hive.box<ProductSale>('product_sales'));
    return newProduct;
  }
}
