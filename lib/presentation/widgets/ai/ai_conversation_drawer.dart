import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/ai_conversation.dart';
import '../../providers/unidocs_ai_provider.dart';

/// Conversation history drawer supporting search, creation, switching, and deletion
class AiConversationDrawer extends StatefulWidget {
  const AiConversationDrawer({super.key});

  @override
  State<AiConversationDrawer> createState() => _AiConversationDrawerState();
}

class _AiConversationDrawerState extends State<AiConversationDrawer> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return DateFormat('h:mm a').format(dt);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEE').format(dt);
    } else {
      return DateFormat('MMM d').format(dt);
    }
  }

  void _confirmDelete(BuildContext context, AiConversation conv) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text('Delete Conversation?',
            style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
        content: Text(
          'Are you sure you want to delete "${conv.title}"? This action cannot be undone.',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<UniDocsAiProvider>().deleteConversation(conv.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
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
    final conversations = aiProvider.conversations;
    final activeConvId = aiProvider.currentConversation?.id;

    final filteredConversations = _searchQuery.isEmpty
        ? conversations
        : conversations
            .where((c) => c.title.toLowerCase().contains(_searchQuery))
            .toList();

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.forum_outlined,
                              size: 18, color: AppColors.primary),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'Chat History',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // New Chat Primary Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: InkWell(
                onTap: () {
                  aiProvider.startNewConversation();
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_rounded,
                          size: 20, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'New Chat',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Search Bar
            if (conversations.length > 3)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.inter(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search chats...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 18),
                    filled: true,
                    fillColor: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    isDense: true,
                  ),
                ),
              ),

            const Divider(height: 16),

            // Conversation List
            Expanded(
              child: filteredConversations.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 36,
                              color: isDark ? Colors.white24 : Colors.black26,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No past conversations'
                                  : 'No conversations match search',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: isDark
                                    ? Colors.white38
                                    : const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredConversations.length,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      itemBuilder: (context, index) {
                        final conv = filteredConversations[index];
                        final isActive = conv.id == activeConvId;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            color: isActive
                                ? (isDark
                                    ? AppColors.primary.withOpacity(0.2)
                                    : AppColors.primary.withOpacity(0.08))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: isActive
                                ? Border.all(
                                    color: AppColors.primary.withOpacity(0.4),
                                    width: 1)
                                : null,
                          ),
                          child: ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            leading: Icon(
                              Icons.chat_outlined,
                              size: 16,
                              color: isActive
                                  ? AppColors.primary
                                  : (isDark
                                      ? Colors.white54
                                      : const Color(0xFF64748B)),
                            ),
                            title: Text(
                              conv.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isActive
                                    ? AppColors.primary
                                    : (isDark
                                        ? Colors.white.withOpacity(0.9)
                                        : const Color(0xFF1E293B)),
                              ),
                            ),
                            subtitle: Text(
                              _formatDate(conv.updatedAt),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: isDark
                                    ? Colors.white38
                                    : const Color(0xFF94A3B8),
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline_rounded,
                                  size: 16),
                              color: isDark
                                  ? Colors.white38
                                  : const Color(0xFF94A3B8),
                              tooltip: 'Delete chat',
                              onPressed: () => _confirmDelete(context, conv),
                            ),
                            onTap: () {
                              aiProvider.selectConversation(conv.id);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
