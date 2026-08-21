import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/bookmark_model.dart';
import '../../providers/bookmark_provider.dart';
import '../../widgets/search_bar_widget.dart';
import '../pdf_viewer/pdf_viewer_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BookmarkModel> _filterBookmarks(List<BookmarkModel> bookmarks) {
    var list = bookmarks.where((bm) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return bm.resourceTitle.toLowerCase().contains(q) ||
          bm.subjectName.toLowerCase().contains(q) ||
          bm.resourceType.toLowerCase().contains(q);
    }).toList();

    if (_selectedFilter == 'Pages Only') {
      list = list.where((bm) => bm.pageNumber != null).toList();
    } else if (_selectedFilter != 'All') {
      list = list
          .where((bm) =>
              bm.resourceType.toLowerCase() == _selectedFilter.toLowerCase())
          .toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bookmarkProvider = context.watch<BookmarkProvider>();
    final rawBookmarks = bookmarkProvider.bookmarks;
    final processedBookmarks = _filterBookmarks(rawBookmarks);

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF4F4F5);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE4E4E7);
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : const Color(0xFF09090B);
    final textSubtitle =
        isDark ? AppColors.textSecondaryDark : const Color(0xFF71717A);

    const orangeAccent = AppColors.primary;
    const emeraldGreen = Color(0xFF10B981);

    final filters = [
      'All',
      'Pages Only',
      'Syllabus',
      'Notes',
      'Previous Question Papers'
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
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
        title: Text(
          'Saved Bookmarks',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: textPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: cardColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          if (rawBookmarks.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: SearchBarWidget(
                controller: _searchController,
                hintText: 'Search bookmarked notes or pages...',
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                onClear: () {
                  setState(() {
                    _searchQuery = '';
                  });
                },
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: filters.map((f) {
                  final isSelected = _selectedFilter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        f,
                        style: GoogleFonts.inter(
                          color: isSelected ? Colors.white : textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: orangeAccent,
                      backgroundColor: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                            color: isSelected ? orangeAccent : borderColor),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedFilter = f;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          Expanded(
            child: rawBookmarks.isEmpty
                ? _buildEmptyState(context, textPrimary, textSubtitle,
                    orangeAccent, isDark, cardColor, borderColor)
                : processedBookmarks.isEmpty
                    ? Center(
                        child: Text(
                          'No bookmarks match your search.',
                          style: GoogleFonts.inter(
                              color: textSubtitle, fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(24),
                        itemCount: processedBookmarks.length,
                        itemBuilder: (context, index) {
                          final bookmark = processedBookmarks[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: borderColor),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withAlpha(isDark ? 30 : 6),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: (bookmark.pageNumber != null
                                          ? emeraldGreen
                                          : orangeAccent)
                                      .withAlpha(20),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  bookmark.pageNumber != null
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_border_rounded,
                                  color: bookmark.pageNumber != null
                                      ? emeraldGreen
                                      : orangeAccent,
                                  size: 22,
                                ),
                              ),
                              title: Text(
                                bookmark.resourceTitle,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: textPrimary,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    if (bookmark.pageNumber != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          color: emeraldGreen.withAlpha(15),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Page ${bookmark.pageNumber}',
                                          style: GoogleFonts.inter(
                                            color: emeraldGreen,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    Text(
                                      Formatters.formatDate(bookmark.createdAt),
                                      style: GoogleFonts.inter(
                                          fontSize: 13, color: textSubtitle),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.bookmark_remove_rounded,
                                    color: Colors.redAccent, size: 20),
                                tooltip: 'Remove Bookmark',
                                onPressed: () {
                                  bookmarkProvider.removeBookmark(bookmark.id);
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PdfViewerScreen(
                                        resource: bookmark.toResourceModel()),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    Color textPrimary,
    Color textSubtitle,
    Color orangeAccent,
    bool isDark,
    Color cardColor,
    Color borderColor,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 30 : 6),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: orangeAccent.withAlpha(15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.bookmark_border_rounded,
                    color: orangeAccent, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                'No Bookmarks Yet',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bookmark important lecture notes, PYQs, or specific PDF pages to quickly resume studying later.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: textSubtitle,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
                icon: const Icon(Icons.search_rounded, size: 18),
                label: Text(
                  'Explore Resources ➔',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeAccent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
