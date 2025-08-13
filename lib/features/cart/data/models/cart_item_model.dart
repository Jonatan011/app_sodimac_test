import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/cart_item.dart' as domain;

class CartItemModel extends domain.CartItem {
  const CartItemModel({
    required super.id,
    required super.productId,
    required super.name,
    super.imageUrl,
    required super.price,
    required super.quantity,
    required super.addedAt,
  });

  factory CartItemModel.fromDatabase(CartItem data) => CartItemModel(
    id: data.id.toString(),
    productId: data.productId,
    name: data.name,
    imageUrl: data.imageUrl,
    price: data.price,
    quantity: data.quantity,
    addedAt: data.addedAt,
  );

  factory CartItemModel.fromDomain(domain.CartItem item) => CartItemModel(
    id: item.id,
    productId: item.productId,
    name: item.name,
    imageUrl: item.imageUrl,
    price: item.price,
    quantity: item.quantity,
    addedAt: item.addedAt,
  );

  CartItemsCompanion toDatabaseCompanion() => CartItemsCompanion(
    id: Value(int.tryParse(id) ?? 0),
    productId: Value(productId),
    name: Value(name),
    imageUrl: Value(imageUrl),
    price: Value(price),
    quantity: Value(quantity),
  );

  domain.CartItem toDomain() =>
      domain.CartItem(id: id, productId: productId, name: name, imageUrl: imageUrl, price: price, quantity: quantity, addedAt: addedAt);
}
