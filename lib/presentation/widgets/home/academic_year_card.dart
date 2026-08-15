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

  ({String emoji, IconData icon, String semText, Color accentColor}) _getYearMetadata(String title, String yearId) {
    if (title.contains('1st') || yearId == 'year_1') {
      return (
        emoji: '🌱',
        icon: Icons.looks_one_rounded,
        semText: 'Sem 1 & 2',
        accentColor: const Color(0xFF10B981), // Emerald Green
      );
    }
    if (title.contains('2nd') || yearId == 'year_2') {
      return (
        emoji: '💻',
        icon: Icons.looks_two_rounded,
        semText: 'Sem 3 & 4',
        accentColor: const Color(0xFF3B82F6), // Tech Blue
      );
    }
    if (title.contains('3rd') || yearId == 'year_3') {
      return (
        emoji: '🚀',
        icon: Icons.looks_3_rounded,
        semText: 'Sem 5 & 6',
        accentColor: const Color(0xFF8B5CF6), // Purple
      );
    }
    if (title.contains('4th') || yearId == 'year_4') {
      return (
        emoji: '🎓',
        icon: Icons.looks_4_rounded,
        semText: 'Sem 7 & 8',
        accentColor: const Color(0xFFF59E0B), // Amber / Gold
      );
    }
    return (
      emoji: '🌱',
      icon: Icons.school_rounded,
      semText: '2 Semesters',
      accentColor: AppColors.primary,
    );
  }

  void _navigateToSemesters() {
    Navigator.pushNamed(
      context,
      AppRoutes.semesters,
      arguments: {
        'yearId': widget.yearId,
        'yearTitle': widget.yearTitle,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final meta = _getYearMetadata(widget.yearTitle, widget.yearId);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceDark : Colors.white;
    final borderCol = isDark ? AppColors.borderDark : const Color(0xFFE4E4E7);
    final textCol = isDark ? AppColors.textPrimaryDark : const Color(0xFF09090B);
    final subtitleCol = isDark ? AppColors.textSecondaryDark : const Color(0xFF71717A);
    final activeAccent = widget.primaryColor ?? meta.accentColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _navigateToSemesters,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          transform: _isHovered ? (Matrix4.identity()..translate(0, -3)) : Matrix4.identity(),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? activeAccent : borderCol,
              width: _isHovered ? 1.8 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: activeAccent.withAlpha(_isHovered ? 35 : 10),
                blurRadius: _isHovered ? 14 : 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Distinct Icon Badge with Emoji Overlay
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: activeAccent.withAlpha(isDark ? 35 : 18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: activeAccent.withAlpha(50)),
                    ),
                    child: Icon(meta.icon, color: activeAccent, size: 24),
                  ),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: cardBg,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        meta.emoji,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Title, Semester Pill & Subtitle
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 2,
                        children: [
                          Text(
                            widget.yearTitle,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textCol,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: activeAccent.withAlpha(isDark ? 30 : 15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: activeAccent.withAlpha(40)),
                            ),
                            child: Text(
                              meta.semText,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: activeAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: subtitleCol,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Action Arrow Icon
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _isHovered ? activeAccent.withAlpha(20) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: _isHovered ? activeAccent : subtitleCol.withAlpha(160),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
