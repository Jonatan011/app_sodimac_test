import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class RemoveFromCartParams {
  final String productId;

  const RemoveFromCartParams({required this.productId});
}

class RemoveFromCart implements UseCase<void, RemoveFromCartParams> {
  final CartRepository repository;

  const RemoveFromCart(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveFromCartParams params) async => repository.removeFromCart(params.productId);
}
