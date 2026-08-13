import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/datasources/educational_content_provider.dart';

class EducationalLoadingCard extends StatefulWidget {
  final String? loadingMessage;
  final bool isError;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool isEmpty;
  final String? emptyTitle;
  final String? emptyMessage;
  final String? emptyActionText;
  final VoidCallback? onEmptyAction;

  const EducationalLoadingCard({
    super.key,
    this.loadingMessage,
    this.isError = false,
    this.errorMessage,
    this.onRetry,
    this.isEmpty = false,
    this.emptyTitle,
    this.emptyMessage,
    this.emptyActionText,
    this.onEmptyAction,
  });

  @override
  State<EducationalLoadingCard> createState() => _EducationalLoadingCardState();
}

class _EducationalLoadingCardState extends State<EducationalLoadingCard> {
  late int _currentIndex;
  Timer? _rotationTimer;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    if (!widget.isError && !widget.isEmpty) {
      _startRotationTimer();
    }
  }

  void _startRotationTimer() {
    _rotationTimer?.cancel();
    _rotationTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % EducationalContentProvider.allItems.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _rotationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? Colors.white : const Color(0xFF111827);
    final textSubtitle = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    // ==========================================
    // 1. ERROR STATE
    // ==========================================
    if (widget.isError) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.red, size: 36),
            const SizedBox(height: 10),
            Text(
              'Something went wrong',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.errorMessage ?? 'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: textSubtitle,
              ),
            ),
            if (widget.onRetry != null) ...[
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: widget.onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: Text('Retry', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ],
        ),
      );
    }

    // ==========================================
    // 2. EMPTY STATE
    // ==========================================
    if (widget.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.inbox_rounded, color: Color(0xFF2563EB), size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              widget.emptyTitle ?? 'Nothing here yet',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.emptyMessage ?? 'Content will appear here as soon as available.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: textSubtitle,
              ),
            ),
            if (widget.onEmptyAction != null && widget.emptyActionText != null) ...[
              const SizedBox(height: 14),
              OutlinedButton(
                onPressed: widget.onEmptyAction,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                ),
                child: Text(widget.emptyActionText!, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              ),
            ],
          ],
        ),
      );
    }

    // ==========================================
    // 3. EDUCATIONAL LOADING STATE
    // ==========================================
    final currentItem = EducationalContentProvider.allItems[_currentIndex];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 8),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: currentItem.accentColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(currentItem.icon, color: currentItem.accentColor, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    currentItem.categoryLabel,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: currentItem.accentColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Loading...',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: textSubtitle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(currentItem.accentColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Column(
              key: ValueKey<String>(currentItem.id),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentItem.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  currentItem.content,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 1.35,
                    color: textSubtitle,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
