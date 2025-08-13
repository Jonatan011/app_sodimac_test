import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class RecentSearches extends StatelessWidget {
  const RecentSearches({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search, size: 64, color: AppColors.textSecondary),
        const SizedBox(height: 16),
        Text('search.title'.tr(), style: AppTextStyles.h2.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Text('app.search'.tr(), style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
      ],
    ),
  );
}
