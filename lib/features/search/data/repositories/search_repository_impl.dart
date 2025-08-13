import 'package:app_sodimac_test/core/database/app_database.dart';
import 'package:app_sodimac_test/core/errors/exceptions.dart';
import 'package:app_sodimac_test/features/search/domain/repositories/search_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final AppDatabase database;

  const SearchRepositoryImpl({required this.remoteDataSource, required this.database});

  @override
  Future<Either<Failure, SearchResult>> searchProducts({required String query, required int page}) async {
    try {
      final response = await remoteDataSource.searchProducts(query: query, page: page);

      // Save search query to history
      await database.addSearchHistory(query);

      return Right(SearchResult(products: response.data.results, isFromCache: response.isFromCache));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRecentSearches() async {
    try {
      final searches = await database.getRecentSearches();
      return Right(searches.map((s) => s.query).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSearchQuery(String query) async {
    try {
      await database.addSearchHistory(query);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
