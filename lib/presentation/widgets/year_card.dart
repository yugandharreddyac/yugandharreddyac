import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/year_model.dart';

class YearCard extends StatefulWidget {
  final YearModel year;
  final VoidCallback onTap;
  final int index;

  const YearCard({
    super.key,
    required this.year,
    required this.onTap,
    this.index = 0,
  });

  @override
  State<YearCard> createState() => _YearCardState();
}

class _YearCardState extends State<YearCard> {
  bool _isHovered = false;

  Map<String, dynamic> _getYearStyle(int yearNum) {
    const orangeAccent = AppColors.primary;
    switch (yearNum) {
      case 1:
        return {
          'emoji': '🌱',
          'subtitle': '1st Year Foundation',
          'accent': orangeAccent,
          'icon': Icons.spa_rounded,
        };
      case 2:
        return {
          'emoji': '💻',
          'subtitle': '2nd Year Core CS',
          'accent': orangeAccent,
          'icon': Icons.code_rounded,
        };
      case 3:
        return {
          'emoji': '🚀',
          'subtitle': '3rd Year Advanced Systems',
          'accent': orangeAccent,
          'icon': Icons.rocket_launch_rounded,
        };
      case 4:
        return {
          'emoji': '🎓',
          'subtitle': '4th Year Career & Industry',
          'accent': orangeAccent,
          'icon': Icons.school_rounded,
        };
      default:
        return {
          'emoji': '📚',
          'subtitle': 'Academic Curriculum',
          'accent': orangeAccent,
          'icon': Icons.book_rounded,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final style = _getYearStyle(widget.year.yearNumber);
    final String emoji = style['emoji'];
    final String subtitle = style['subtitle'];
    final Color accentColor = style['accent'];

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: _isHovered
              ? (Matrix4.identity()..translate(0, -4))
              : Matrix4.identity(),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(20),
              splashColor: accentColor.withAlpha(40),
              highlightColor: accentColor.withAlpha(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isHovered
                        ? accentColor
                        : (isDark
                            ? AppColors.borderDark
                            : const Color(0xFFE4E4E7)),
                    width: _isHovered ? 1.8 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? accentColor.withAlpha(50)
                          : Colors.black.withAlpha(isDark ? 25 : 6),
                      blurRadius: _isHovered ? 20 : 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Badge Container
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: accentColor.withAlpha(isDark ? 35 : 20),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: accentColor.withAlpha(60),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Year Title & Subtitle Badge
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.year.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : const Color(0xFF09090B),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: accentColor.withAlpha(20),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  subtitle,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: accentColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.year.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : const Color(0xFF71717A),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Arrow Icon
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _isHovered
                            ? accentColor
                            : (isDark
                                ? AppColors.borderDark.withAlpha(50)
                                : Colors.grey.withAlpha(20)),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: _isHovered
                            ? Colors.white
                            : (isDark
                                ? AppColors.textSecondaryDark
                                : const Color(0xFF71717A)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 350.ms, delay: (widget.index * 60).ms)
            .slideY(begin: 0.08, end: 0),
      ),
    );
  }
}
