part of 'month.dart';

class MonthAdapter extends TypeAdapter<Month> {
  @override
  final int typeId = 1;

  @override
  Month read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Month()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..products = (fields[2] as HiveList).castHiveList()
      ..expenses = (fields[3] as HiveList).castHiveList();
  }

  @override
  void write(BinaryWriter writer, Month obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.products)
      ..writeByte(3)
      ..write(obj.expenses);
  }
}
