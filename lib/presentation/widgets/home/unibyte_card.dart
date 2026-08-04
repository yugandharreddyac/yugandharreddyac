import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/unibyte_provider.dart';

class UniByteCard extends StatefulWidget {
  const UniByteCard({super.key});

  @override
  State<UniByteCard> createState() => _UniByteCardState();
}

class _UniByteCardState extends State<UniByteCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleRefresh(UniByteProvider provider) {
    _animationController.forward(from: 0.0);
    provider.refreshUniByte();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<UniByteProvider>();
    final byte = provider.currentUniByte;

    const royalBlue = Color(0xFF2563EB);
    const emeraldGreen = Color(0xFF10B981);

    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? Colors.white : const Color(0xFF111827);
    final textGrey = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final dividerColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // HEADER ROW: TITLE, BADGE & REFRESH BUTTON
            // ==========================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '🧠 UniByte',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (byte.isFeatured)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.amber.withAlpha(25),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.amber.withAlpha(80)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Featured',
                                    style: GoogleFonts.inter(
                                      color: Colors.amber.shade800,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Learn something new in just 5 minutes.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _handleRefresh(provider),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: royalBlue.withAlpha(15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: royalBlue.withAlpha(30)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RotationTransition(
                          turns: _rotationAnimation,
                          child: const Icon(Icons.refresh_rounded, size: 16, color: royalBlue),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Refresh',
                          style: GoogleFonts.inter(
                            color: royalBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(height: 1, color: dividerColor),
            const SizedBox(height: 12),

            // ==========================================
            // ANIMATED CONTENT BODY (300ms Fade & Slide)
            // ==========================================
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (Widget child, Animation<double> animation) {
                final slideAnimation = Tween<Offset>(
                  begin: const Offset(0.0, 0.05),
                  end: Offset.zero,
                ).animate(animation);
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: child,
                  ),
                );
              },
              child: Container(
                key: ValueKey<String>(byte.id),
                child: Column(
                  children: [
                    _buildRowItem(
                      icon: Icons.book_rounded,
                      iconBg: royalBlue,
                      heading: 'Learn',
                      value: byte.learn,
                      textPrimary: textPrimary,
                      textGrey: textGrey,
                    ),
                    Divider(height: 16, color: dividerColor),
                    _buildRowItem(
                      icon: Icons.laptop_mac_rounded,
                      iconBg: emeraldGreen,
                      heading: 'Practice',
                      value: byte.practice,
                      textPrimary: textPrimary,
                      textGrey: textGrey,
                    ),
                    Divider(height: 16, color: dividerColor),
                    _buildRowItem(
                      icon: Icons.psychology_rounded,
                      iconBg: const Color(0xFF8B5CF6),
                      heading: 'Interview',
                      value: byte.interview,
                      textPrimary: textPrimary,
                      textGrey: textGrey,
                    ),
                    Divider(height: 16, color: dividerColor),
                    _buildRowItem(
                      icon: Icons.keyboard_rounded,
                      iconBg: const Color(0xFFF59E0B),
                      heading: 'Shortcut',
                      value: byte.shortcut,
                      textPrimary: textPrimary,
                      textGrey: textGrey,
                    ),
                    Divider(height: 16, color: dividerColor),
                    _buildRowItem(
                      icon: Icons.rocket_launch_rounded,
                      iconBg: const Color(0xFFEC4899),
                      heading: 'Technology',
                      value: byte.technology,
                      textPrimary: textPrimary,
                      textGrey: textGrey,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ==========================================
            // FOOTER: ESTIMATED TIME PILL CHIP
            // ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Estimated Time',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textGrey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: emeraldGreen.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: emeraldGreen.withAlpha(50)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer_outlined, size: 14, color: emeraldGreen),
                      const SizedBox(width: 4),
                      Text(
                        '${byte.estimatedMinutes} Minutes',
                        style: GoogleFonts.inter(
                          color: emeraldGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowItem({
    required IconData icon,
    required Color iconBg,
    required String heading,
    required String value,
    required Color textPrimary,
    required Color textGrey,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBg.withAlpha(18),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconBg, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                heading,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textGrey,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
