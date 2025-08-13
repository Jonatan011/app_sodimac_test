import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends Product {
  const ProductModel({required super.id, required super.displayName, super.imageUrl, required super.price, super.description, super.isAvailable});

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  factory ProductModel.fromApiJson(Map<String, dynamic> json) {
    final prices = json['prices'] as List<dynamic>?;
    final normalPriceMap = prices?.firstWhere((price) => price['type'] == 'NORMAL', orElse: () => {'priceWithoutFormatting': 0.0});

    final normalPriceValue = (normalPriceMap['priceWithoutFormatting'] ?? 0.0).toDouble();

    final mediaUrls = json['mediaUrls'] as List<dynamic>?;
    final imageUrl = mediaUrls?.isNotEmpty == true ? mediaUrls!.first : null;

    return ProductModel(
      id: json['productId']?.toString() ?? '',
      displayName: json['displayName'] ?? '',
      imageUrl: imageUrl,
      price: normalPriceValue,
      description: json['description'],
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}
