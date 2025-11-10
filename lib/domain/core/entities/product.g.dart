part of 'product.dart';

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 2;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..purchasePrice = fields[2] as double
      ..sales = (fields[3] as HiveList).castHiveList();
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.purchasePrice)
      ..writeByte(3)
      ..write(obj.sales);
  }
}
