import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class GetCartTotal implements UseCase<double, NoParams> {
  final CartRepository repository;

  const GetCartTotal(this.repository);

  @override
  Future<Either<Failure, double>> call(NoParams params) async => repository.getCartTotal();
}
