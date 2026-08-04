import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';

class AcademicThumbnailCard extends StatefulWidget {
  final String yearTitle;
  final String subtitle;
  final String description;
  final String yearId;
  final Color primaryAccent;
  final List<IconData> themeIcons;
  final List<String> themeBadges;
  final Gradient bannerGradient;

  const AcademicThumbnailCard({
    super.key,
    required this.yearTitle,
    required this.subtitle,
    required this.description,
    required this.yearId,
    required this.primaryAccent,
    required this.themeIcons,
    required this.themeBadges,
    required this.bannerGradient,
  });

  @override
  State<AcademicThumbnailCard> createState() => _AcademicThumbnailCardState();
}

class _AcademicThumbnailCardState extends State<AcademicThumbnailCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);

    const royalBlue = Color(0xFF2563EB);
    const emeraldGreen = Color(0xFF10B981);

    final scale = _isPressed ? 0.97 : (_isHovered ? 1.02 : 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
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
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: _isHovered ? widget.primaryAccent.withAlpha(180) : borderColor,
                width: _isHovered ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? widget.primaryAccent.withAlpha(isDark ? 50 : 35)
                      : Colors.black.withAlpha(isDark ? 40 : 10),
                  blurRadius: _isHovered ? 20 : 12,
                  offset: Offset(0, _isHovered ? 8 : 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==========================================
                  // TOP 60%: ILLUSTRATION / BANNER
                  // ==========================================
                  Expanded(
                    flex: 6,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: widget.bannerGradient,
                      ),
                      child: Stack(
                        children: [
                          // Vector Decorative Background Orbs
                          Positioned(
                            top: -20,
                            right: -20,
                            child: Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withAlpha(25),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -30,
                            left: -15,
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withAlpha(20),
                              ),
                            ),
                          ),

                          // Vector Graphic Theme Icons Centerpiece
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: widget.themeIcons.map((ic) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 4),
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withAlpha(45),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white.withAlpha(80),
                                              width: 1.2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withAlpha(20),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Icon(ic, color: Colors.white, size: 18),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 6),

                                    // Vector Theme Topic Badges
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: widget.themeBadges.map((badge) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withAlpha(40),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.white.withAlpha(50)),
                                          ),
                                          child: Text(
                                            badge,
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Top-Left Year Badge
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(220),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(20),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.yearTitle,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF0F172A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ==========================================
                  // BOTTOM 40%: CONTENT & ACTION CHIPS
                  // ==========================================
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.yearTitle,
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: textPrimary,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      Text(
                                        widget.subtitle,
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: widget.primaryAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  // Small Resource Chips: Notes • PYQs • Syllabus
                                  Row(
                                    children: [
                                      _buildChip('Notes', royalBlue),
                                      const SizedBox(width: 4),
                                      _buildChip('PYQs', emeraldGreen),
                                      const SizedBox(width: 4),
                                      _buildChip('Syllabus', const Color(0xFF8B5CF6)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 6),

                          // Circular Arrow Action Button (Right side)
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: widget.primaryAccent.withAlpha(20),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: widget.primaryAccent.withAlpha(60),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: widget.primaryAccent,
                              size: 16,
                            ),
                          ),
                        ],
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

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(40), width: 0.8),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
