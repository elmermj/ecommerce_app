// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductDataModelAdapter extends TypeAdapter<ProductDataModel> {
  @override
  final int typeId = 1;

  @override
  ProductDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductDataModel(
      qty: fields[0] as int,
      productName: fields[1] as String,
      productPrice: fields[2] as double,
      productDesc: fields[3] as String,
      productImageUrl: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductDataModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.qty)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.productPrice)
      ..writeByte(3)
      ..write(obj.productDesc)
      ..writeByte(4)
      ..write(obj.productImageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
