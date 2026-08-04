import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
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
    'DBMS',
    'Operating Systems',
    'C Programming',
    'Java',
    'Cloud',
    'Algorithms',
    'AI',
  ];

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
    final rawResults = studyProvider.searchResults;
    final processedResults = _filterAndSortResults(rawResults);

    final bool hasSearchQuery = _searchController.text.trim().isNotEmpty;
    final bool hasResults = matchingSubjs.isNotEmpty || processedResults.isNotEmpty;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    const royalBlue = Color(0xFF2563EB);
    const emeraldGreen = Color(0xFF10B981);

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
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: 'Search DBMS, OS, Cloud, Algo, Java, C...',
              onChanged: (val) {
                studyProvider.search(val);
              },
              onClear: () {
                studyProvider.clearSearch();
              },
            ),
          ),

          // Filters & Suggested Chips Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
            child: !hasSearchQuery
                ? _buildRecentSearchSuggestions(context, royalBlue, textPrimary, textSubtitle, cardColor, borderColor, isDark, studyProvider)
                : !hasResults
                    ? _buildNoResultsState(textPrimary, textSubtitle, royalBlue, isDark, cardColor, borderColor)
                    : ListView(
                        padding: const EdgeInsets.all(24),
                        children: [
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
                                  subtitle: Text('${subj.subjectCode} • ${subj.credits} Credits', style: GoogleFonts.inter(fontSize: 12, color: textSubtitle)),
                                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/subject-details',
                                      arguments: {'subject': subj},
                                    );
                                  },
                                ),
                              );
                            }),
                            const SizedBox(height: 20),
                          ],
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
                                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 17, color: textPrimary),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4),
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
                                        Text(
                                          resource.subjectName,
                                          style: GoogleFonts.inter(fontSize: 13, color: textSubtitle),
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
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Popular Suggestions',
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
    Color textPrimary,
    Color textSubtitle,
    Color royalBlue,
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
                  color: royalBlue.withAlpha(15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.search_off_rounded, color: royalBlue, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                'No Search Results',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try searching with another keyword like "DBMS", "Operating Systems", "Java", or "Cloud".',
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
