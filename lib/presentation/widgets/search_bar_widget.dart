import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final String hintText;

  const SearchBarWidget({
    super.key,
    this.controller,
    required this.onChanged,
    this.onClear,
    this.hintText = 'Search subjects...',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 20 : 6),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color:
                isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 22,
          ),
          suffixIcon: controller != null && controller!.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : const Color(0xFF64748B),
                  onPressed: () {
                    controller!.clear();
                    onChanged('');
                    if (onClear != null) onClear!();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
