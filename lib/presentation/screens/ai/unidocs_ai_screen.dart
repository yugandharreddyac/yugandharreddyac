import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/ai_attachment.dart';
import '../../../data/models/document_models.dart';
import '../../../data/models/personalized_roadmap_models.dart';
import '../../providers/document_processing_provider.dart';
import '../../providers/roadmap_provider.dart';
import '../../providers/unidocs_ai_provider.dart';
import '../../widgets/ai/ai_composer.dart';
import '../../widgets/ai/ai_conversation_drawer.dart';
import '../../widgets/ai/ai_document_card.dart';
import '../../widgets/ai/ai_message_bubble.dart';

/// Dedicated conversational AI chat screen for UniDocs
class UniDocsAiScreen extends StatefulWidget {
  final Map<String, dynamic>? initialContext;
  final String? initialPrompt;

  const UniDocsAiScreen({
    super.key,
    this.initialContext,
    this.initialPrompt,
  });

  @override
  State<UniDocsAiScreen> createState() => _UniDocsAiScreenState();
}

class _UniDocsAiScreenState extends State<UniDocsAiScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<AiAttachment> _composerAttachments = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialContext();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleInitialContext() {
    if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
      _sendMessage(widget.initialPrompt!);
    } else if (widget.initialContext != null) {
      final topicTitle = widget.initialContext!['topicTitle']?.toString();
      final roadmapTitle = widget.initialContext!['roadmapTitle']?.toString();
      if (topicTitle != null) {
        _sendMessage(
            'Explain the topic "$topicTitle" from UniDocs and provide key concepts, code examples, and placement interview questions.');
      } else if (roadmapTitle != null) {
        _sendMessage(
            'Review my current learning track "$roadmapTitle" and tell me what I should focus on today.');
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty && _composerAttachments.isEmpty) return;

    final roadmapProvider = context.read<RoadmapProvider>();
    final profile = roadmapProvider.personalizedProfile;
    final roadmap = roadmapProvider.personalizedRoadmap;

    final attachmentsToSend = List<AiAttachment>.from(_composerAttachments);
    setState(() {
      _composerAttachments.clear();
    });

    context.read<UniDocsAiProvider>().sendMessage(
          text,
          profile: profile,
          roadmap: roadmap,
          attachments: attachmentsToSend,
        );

    _scrollToBottom();
  }

  void _confirmAddToRoadmap(BuildContext context, String topicTitle) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.add_task_rounded,
                color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text('Add to Roadmap',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
          ],
        ),
        content: Text(
          'Would you like to add "$topicTitle" as an actionable learning task in your active Personalized Roadmap phase?',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(dialogCtx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Topic "$topicTitle" added to your learning goals!'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child:
                const Text('Add Task', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final aiProvider = context.watch<UniDocsAiProvider>();
    final roadmapProvider = context.watch<RoadmapProvider>();

    final messages = aiProvider.messages;
    final isLoading = aiProvider.isLoading;
    final lastError = aiProvider.lastError;

    final profile = roadmapProvider.personalizedProfile;
    final roadmap = roadmapProvider.personalizedRoadmap;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
          isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
      drawer: const AiConversationDrawer(),
      appBar: _buildAppBar(context, isDark, aiProvider),
      body: SafeArea(
        child: Column(
          children: [
            // Error Notice Banner if active
            if (lastError != null)
              _buildErrorBanner(context, lastError, isDark),

            // Messages or Welcome View
            Expanded(
              child: messages.isEmpty
                  ? _buildWelcomeState(context, isDark, profile, roadmap)
                  : Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 850),
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: messages.length + (isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < messages.length) {
                              final msg = messages[index];
                              return AiMessageBubble(
                                message: msg,
                                onRegenerate: () {
                                  final userMsgs = messages
                                      .where((m) => m.role.name == 'user')
                                      .toList();
                                  if (userMsgs.isNotEmpty) {
                                    _sendMessage(userMsgs.last.content);
                                  }
                                },
                                onFollowUpSelected: (followUp) {
                                  _sendMessage(followUp);
                                },
                                onAddToRoadmap: () {
                                  _confirmAddToRoadmap(context, 'Core Concept');
                                },
                              );
                            } else {
                              return _buildThinkingIndicator(isDark);
                            }
                          },
                        ),
                      ),
                    ),
            ),

            // Input Composer & Attached Document Cards
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Render Active Document Cards
                    if (_composerAttachments.isNotEmpty)
                      Consumer<DocumentProcessingProvider>(
                        builder: (context, docProc, _) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: _composerAttachments.map((att) {
                              final meta = docProc.getDocument(att.id) ??
                                  DocumentMetadata(
                                    documentId: att.id,
                                    fileName: att.filename,
                                    fileSizeBytes: att.sizeBytes,
                                    createdAt: DateTime.now(),
                                    processingStatus: att.status ==
                                            AiAttachmentStatus.processed
                                        ? DocumentProcessingStatus.ready
                                        : (att.status ==
                                                AiAttachmentStatus.unsupported
                                            ? DocumentProcessingStatus
                                                .unsupported
                                            : DocumentProcessingStatus.idle),
                                  );

                              return AiDocumentCard(
                                metadata: meta,
                                onRemove: () {
                                  setState(() => _composerAttachments
                                      .removeWhere((a) => a.id == att.id));
                                  docProc.removeDocument(att.id);
                                },
                                onActionSelected: (prompt) {
                                  _sendMessage(prompt);
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),

                    AiComposer(
                      isLoading: isLoading,
                      pendingAttachments: _composerAttachments,
                      onAttachmentAdded: (att) {
                        setState(() => _composerAttachments.add(att));
                      },
                      onAttachmentRemoved: (att) {
                        setState(() => _composerAttachments
                            .removeWhere((a) => a.id == att.id));
                      },
                      onSend: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, bool isDark, UniDocsAiProvider aiProvider) {
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        tooltip: 'Back',
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
      ),
      title: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome_rounded,
                    size: 16, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'UniDocs AI',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: aiProvider.isLoading
                                ? Colors.amber
                                : const Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          aiProvider.isLoading ? 'Thinking...' : 'Online',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.white60
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.forum_outlined, size: 22),
          tooltip: 'Chat History',
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline_rounded, size: 22),
          tooltip: 'New Chat',
          onPressed: () {
            aiProvider.startNewConversation();
          },
        ),
      ],
    );
  }

  Widget _buildThinkingIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Icon(Icons.auto_awesome_rounded,
                  size: 13, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.primary),
                ),
                const SizedBox(width: 8),
                Text(
                  'UniDocs AI is thinking...',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context, dynamic error, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.redAccent.withOpacity(0.12),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 18, color: Colors.redAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              error.message?.toString() ??
                  'An error occurred during AI processing.',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: isDark ? Colors.red.shade200 : Colors.red.shade800,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final messages = context.read<UniDocsAiProvider>().messages;
              final userMsgs =
                  messages.where((m) => m.role.name == 'user').toList();
              if (userMsgs.isNotEmpty) {
                _sendMessage(userMsgs.last.content);
              }
            },
            child: const Text('Retry',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeState(
    BuildContext context,
    bool isDark,
    PersonalizedProfile? profile,
    PersonalizedRoadmap? roadmap,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo & Title
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome_rounded,
                    size: 36, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'How can I help you learn today?',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Ask about computer science topics, analyze your personalized roadmap, practice for placement interviews, or review syllabus concepts.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  height: 1.45,
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 20),

              // Active Student Context Card
              if (roadmap != null || profile != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.trending_up_rounded,
                          size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          roadmap != null
                              ? '🎯 Active Track: ${roadmap.title} • Phase ${roadmap.currentPhaseIndex + 1}: ${roadmap.currentPhase?.title ?? 'Foundation'}'
                              : '🎯 Target Career: ${profile?.primaryCareerDirection ?? 'Software Engineering'}',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Categorized Suggestion Cards
              _buildSuggestionCategory(
                context,
                isDark,
                '📚 Conceptual Learning',
                [
                  'Explain Deadlock conditions and prevention in Operating Systems.',
                  'Explain Dijkstra\'s Shortest Path Algorithm with step-by-step trace.',
                  'What is Database Normalization (1NF to BCNF) with examples?',
                ],
              ),
              const SizedBox(height: 12),
              _buildSuggestionCategory(
                context,
                isDark,
                '🚀 Placements & DSA',
                [
                  'Give me 3 placement interview questions on Binary Trees with solutions.',
                  'What is the difference between TCP and UDP with real-world scenarios?',
                  'How to prepare for tech placements with 1 hour daily study?',
                ],
              ),
              const SizedBox(height: 12),
              _buildSuggestionCategory(
                context,
                isDark,
                '🗺️ Personalized Roadmap Advice',
                [
                  'What should I study next in my current roadmap phase?',
                  'How do prerequisites work in the UniDocs roadmap engine?',
                  'Help me strengthen my programming fundamentals.',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionCategory(
    BuildContext context,
    bool isDark,
    String title,
    List<String> prompts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xFF475569),
            ),
          ),
        ),
        ...prompts.map((prompt) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: InkWell(
              onTap: () => _sendMessage(prompt),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        prompt,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: isDark
                              ? Colors.white.withOpacity(0.9)
                              : const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
