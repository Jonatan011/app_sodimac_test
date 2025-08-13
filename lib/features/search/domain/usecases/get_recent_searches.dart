import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/search_repository.dart';

class GetRecentSearches implements UseCase<List<String>, NoParams> {
  final SearchRepository repository;

  const GetRecentSearches(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async => repository.getRecentSearches();
}
