import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';

class AcademicYearCard extends StatefulWidget {
  final String yearTitle;
  final String subtitle;
  final String yearId;

  // Retaining optional legacy constructor fields for backward compatibility
  final LinearGradient? gradient;
  final List<IconData>? themeIcons;
  final List<String>? themeBadges;
  final Color? primaryColor;

  const AcademicYearCard({
    super.key,
    required this.yearTitle,
    required this.subtitle,
    required this.yearId,
    this.gradient,
    this.themeIcons,
    this.themeBadges,
    this.primaryColor,
  });

  @override
  State<AcademicYearCard> createState() => _AcademicYearCardState();
}

class _AcademicYearCardState extends State<AcademicYearCard> {
  bool _isHovered = false;

  String _getYearEmoji(String title) {
    if (title.contains('1st') || title.contains('1')) return '🌱';
    if (title.contains('2nd') || title.contains('2')) return '💻';
    if (title.contains('3rd') || title.contains('3')) return '🚀';
    if (title.contains('4th') || title.contains('4')) return '🎓';
    return '🌱';
  }

  @override
  Widget build(BuildContext context) {
    final emoji = _getYearEmoji(widget.yearTitle);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceDark : Colors.white;
    final borderCol = isDark ? AppColors.borderDark : const Color(0xFFE4E4E7);
    final textCol = isDark ? AppColors.textPrimaryDark : const Color(0xFF09090B);
    final subtitleCol = isDark ? AppColors.textSecondaryDark : const Color(0xFF71717A);
    const orangeAccent = AppColors.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: _isHovered ? (Matrix4.identity()..translate(0, -3)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? orangeAccent : borderCol,
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(_isHovered ? 25 : 6),
              blurRadius: _isHovered ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.semesters,
                arguments: {
                  'yearId': widget.yearId,
                  'yearTitle': widget.yearTitle,
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    // Emoji Badge
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: orangeAccent.withAlpha(isDark ? 30 : 18),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: orangeAccent.withAlpha(40)),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Title, Subtitle & Metadata
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.yearTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: textCol,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: orangeAccent.withAlpha(15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '2 Sem',
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: orangeAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        Text(
                          widget.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: subtitleCol,
                          ),
                        ),
                      ],
                    ),

                    // Arrow Action
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: _isHovered ? orangeAccent : subtitleCol.withAlpha(150),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
