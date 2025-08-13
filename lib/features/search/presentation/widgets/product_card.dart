import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/responsive_extensions.dart';
import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({super.key, required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) => Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product image
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child:
                product.imageUrl != null
                    ? CachedNetworkImage(
                      imageUrl: product.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder:
                          (context, url) =>
                              Container(color: AppColors.shimmerBase, child: Center(child: CircularProgressIndicator(strokeWidth: 2.w))),
                      errorWidget:
                          (context, url, error) => Container(
                            color: AppColors.shimmerBase,
                            child: Icon(Icons.image_not_supported, size: 6.w, color: AppColors.textSecondary),
                          ),
                    )
                    : Container(color: AppColors.shimmerBase, child: Icon(Icons.image_not_supported, size: 6.w, color: AppColors.textSecondary)),
          ),
        ),

        // Product info
        Expanded(
          flex: 3,
          child: Padding(
            padding: 3.p, // Padding responsive
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      product.displayName,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 3.5.sp, // Font size responsive
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                // Price
                Center(
                  child: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: AppTextStyles.priceSmall.copyWith(
                      fontSize: 4.sp, // Font size responsive
                    ),
                  ),
                ),
                SizedBox(height: 1.h),

                // Add to cart button
                SizedBox(
                  width: double.infinity,
                  height: 4.h, // Button height responsive
                  child: ElevatedButton(
                    onPressed: product.isAvailable ? onAddToCart : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      textStyle: AppTextStyles.buttonSmall.copyWith(
                        fontSize: 3.2.sp, // Font size responsive
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text(product.isAvailable ? 'product.add_to_cart'.tr() : 'product.out_of_stock'.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
