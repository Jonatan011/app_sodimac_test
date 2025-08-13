import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/responsive_extensions.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: AppColors.shimmerBase,
    highlightColor: AppColors.shimmerHighlight,
    child: Builder(
      builder: (context) {
        // Responsive grid configuration
        final gridConfig = ResponsiveHelper.getGridConfig(context);

        return GridView.builder(
          padding: EdgeInsets.all(gridConfig.padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridConfig.crossAxisCount,
            childAspectRatio: gridConfig.childAspectRatio,
            crossAxisSpacing: gridConfig.spacing,
            mainAxisSpacing: gridConfig.spacing,
          ),
          itemCount: 6,
          itemBuilder:
              (context, index) => Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                child: SizedBox(
                  height: 180.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image placeholder
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(12.r))),
                      ),

                      // Content placeholder
                      Expanded(
                        child: Padding(
                          padding: 3.p, // Padding responsive
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title placeholder
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 16,
                                      width: double.infinity,
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r)),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 16,
                                      width: 80,
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r)),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Price placeholder
                              Container(
                                height: 15,
                                width: 60,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r)),
                              ),

                              const SizedBox(height: 8),

                              // Button placeholder
                              Container(
                                height: 32,
                                width: double.infinity,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        );
      },
    ),
  );
}
