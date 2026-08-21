import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';

class ShimmerListLoading extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const ShimmerListLoading({
    super.key,
    this.itemCount = 4,
    this.itemHeight = 100,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor:
              isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight,
          highlightColor: isDark
              ? AppColors.shimmerHighlightDark
              : AppColors.shimmerHighlightLight,
          child: Container(
            height: itemHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}
