import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String displayName;
  final String? imageUrl;
  final double price;
  final String? description;
  final bool isAvailable;

  const Product({required this.id, required this.displayName, this.imageUrl, required this.price, this.description, this.isAvailable = true});

  @override
  List<Object?> get props => [id, displayName, imageUrl, price, description, isAvailable];

  Product copyWith({String? id, String? displayName, String? imageUrl, double? price, String? description, bool? isAvailable}) => Product(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    imageUrl: imageUrl ?? this.imageUrl,
    price: price ?? this.price,
    description: description ?? this.description,
    isAvailable: isAvailable ?? this.isAvailable,
  );
}
