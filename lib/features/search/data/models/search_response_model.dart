import 'package:json_annotation/json_annotation.dart';
import 'product_model.dart';

part 'search_response_model.g.dart';

@JsonSerializable()
class SearchResponseModel {
  final List<ProductModel> results;
  final int totalResults;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const SearchResponseModel({
    required this.results,
    required this.totalResults,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) => _$SearchResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseModelToJson(this);

  factory SearchResponseModel.fromApiJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final results = data['results'] as List<dynamic>? ?? [];

    final products = results.map((item) => ProductModel.fromApiJson(item)).toList();

    return SearchResponseModel(
      results: products,
      totalResults: data['totalResults'] ?? 0,
      currentPage: data['currentPage'] ?? 1,
      totalPages: data['totalPages'] ?? 1,
      hasMore: (data['currentPage'] ?? 1) < (data['totalPages'] ?? 1),
    );
  }
}
