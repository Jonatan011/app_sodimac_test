import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class SearchErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const SearchErrorWidget({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text('app.error'.tr(), style: AppTextStyles.h3.copyWith(color: AppColors.error), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: Text('app.retry'.tr())),
            ],
          ),
        ),
      ),
    ),
  );
}
