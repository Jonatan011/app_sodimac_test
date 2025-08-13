import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({super.key, required this.item, required this.onQuantityChanged, required this.onRemove});

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                item.imageUrl != null
                    ? CachedNetworkImage(
                      imageUrl: item.imageUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) =>
                              Container(width: 80, height: 80, color: AppColors.shimmerBase, child: const Center(child: CircularProgressIndicator())),
                      errorWidget:
                          (context, url, error) => Container(
                            width: 80,
                            height: 80,
                            color: AppColors.shimmerBase,
                            child: const Icon(Icons.image_not_supported, color: AppColors.textSecondary),
                          ),
                    )
                    : Container(
                      width: 80,
                      height: 80,
                      color: AppColors.shimmerBase,
                      child: const Icon(Icons.image_not_supported, color: AppColors.textSecondary),
                    ),
          ),

          const SizedBox(width: 12),

          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppTextStyles.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),

                const SizedBox(height: 8),

                Text('\$${item.price.toStringAsFixed(2)}', style: AppTextStyles.priceSmall),

                const SizedBox(height: 8),

                // Quantity controls
                Row(
                  children: [
                    Text('cart.quantity'.tr(), style: AppTextStyles.bodySmall),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: item.quantity > 1 ? () => onQuantityChanged(item.quantity - 1) : null,
                      icon: const Icon(Icons.remove),
                      iconSize: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(4)),
                      child: Text(item.quantity.toString(), style: AppTextStyles.bodyMedium),
                    ),
                    IconButton(onPressed: () => onQuantityChanged(item.quantity + 1), icon: const Icon(Icons.add), iconSize: 20),
                  ],
                ),
              ],
            ),
          ),

          // Remove button
          IconButton(onPressed: onRemove, icon: const Icon(Icons.delete_outline), color: AppColors.error),
        ],
      ),
    ),
  );
}
