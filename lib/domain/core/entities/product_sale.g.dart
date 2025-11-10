part of 'product_sale.dart';

class ProductSaleAdapter extends TypeAdapter<ProductSale> {
  @override
  final int typeId = 3;

  @override
  ProductSale read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductSale()
      ..id = fields[0] as String
      ..salePrice = fields[1] as double
      ..saleDate = fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, ProductSale obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.salePrice)
      ..writeByte(2)
      ..write(obj.saleDate);
  }
}
