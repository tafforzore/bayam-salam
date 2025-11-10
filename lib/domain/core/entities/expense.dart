import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'expense.g.dart';

@HiveType(typeId: 4)
class Expense extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String description;
  @HiveField(2)
  late double amount;
  @HiveField(3)
  late ExpenseCategory category;
  @HiveField(4)
  late DateTime createdAt; // CHAMP AJOUTÉ

  Expense();

  factory Expense.create({
    required String description,
    required double amount,
    required ExpenseCategory category,
  }) {
    return Expense()
      ..id = const Uuid().v4()
      ..description = description
      ..amount = amount
      ..category = category
      ..createdAt = DateTime.now(); // Initialisation automatique
  }
}

@HiveType(typeId: 5)
enum ExpenseCategory {
  @HiveField(0)
  rent,
  @HiveField(1)
  transport,
  @HiveField(2)
  food,
  @HiveField(3)
  other,
  @HiveField(3)
  marketing,
  @HiveField(3)
  utilities,
  @HiveField(3)
  salary,
  @HiveField(3)
  equipment,
  @HiveField(3)
  supplies,
}
