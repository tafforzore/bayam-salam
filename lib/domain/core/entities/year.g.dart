part of 'year.dart';

class YearAdapter extends TypeAdapter<Year> {
  @override
  final int typeId = 0;

  @override
  Year read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Year()
      ..id = fields[0] as String
      ..year = fields[1] as int
      ..months = (fields[2] as HiveList).castHiveList();
  }

  @override
  void write(BinaryWriter writer, Year obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.year)
      ..writeByte(2)
      ..write(obj.months);
  }
}
