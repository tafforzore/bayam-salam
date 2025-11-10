import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'product.dart';
import 'expense.dart';

part 'month.g.dart';

@HiveType(typeId: 1)
class Month extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late HiveList<Product> products;

  @HiveField(3)
  late HiveList<Expense> expenses;

  // Constructeur vide pour l'usage exclusif de Hive
  Month();

  // Factory pour créer de nouvelles instances
  factory Month.create({required String name}) {
    final newMonth = Month()
      ..id = const Uuid().v4()
      ..name = name
      ..products = HiveList(Hive.box<Product>('products'))
      ..expenses = HiveList(Hive.box<Expense>('expenses'));
    return newMonth;
  }
}
