import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';

// Wrapper for search response with cache information
class SearchResult {
  final List<Product> products;
  final bool isFromCache;

  SearchResult({required this.products, required this.isFromCache});
}

abstract class SearchRepository {
  Future<Either<Failure, SearchResult>> searchProducts({required String query, required int page});

  Future<Either<Failure, List<String>>> getRecentSearches();

  Future<Either<Failure, void>> saveSearchQuery(String query);
}
