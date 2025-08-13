import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String id;
  final String productId;
  final String name;
  final String? imageUrl;
  final double price;
  final int quantity;
  final DateTime addedAt;

  const CartItem({
    required this.id,
    required this.productId,
    required this.name,
    this.imageUrl,
    required this.price,
    required this.quantity,
    required this.addedAt,
  });

  double get total => price * quantity;

  @override
  List<Object?> get props => [id, productId, name, imageUrl, price, quantity, addedAt];

  CartItem copyWith({String? id, String? productId, String? name, String? imageUrl, double? price, int? quantity, DateTime? addedAt}) => CartItem(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    name: name ?? this.name,
    imageUrl: imageUrl ?? this.imageUrl,
    price: price ?? this.price,
    quantity: quantity ?? this.quantity,
    addedAt: addedAt ?? this.addedAt,
  );
}
