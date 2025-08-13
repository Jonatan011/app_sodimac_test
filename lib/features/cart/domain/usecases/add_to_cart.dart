import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class AddToCartParams {
  final CartItem item;

  const AddToCartParams({required this.item});
}

class AddToCart implements UseCase<void, AddToCartParams> {
  final CartRepository repository;

  const AddToCart(this.repository);

  @override
  Future<Either<Failure, void>> call(AddToCartParams params) async => repository.addToCart(params.item);
}
