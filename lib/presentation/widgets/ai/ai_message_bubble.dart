import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/ai_attachment.dart';
import '../../../data/models/ai_message.dart';
import '../../../data/models/ai_response.dart';
import 'ai_markdown_view.dart';

/// Message bubble widget rendering user queries and assistant responses with actions and citations
class AiMessageBubble extends StatefulWidget {
  final AiMessage message;
  final VoidCallback? onRegenerate;
  final ValueChanged<String>? onFollowUpSelected;
  final VoidCallback? onAddToRoadmap;

  const AiMessageBubble({
    super.key,
    required this.message,
    this.onRegenerate,
    this.onFollowUpSelected,
    this.onAddToRoadmap,
  });

  @override
  State<AiMessageBubble> createState() => _AiMessageBubbleState();
}

class _AiMessageBubbleState extends State<AiMessageBubble> {
  bool? _isHelpful;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isUser = widget.message.role == AiMessageRole.user;

    if (isUser) {
      return _buildUserMessage(context, isDark);
    } else {
      return _buildAssistantMessage(context, isDark);
    }
  }

  Widget _buildUserMessage(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 16, color: Colors.grey),
            tooltip: 'Copy query',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.message.content));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Query copied to clipboard!'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.message.attachments.isNotEmpty) ...[
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: widget.message.attachments.map((att) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.description_outlined,
                                  size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                att.fileName,
                                style: GoogleFonts.inter(
                                    fontSize: 11.5, color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                  ],
                  SelectableText(
                    widget.message.content,
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      height: 1.45,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssistantMessage(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badge
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Center(
                  child: Icon(Icons.auto_awesome_rounded,
                      size: 14, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'UniDocs AI',
                style: GoogleFonts.outfit(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.white.withOpacity(0.9)
                      : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Message Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(
                color:
                    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AiMarkdownView(
                  content: widget.message.content,
                  isDark: isDark,
                ),

                // Verified UniDocs Resource Grounding
                if (widget.message.resourceReferences.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.menu_book_rounded,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        'Verified UniDocs Curriculum Resources',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white.withOpacity(0.8)
                              : const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: widget.message.resourceReferences.map((ref) {
                      return _buildResourceChip(context, ref, isDark);
                    }).toList(),
                  ),
                ],

                // Document Grounding & Citations
                if (_hasDocumentCitations(widget.message)) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.description_outlined,
                          size: 14,
                          color: isDark
                              ? AppColors.success
                              : Colors.teal.shade700),
                      const SizedBox(width: 6),
                      Text(
                        'Document Citations & Page References',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white.withOpacity(0.8)
                              : const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children:
                        _extractDocumentCitations(widget.message).map((cit) {
                      return _buildCitationChip(context, cit, isDark);
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),

          // Message Action Toolbar
          const SizedBox(height: 4),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 15),
                tooltip: 'Copy response',
                color: isDark ? Colors.white60 : Colors.black54,
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: widget.message.content));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Response copied to clipboard!'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              if (widget.onRegenerate != null)
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  tooltip: 'Regenerate response',
                  color: isDark ? Colors.white60 : Colors.black54,
                  onPressed: widget.onRegenerate,
                ),
              IconButton(
                icon: Icon(
                  _isHelpful == true
                      ? Icons.thumb_up_rounded
                      : Icons.thumb_up_outlined,
                  size: 15,
                  color: _isHelpful == true
                      ? AppColors.primary
                      : (isDark ? Colors.white60 : Colors.black54),
                ),
                tooltip: 'Helpful',
                onPressed: () {
                  setState(() => _isHelpful = _isHelpful == true ? null : true);
                },
              ),
              IconButton(
                icon: Icon(
                  _isHelpful == false
                      ? Icons.thumb_down_rounded
                      : Icons.thumb_down_outlined,
                  size: 15,
                  color: _isHelpful == false
                      ? Colors.redAccent
                      : (isDark ? Colors.white60 : Colors.black54),
                ),
                tooltip: 'Not helpful',
                onPressed: () {
                  setState(
                      () => _isHelpful = _isHelpful == false ? null : false);
                },
              ),
            ],
          ),

          // Follow-Up Suggestions & Quick Actions
          _buildFollowUpChips(context, isDark),
        ],
      ),
    );
  }

  Widget _buildResourceChip(
      BuildContext context, AiResourceReference ref, bool isDark) {
    return InkWell(
      onTap: () {
        if (ref.route != null && ref.route!.isNotEmpty) {
          Navigator.pushNamed(context, ref.route!,
              arguments: ref.routeArguments);
        } else {
          // Navigate to topic detail or hub
          Navigator.pushNamed(
            context,
            AppRoutes.topicDetail,
            arguments: {
              'topicId': ref.id,
              'topicTitle': ref.title,
            },
          );
        }
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(isDark ? 0.2 : 0.08),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.open_in_new_rounded,
                size: 12, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              ref.title,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasDocumentCitations(AiMessage msg) {
    if (msg.metadata.containsKey('citations')) return true;
    if (msg.attachments
        .any((a) => a.isPdf || a.status == AiAttachmentStatus.processed))
      return true;
    return false;
  }

  List<Map<String, dynamic>> _extractDocumentCitations(AiMessage msg) {
    final results = <Map<String, dynamic>>[];
    if (msg.metadata['citations'] is List) {
      for (final item in msg.metadata['citations'] as List) {
        if (item is Map<String, dynamic>) results.add(item);
      }
    }
    if (results.isEmpty) {
      for (final att in msg.attachments) {
        final pages = att.metadata['pageCount'] ?? 1;
        results.add({
          'sourceTitle': att.filename,
          'sourceReference': 'Page 1–$pages',
          'sourceType': att.sourceType.value,
        });
      }
    }
    return results;
  }

  Widget _buildCitationChip(
      BuildContext context, Map<String, dynamic> cit, bool isDark) {
    final title = cit['sourceTitle']?.toString() ?? 'Document';
    final ref = cit['sourceReference']?.toString() ?? '';
    final label = ref.isNotEmpty ? '$title • $ref' : title;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.teal.withAlpha(30) : Colors.teal.withAlpha(15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? Colors.teal.withAlpha(80) : Colors.teal.withAlpha(50),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.picture_as_pdf_outlined,
              size: 12,
              color: isDark ? AppColors.success : Colors.teal.shade800),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.success : Colors.teal.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUpChips(BuildContext context, bool isDark) {
    final suggestions = <String>[];

    if (widget.message.suggestedFollowUps.isNotEmpty) {
      suggestions.addAll(widget.message.suggestedFollowUps);
    } else {
      // Intelligent contextual suggestions
      suggestions.addAll([
        'Explain simpler',
        'Give a practical example',
        'Give 3 interview questions',
        'Add to my roadmap',
      ]);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 4),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: suggestions.map((chipText) {
          final isRoadmapAction = chipText.toLowerCase().contains('roadmap');

          return ActionChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isRoadmapAction) ...[
                  const Icon(Icons.add_task_rounded,
                      size: 12, color: AppColors.primary),
                  const SizedBox(width: 4),
                ],
                Text(
                  chipText,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight:
                        isRoadmapAction ? FontWeight.w600 : FontWeight.w500,
                    color: isRoadmapAction
                        ? AppColors.primary
                        : (isDark
                            ? Colors.white.withOpacity(0.85)
                            : const Color(0xFF334155)),
                  ),
                ),
              ],
            ),
            backgroundColor:
                isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            side: BorderSide(
              color: isRoadmapAction
                  ? AppColors.primary.withOpacity(0.5)
                  : (isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0)),
              width: 0.8,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            onPressed: () {
              if (isRoadmapAction && widget.onAddToRoadmap != null) {
                widget.onAddToRoadmap!();
              } else if (widget.onFollowUpSelected != null) {
                widget.onFollowUpSelected!(chipText);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
