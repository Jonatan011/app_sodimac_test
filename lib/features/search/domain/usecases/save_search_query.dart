import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/search_repository.dart';

class SaveSearchQueryParams {
  final String query;

  const SaveSearchQueryParams({required this.query});
}

class SaveSearchQuery implements UseCase<void, SaveSearchQueryParams> {
  final SearchRepository repository;

  const SaveSearchQuery(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveSearchQueryParams params) async => repository.saveSearchQuery(params.query);
}
