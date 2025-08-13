import 'package:app_sodimac_test/core/constants/app_colors.dart';
import 'package:app_sodimac_test/core/constants/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/cart_bloc.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/empty_cart_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartBloc _cartBloc;

  @override
  void initState() {
    super.initState();
    _cartBloc = getIt<CartBloc>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Always load cart items when the page is shown
    _cartBloc.add(const LoadCartEvent());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('cart.title'.tr()),
      actions: [
        BlocBuilder<CartBloc, CartState>(
          bloc: _cartBloc,
          builder: (context, state) {
            if (state is CartLoaded && state.items.isNotEmpty) {
              return IconButton(icon: const Icon(Icons.clear_all), onPressed: () => _showClearCartDialog());
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    ),
    body: BlocBuilder<CartBloc, CartState>(
      bloc: _cartBloc,
      builder: (context, state) {
        if (state is CartInitial || state is CartLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CartError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                const SizedBox(height: 16),
                Text(state.message, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _cartBloc.add(const LoadCartEvent()), child: Text('app.retry'.tr())),
              ],
            ),
          );
        }

        if (state is CartEmpty) {
          return const EmptyCartWidget();
        }

        if (state is CartLoaded) {
          if (state.items.isEmpty) {
            return const EmptyCartWidget();
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final isTablet = screenWidth >= 600;

              return Column(
                children: [
                  // Cart items list
                  Expanded(
                    child:
                        isTablet
                            ? GridView.builder(
                              padding: EdgeInsets.all(screenWidth * 0.02),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.5,
                                crossAxisSpacing: screenWidth * 0.02,
                                mainAxisSpacing: screenWidth * 0.02,
                              ),
                              itemCount: state.items.length,
                              itemBuilder: (context, index) {
                                final item = state.items[index];
                                return CartItemWidget(
                                  item: item,
                                  onQuantityChanged: (quantity) {
                                    _cartBloc.add(UpdateQuantityEvent(productId: item.productId, quantity: quantity));
                                  },
                                  onRemove: () {
                                    _cartBloc.add(RemoveFromCartEvent(productId: item.productId));
                                  },
                                );
                              },
                            )
                            : ListView.builder(
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              itemCount: state.items.length,
                              itemBuilder: (context, index) {
                                final item = state.items[index];
                                return CartItemWidget(
                                  item: item,
                                  onQuantityChanged: (quantity) {
                                    _cartBloc.add(UpdateQuantityEvent(productId: item.productId, quantity: quantity));
                                  },
                                  onRemove: () {
                                    _cartBloc.add(RemoveFromCartEvent(productId: item.productId));
                                  },
                                );
                              },
                            ),
                  ),

                  // Cart summary
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2))],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('cart.total'.tr(), style: AppTextStyles.h4),
                            Text('\$${state.total.toStringAsFixed(2)}', style: AppTextStyles.price),
                          ],
                        ),
                        SizedBox(height: screenWidth * 0.04),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Checkout logic will be implemented
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(const SnackBar(content: Text('Checkout functionality coming soon!'), backgroundColor: AppColors.info));
                            },
                            child: Text('cart.checkout'.tr()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    ),
  );

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('cart.clear_cart'.tr()),
            content: const Text('¿Estás seguro de que quieres vaciar el carrito?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('app.cancel'.tr())),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _cartBloc.add(const ClearCartEvent());
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                child: Text('cart.clear_cart'.tr()),
              ),
            ],
          ),
    );
  }
}
