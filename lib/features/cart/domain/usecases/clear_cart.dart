import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class ClearCart implements UseCase<void, NoParams> {
  final CartRepository repository;

  const ClearCart(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async => repository.clearCart();
}
