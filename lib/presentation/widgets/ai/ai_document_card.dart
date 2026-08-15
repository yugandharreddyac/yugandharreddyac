import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/document_models.dart';

/// Interactive card widget displaying document status, page count, and quick RAG prompt triggers
class AiDocumentCard extends StatelessWidget {
  final DocumentMetadata metadata;
  final VoidCallback onRemove;
  final ValueChanged<String>? onActionSelected;
  final bool isCompact;

  const AiDocumentCard({
    super.key,
    required this.metadata,
    required this.onRemove,
    this.onActionSelected,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isReady = metadata.isReady;
    final isInProgress = metadata.isInProgress;
    final isError = metadata.isFailed || metadata.isUnsupported;

    final borderColor = isError
        ? (isDark ? Colors.redAccent.withAlpha(80) : Colors.red.withAlpha(80))
        : isReady
            ? (isDark ? AppColors.success.withAlpha(100) : AppColors.primary.withAlpha(80))
            : (isDark ? Colors.white12 : Colors.black12);

    final bgColor = isError
        ? (isDark ? const Color(0xFF2A1515) : const Color(0xFFFDF2F2))
        : isReady
            ? (isDark ? const Color(0xFF13222B) : const Color(0xFFF0FDF4))
            : (isDark ? const Color(0xFF1A1F2C) : const Color(0xFFF8FAFC));

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Icon Container
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isError
                      ? Colors.red.withAlpha(30)
                      : isReady
                          ? Colors.teal.withAlpha(30)
                          : Colors.blue.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isError
                      ? Icons.error_outline_rounded
                      : isReady
                          ? Icons.picture_as_pdf_rounded
                          : Icons.hourglass_top_rounded,
                  size: 20,
                  color: isError
                      ? Colors.redAccent
                      : isReady
                          ? (isDark ? AppColors.success : Colors.teal.shade700)
                          : AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              // Name and status text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metadata.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    _buildStatusSubtitle(context, isDark, isReady, isInProgress, isError),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              // Close / Remove Button
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                color: isDark ? Colors.white60 : Colors.black45,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                tooltip: 'Remove document',
                onPressed: onRemove,
              ),
            ],
          ),

          // Quick Action Chips (Shown only when ready)
          if (isReady && !isCompact && onActionSelected != null) ...[
            const SizedBox(height: 8),
            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickActionChip(
                    context,
                    label: '📝 Summarize',
                    prompt: 'Summarize the key takeaways and main concepts from this document.',
                  ),
                  const SizedBox(width: 6),
                  _buildQuickActionChip(
                    context,
                    label: '❓ Important Questions',
                    prompt: 'Generate top 5 university exam and placement interview questions from this document.',
                  ),
                  const SizedBox(width: 6),
                  _buildQuickActionChip(
                    context,
                    label: '🎯 Practice Quiz',
                    prompt: 'Create 4 multiple choice questions (MCQs) with explanations based on this document.',
                  ),
                  const SizedBox(width: 6),
                  _buildQuickActionChip(
                    context,
                    label: '🗺️ Connect to Roadmap',
                    prompt: 'How does this document relate to my current study roadmap and weaknesses?',
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusSubtitle(
    BuildContext context,
    bool isDark,
    bool isReady,
    bool isInProgress,
    bool isError,
  ) {
    if (isInProgress) {
      return Row(
        children: [
          SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? AppColors.primaryLight : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            metadata.processingStatus.displayLabel,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.primaryLight : AppColors.primary,
            ),
          ),
        ],
      );
    }

    if (isReady) {
      final pagesText = metadata.pageCount > 0 ? '${metadata.pageCount} pages • ' : '';
      return Text(
        '${pagesText}Ready for Q&A',
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.success : Colors.teal.shade700,
        ),
      );
    }

    if (isError) {
      return Text(
        metadata.processingError ?? metadata.processingStatus.displayLabel,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.redAccent.shade100 : Colors.red.shade700,
        ),
      );
    }

    return Text(
      metadata.processingStatus.displayLabel,
      style: GoogleFonts.inter(
        fontSize: 11,
        color: isDark ? Colors.white60 : Colors.black54,
      ),
    );
  }

  Widget _buildQuickActionChip(
    BuildContext context, {
    required String label,
    required String prompt,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => onActionSelected?.call(prompt),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.black12,
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
          ),
        ),
      ),
    );
  }
}
