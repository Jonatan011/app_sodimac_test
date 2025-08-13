import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class UpdateQuantityParams {
  final String productId;
  final int quantity;

  const UpdateQuantityParams({required this.productId, required this.quantity});
}

class UpdateQuantity implements UseCase<void, UpdateQuantityParams> {
  final CartRepository repository;

  const UpdateQuantity(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateQuantityParams params) async => repository.updateQuantity(params.productId, params.quantity);
}
