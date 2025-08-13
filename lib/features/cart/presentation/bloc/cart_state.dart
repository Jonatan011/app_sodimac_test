part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  final List<CartItem> items;
  final double total;

  const CartState({this.items = const [], this.total = 0.0});

  @override
  List<Object?> get props => [items, total];
}

class CartInitial extends CartState {
  const CartInitial() : super();
}

class CartLoading extends CartState {
  const CartLoading({super.items, super.total});
}

class CartLoaded extends CartState {
  const CartLoaded({required super.items, required super.total});
}

class CartEmpty extends CartState {
  const CartEmpty() : super();
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message, super.items, super.total});

  @override
  List<Object?> get props => [message, ...super.props];
}
