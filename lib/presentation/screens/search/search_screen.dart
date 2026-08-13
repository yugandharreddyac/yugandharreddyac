import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/sort_option.dart';
import '../../../data/models/resource_model.dart';
import '../../providers/study_provider.dart';
import '../../widgets/search_bar_widget.dart';
import '../pdf_viewer/pdf_viewer_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final SortOption _currentSort = SortOption.newest;

  final List<String> _categories = [
    'All',
    'Syllabus',
    'Notes',
    'Previous Question Papers',
  ];

  final List<String> _suggestedKeywords = [
    'Pointers',
    'C Programming',
    'Jacobians',
    'Lagrange multipliers',
    'Fourier Series',
    'Data Structures',
    'BST',
    'Dijkstra',
    'Flip Flops',
    'K-Maps',
    'Green Chemistry',
    'IT Essentials',
    'Java',
    'Operating Systems',
    'Cloud',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final studyProvider = context.read<StudyProvider>();
      studyProvider.repository.ensureSearchIndexBuilt();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ResourceModel> _filterAndSortResults(List<ResourceModel> results) {
    var list = results;
    if (_selectedCategory != 'All') {
      list = list.where((r) => r.resourceType.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }
    return ResourceSorter.sort(list, _currentSort);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final studyProvider = context.watch<StudyProvider>();
    final matchingSubjs = studyProvider.subjectSearchResults;
    final matchingItems = studyProvider.matchingItems;
    final rawResults = studyProvider.searchResults;
    final processedResults = _filterAndSortResults(rawResults);

    final bool hasSearchQuery = _searchController.text.trim().isNotEmpty;
    final bool hasResults = matchingSubjs.isNotEmpty || processedResults.isNotEmpty || matchingItems.isNotEmpty;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    const royalBlue = Color(0xFF2563EB);
    const emeraldGreen = Color(0xFF10B981);
    const purpleAccent = Color(0xFF8B5CF6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Global Academic Search',
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
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: 'Search Pointers, Jacobians, Java, OS, Cloud, C...',
              onChanged: (val) {
                studyProvider.search(val);
              },
              onClear: () {
                studyProvider.clearSearch();
              },
            ),
          ),

          // Category Filters Chip Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: GoogleFonts.inter(
                          color: isSelected ? Colors.white : textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: royalBlue,
                      backgroundColor: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isSelected ? royalBlue : borderColor),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Expanded(
            child: studyProvider.isLoading
                ? _buildLoadingState(royalBlue, textSubtitle)
                : studyProvider.isError
                    ? _buildErrorState(textPrimary, textSubtitle, royalBlue, studyProvider)
                    : !hasSearchQuery
                        ? _buildRecentSearchSuggestions(context, royalBlue, textPrimary, textSubtitle, cardColor, borderColor, isDark, studyProvider)
                        : !hasResults
                            ? _buildNoResultsState(_searchController.text.trim(), textPrimary, textSubtitle, royalBlue, isDark, cardColor, borderColor)
                            : ListView(
                                padding: const EdgeInsets.all(20),
                                children: [
                                  // 1. Matching Subjects
                                  if (matchingSubjs.isNotEmpty) ...[
                                    Text(
                                      'Matching Subjects (${matchingSubjs.length})',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ...matchingSubjs.map((subj) {
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          color: cardColor,
                                          borderRadius: BorderRadius.circular(18),
                                          border: Border.all(color: borderColor),
                                        ),
                                        child: ListTile(
                                          leading: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: emeraldGreen.withAlpha(20),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.book_rounded, color: emeraldGreen, size: 20),
                                          ),
                                          title: Text(subj.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimary)),
                                          subtitle: Text('${subj.subjectCode ?? subj.code} • ${subj.creditHours} Credits', style: GoogleFonts.inter(fontSize: 12, color: textSubtitle)),
                                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.resources,
                                              arguments: {
                                                'subjectId': subj.id,
                                                'subjectName': subj.name,
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                    const SizedBox(height: 20),
                                  ],

                                  // 2. Matching Textbook Topics, Chapters & Academic Sections
                                  if (matchingItems.where((i) => i.category.contains('Textbook') || i.topicModel != null || i.sectionIndex != null).isNotEmpty) ...[
                                    Text(
                                      'Notes & Academic Topics (${matchingItems.where((i) => i.category.contains('Textbook') || i.category.contains('Notes') || i.topicModel != null || i.sectionIndex != null).length})',

                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ...matchingItems.where((i) => i.category.contains('Textbook') || i.topicModel != null || i.sectionIndex != null).take(15).map((item) {
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          color: cardColor,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: borderColor),
                                        ),
                                        child: ListTile(
                                          leading: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: purpleAccent.withAlpha(20),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              item.topicModel != null ? Icons.article_rounded : Icons.topic_rounded,
                                              color: purpleAccent,
                                              size: 20,
                                            ),
                                          ),
                                          title: Text(item.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14.5, color: textPrimary)),
                                          subtitle: Text(item.subtitle, style: GoogleFonts.inter(fontSize: 11.5, color: textSubtitle)),
                                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                                          onTap: () {
                                            if (item.topicModel != null) {
                                              // Direct Deep Navigation to TopicDetailScreen
                                              Navigator.pushNamed(
                                                context,
                                                AppRoutes.topicDetail,
                                                arguments: {
                                                  'topic': item.topicModel!,
                                                  'subjectName': item.subjectName,
                                                  'chapterTitle': item.chapterTitle ?? 'Chapter',
                                                  'sectionTitle': item.sectionTitle ?? 'Section',
                                                },
                                              );
                                            } else {
                                              // Open Subject Resource Screen with pre-selected section tab
                                              Navigator.pushNamed(
                                                context,
                                                AppRoutes.resources,
                                                arguments: {
                                                  'subjectId': item.subject?.id ?? item.subjectCode,
                                                  'subjectName': item.subjectName,
                                                  'initialSectionIndex': item.sectionIndex ?? 1,
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      );
                                    }),
                                    const SizedBox(height: 20),
                                  ],

                                  // 3. Matching Study Resources & Papers
                                  if (processedResults.isNotEmpty) ...[
                                    Text(
                                      'Study Resources & Papers (${processedResults.length})',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ...processedResults.map((resource) {
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 12),
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
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(16),
                                          leading: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: royalBlue.withAlpha(20),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.description_rounded, color: royalBlue, size: 22),
                                          ),
                                          title: Text(
                                            resource.title,
                                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimary),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(top: 6),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: royalBlue.withAlpha(15),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Text(
                                                    resource.resourceType,
                                                    style: GoogleFonts.inter(
                                                      color: royalBlue,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    resource.subjectName,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.inter(fontSize: 13, color: textSubtitle),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => PdfViewerScreen(resource: resource),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                  ],
                                ],
                              ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(Color accentColor, Color textSubtitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: accentColor),
        const SizedBox(height: 16),
        Text(
          'Loading resources...',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: textSubtitle,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(Color textPrimary, Color textSubtitle, Color accentColor, StudyProvider studyProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text(
              'Unable to load resources.',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              studyProvider.errorMessage ?? 'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: textSubtitle,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                studyProvider.repository.ensureSearchIndexBuilt();
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearchSuggestions(
    BuildContext context,
    Color royalBlue,
    Color textPrimary,
    Color textSubtitle,
    Color cardColor,
    Color borderColor,
    bool isDark,
    StudyProvider studyProvider,
  ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Popular Search Keywords',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _suggestedKeywords.map((kw) {
            return InkWell(
              onTap: () {
                _searchController.text = kw;
                studyProvider.search(kw);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.north_west_rounded, size: 14, color: royalBlue),
                    const SizedBox(width: 6),
                    Text(
                      kw,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNoResultsState(
    String query,
    Color textPrimary,
    Color textSubtitle,
    Color royalBlue,
    bool isDark,
    Color cardColor,
    Color borderColor,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(28),
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
                  color: royalBlue.withAlpha(15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.search_off_rounded, color: royalBlue, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                'No resources found.',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                query.isNotEmpty
                    ? 'No subjects, syllabus topics, or notes match "$query". Try searching "Pointers", "C", "DBMS", "OS", "Java", or "Cloud".'
                    : 'No resources found in the database.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: textSubtitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
