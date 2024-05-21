// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_cart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShoppingCartModelAdapter extends TypeAdapter<ShoppingCartModel> {
  @override
  final int typeId = 2;

  @override
  ShoppingCartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShoppingCartModel(
      products: (fields[0] as List).cast<ProductDataModel>(),
      subTotal: fields[1] as double,
      total: fields[2] as double,
      shoppingCartId: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ShoppingCartModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.products)
      ..writeByte(1)
      ..write(obj.subTotal)
      ..writeByte(2)
      ..write(obj.total)
      ..writeByte(3)
      ..write(obj.shoppingCartId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingCartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
