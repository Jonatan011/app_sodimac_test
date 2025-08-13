import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();

  Future<Either<Failure, CartItem?>> getCartItem(String productId);

  Future<Either<Failure, void>> addToCart(CartItem item);

  Future<Either<Failure, void>> updateQuantity(String productId, int quantity);

  Future<Either<Failure, void>> removeFromCart(String productId);

  Future<Either<Failure, void>> clearCart();

  Future<Either<Failure, int>> getCartItemCount();

  Future<Either<Failure, double>> getCartTotal();
}
