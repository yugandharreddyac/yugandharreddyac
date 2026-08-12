import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: _isHovered ? (Matrix4.identity()..translate(0, -3)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: const Color(0xFF1565C0), // Primary Blue #1565C0
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(_isHovered ? 60 : 35),
              blurRadius: _isHovered ? 14 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Small & Elegant Emoji
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  // Title
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.yearTitle,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Subtitle
                  Flexible(
                    child: Text(
                      widget.subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withAlpha(220),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
