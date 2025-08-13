import 'package:app_sodimac_test/core/usecases/usecase.dart';
import 'package:app_sodimac_test/features/cart/domain/usecases/add_to_cart.dart';
import 'package:app_sodimac_test/features/cart/domain/usecases/clear_cart.dart';
import 'package:app_sodimac_test/features/cart/domain/usecases/get_cart_total.dart';
import 'package:app_sodimac_test/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/get_cart_items.dart';
import '../../domain/usecases/update_quantity.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItems getCartItems;
  final AddToCart addToCart;
  final UpdateQuantity updateQuantity;
  final RemoveFromCart removeFromCart;
  final ClearCart clearCart;
  final GetCartTotal getCartTotal;

  CartBloc({
    required this.getCartItems,
    required this.addToCart,
    required this.updateQuantity,
    required this.removeFromCart,
    required this.clearCart,
    required this.getCartTotal,
  }) : super(const CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
  }
  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());

    final result = await getCartItems(const NoParams());

    await result.fold(
      (failure) async {
        emit(CartError(message: _mapFailureToMessage(failure)));
      },
      (items) async {
        final totalResult = await getCartTotal(const NoParams());
        totalResult.fold(
          (failure) => emit(CartError(message: _mapFailureToMessage(failure))),
          (total) => emit(CartLoaded(items: items, total: total)),
        );
      },
    );
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      emit(CartLoading(items: currentState.items, total: currentState.total));
    } else {
      emit(const CartLoading());
    }

    final result = await addToCart(AddToCartParams(item: event.item));

    result.fold((failure) => emit(CartError(message: _mapFailureToMessage(failure))), (_) => add(const LoadCartEvent()));
  }

  Future<void> _onUpdateQuantity(UpdateQuantityEvent event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      emit(CartLoading(items: currentState.items, total: currentState.total));
    } else {
      emit(const CartLoading());
    }

    final result = await updateQuantity(UpdateQuantityParams(productId: event.productId, quantity: event.quantity));

    result.fold((failure) => emit(CartError(message: _mapFailureToMessage(failure))), (_) => add(const LoadCartEvent()));
  }

  Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      emit(CartLoading(items: currentState.items, total: currentState.total));
    } else {
      emit(const CartLoading());
    }

    final result = await removeFromCart(RemoveFromCartParams(productId: event.productId));

    result.fold((failure) => emit(CartError(message: _mapFailureToMessage(failure))), (_) => add(const LoadCartEvent()));
  }

  Future<void> _onClearCart(ClearCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());

    final result = await clearCart(const NoParams());

    result.fold((failure) => emit(CartError(message: _mapFailureToMessage(failure))), (_) => emit(const CartEmpty()));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (DatabaseFailure):
        return failure.message;
      default:
        return 'Error inesperado';
    }
  }
}
