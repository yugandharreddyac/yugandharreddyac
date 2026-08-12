import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;

  const BreadcrumbItem({
    required this.label,
    this.onTap,
  });
}

class BreadcrumbBar extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const BreadcrumbBar({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final activeTextColor = isDark ? Colors.white : const Color(0xFF1E293B);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFDBEAFE),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _buildBreadcrumbs(textColor, activeTextColor),
        ),
      ),
    );
  }

  List<Widget> _buildBreadcrumbs(Color textColor, Color activeTextColor) {
    final List<Widget> widgets = [];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == items.length - 1;

      widgets.add(
        InkWell(
          onTap: isLast ? null : item.onTap,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              item.label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isLast ? FontWeight.bold : FontWeight.w500,
                color: isLast ? activeTextColor : textColor,
              ),
            ),
          ),
        ),
      );

      if (!isLast) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: textColor.withAlpha(180),
            ),
          ),
        );
      }
    }

    return widgets;
  }
}
