part of 'expense.dart';

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 4;

  @override
  Expense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Expense()
      ..id = fields[0] as String
      ..description = fields[1] as String
      ..amount = fields[2] as double
      ..category = fields[3] as ExpenseCategory
      // Ajout du champ manquant avec une valeur par défaut pour les anciennes données
      ..createdAt = fields[4] as DateTime? ?? DateTime.now(); 
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer
      ..writeByte(5) // On a maintenant 5 champs
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.createdAt);
  }
}

class ExpenseCategoryAdapter extends TypeAdapter<ExpenseCategory> {
  @override
  final int typeId = 5;

  @override
  ExpenseCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExpenseCategory.rent;
      case 1:
        return ExpenseCategory.transport;
      case 2:
        return ExpenseCategory.food;
      case 3:
        return ExpenseCategory.other;
      default:
        return ExpenseCategory.rent;
    }
  }

  @override
  void write(BinaryWriter writer, ExpenseCategory obj) {
    switch (obj) {
      case ExpenseCategory.rent:
        writer.writeByte(0);
        break;
      case ExpenseCategory.transport:
        writer.writeByte(1);
        break;
      case ExpenseCategory.food:
        writer.writeByte(2);
        break;
      case ExpenseCategory.other:
        writer.writeByte(3);
        break;
        default:
        writer.writeByte(0);
        break;
    }
  }
}
