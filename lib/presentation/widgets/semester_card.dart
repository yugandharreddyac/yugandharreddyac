import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/semester_model.dart';

class SemesterCard extends StatefulWidget {
  final SemesterModel semester;
  final VoidCallback onTap;
  final int index;

  const SemesterCard({
    super.key,
    required this.semester,
    required this.onTap,
    this.index = 0,
  });

  @override
  State<SemesterCard> createState() => _SemesterCardState();
}

class _SemesterCardState extends State<SemesterCard> {
  bool _isHovered = false;

  String _getSemesterEmoji(String title) {
    if (title.contains('1-1')) return '🌱';
    if (title.contains('1-2')) return '📚';
    if (title.contains('2-1')) return '💻';
    if (title.contains('2-2')) return '⚙️';
    if (title.contains('3-1')) return '🌐';
    if (title.contains('3-2')) return '🤖';
    if (title.contains('4-1')) return '🚀';
    if (title.contains('4-2')) return '🎓';
    return '📚';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final emoji = _getSemesterEmoji(widget.semester.title);

    final cardBg = isDark ? AppColors.surfaceDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE4E4E7);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF09090B);
    final textSecondary = isDark ? AppColors.textSecondaryDark : const Color(0xFF71717A);
    const orangeAccent = AppColors.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: _isHovered ? (Matrix4.identity()..translate(0, -2)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _isHovered ? orangeAccent : borderColor,
            width: _isHovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? orangeAccent.withAlpha(isDark ? 40 : 25)
                  : Colors.black.withAlpha(isDark ? 20 : 5),
              blurRadius: _isHovered ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(18),
            splashColor: orangeAccent.withAlpha(20),
            highlightColor: orangeAccent.withAlpha(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  // Emoji Container
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: orangeAccent.withAlpha(isDark ? 30 : 18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.semester.title,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: textPrimary,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.semester.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: _isHovered ? orangeAccent : textSecondary.withAlpha(160),
                    size: 18,
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
