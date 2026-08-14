import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
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

    final orangeAccent = AppColors.primary;
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE4E4E7);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF09090B);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF71717A);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 6),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: orangeAccent.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.psychology_rounded, color: orangeAccent, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'CS QUICK BYTE',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: orangeAccent,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _handleRefresh(provider),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: RotationTransition(
                    turns: _rotationAnimation,
                    child: Icon(Icons.refresh_rounded, size: 18, color: textSubtitle),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            byte.learn,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${byte.learn} works efficiently on data structures. Practice "${byte.practice}" or prepare interview questions like "${byte.interview}".',
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.35,
              color: textSubtitle,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, AppRoutes.codingHub),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Learn more',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: orangeAccent,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 14, color: orangeAccent),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
