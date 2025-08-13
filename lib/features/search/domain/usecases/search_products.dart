import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/search_repository.dart';

class SearchProductsParams {
  final String query;
  final int page;

  const SearchProductsParams({required this.query, required this.page});
}

// Wrapper for use case result with cache information
class SearchProductsResult {
  final List<Product> products;
  final bool isFromCache;

  SearchProductsResult({required this.products, required this.isFromCache});
}

class SearchProducts implements UseCase<SearchProductsResult, SearchProductsParams> {
  final SearchRepository repository;

  const SearchProducts(this.repository);

  @override
  Future<Either<Failure, SearchProductsResult>> call(SearchProductsParams params) async {
    final result = await repository.searchProducts(query: params.query, page: params.page);
    return result.map((searchResult) => SearchProductsResult(products: searchResult.products, isFromCache: searchResult.isFromCache));
  }
}
