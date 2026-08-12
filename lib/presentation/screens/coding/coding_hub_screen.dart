import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/beyond_academics_model.dart';
import '../../providers/coding_provider.dart';
import '../../widgets/shimmer_loading.dart';
import 'coding_language_detail_screen.dart';
import 'dsa_topic_detail_screen.dart';

class CodingHubScreen extends StatefulWidget {
  const CodingHubScreen({super.key});

  @override
  State<CodingHubScreen> createState() => _CodingHubScreenState();
}

class _CodingHubScreenState extends State<CodingHubScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<CodingProvider>().fetchCodingResources();
      }
    });
  }

  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
  }

  Color _getDifficultyColor(String diff) {
    switch (diff.toLowerCase()) {
      case 'easy':
      case 'beginner':
        return const Color(0xFF10B981);
      case 'medium':
      case 'intermediate':
        return const Color(0xFFF59E0B);
      case 'hard':
      case 'advanced':
        return Colors.redAccent;
      default:
        return const Color(0xFF2563EB);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<CodingProvider>();

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text(
            'Coding & DSA Learning Ecosystem',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: textPrimary,
            ),
          ),
          centerTitle: false,
          backgroundColor: cardColor,
          elevation: 0,
        ),
        body: Column(
          children: [
            // Top Master Header Card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF334155)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.code_rounded, color: Color(0xFF38BDF8), size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Programming & Problem Solving',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'From Syntax Fundamentals → Data Structures → Dynamic Programming & Interview Readiness.',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: TabBar(
                isScrollable: true,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: textSubtitle,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                tabs: const [
                  Tab(text: '💻 Languages'),
                  Tab(text: '⚡ DSA Topics'),
                  Tab(text: '🎯 Patterns'),
                  Tab(text: '🛠️ Projects'),
                  Tab(text: '📄 Sheets & Links'),
                ],
              ),
            ),

            // Tab View Contents
            Expanded(
              child: provider.isLoading
                  ? const ShimmerListLoading(itemCount: 4, itemHeight: 120)
                  : TabBarView(
                      children: [
                        _buildLanguagesTab(context, provider.languages, cardColor, borderColor, textPrimary, textSubtitle, isDark),
                        _buildDsaTopicsTab(context, provider.dsaTopics, cardColor, borderColor, textPrimary, textSubtitle, isDark),
                        _buildPatternsTab(context, cardColor, borderColor, textPrimary, textSubtitle, isDark),
                        _buildProjectsTab(context, provider.codingProjects, cardColor, borderColor, textPrimary, textSubtitle, isDark),
                        _buildSheetsTab(context, provider, cardColor, borderColor, textPrimary, textSubtitle, isDark),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: PROGRAMMING LANGUAGES
  Widget _buildLanguagesTab(BuildContext context, List<CodingLanguageModel> languages, Color cardColor, Color borderColor, Color textPrimary, Color textSubtitle, bool isDark) {
    if (languages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Row(
          children: [
            Icon(Icons.terminal_rounded, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('PROGRAMMING LANGUAGE MASTER PATHS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 4),
        Text('Syntax fundamentals, OOP, collections, error handling, practice problems, & official docs.', style: TextStyle(color: textSubtitle, fontSize: 12)),
        const SizedBox(height: 14),

        ...languages.map((lang) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withAlpha(25),
                child: Text(lang.name.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
              ),
              title: Text(lang.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimary)),
              subtitle: Text(lang.whyLearn, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.5, color: textSubtitle)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lang.introduction, style: TextStyle(fontSize: 13, color: textPrimary, height: 1.4)),
                      const SizedBox(height: 12),
                      const Text('SYNTAX & FUNDAMENTALS:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary)),
                      const SizedBox(height: 4),
                      Text(lang.syntaxFundamentals, style: TextStyle(fontSize: 12, color: textSubtitle)),
                      const SizedBox(height: 10),
                      const Text('COLLECTIONS & ARRAYS:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.orange)),
                      const SizedBox(height: 4),
                      Text(lang.collectionsAndArrays, style: TextStyle(fontSize: 12, color: textSubtitle)),
                      const SizedBox(height: 10),
                      const Text('OBJECT-ORIENTED PROGRAMMING:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF10B981))),
                      const SizedBox(height: 4),
                      Text(lang.objectOrientedProgramming, style: TextStyle(fontSize: 12, color: textSubtitle)),
                      const SizedBox(height: 12),
                      const Text('PRACTICE PROBLEMS:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.purpleAccent)),
                      const SizedBox(height: 4),
                      ...lang.practiceProblems.map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text('• $p', style: TextStyle(fontSize: 12, color: textPrimary)),
                          )),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CodingLanguageDetailScreen(language: lang),
                                ),
                              );
                            },
                            icon: const Icon(Icons.auto_stories_rounded, size: 14),
                            label: const Text('Open 5-Tab Master Guide', style: TextStyle(fontSize: 11)),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D9488), foregroundColor: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          if (lang.officialDocsUrl.isNotEmpty)
                            IconButton(
                              onPressed: () => _launchUrl(lang.officialDocsUrl),
                              icon: const Icon(Icons.open_in_new_rounded, size: 16, color: AppColors.primary),
                              tooltip: 'Official Docs',
                            ),
                          if (lang.youtubePlaylistUrl.isNotEmpty)
                            IconButton(
                              onPressed: () => _launchUrl(lang.youtubePlaylistUrl),
                              icon: const Icon(Icons.play_circle_fill_rounded, size: 16, color: Colors.redAccent),
                              tooltip: 'YouTube Playlist',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // TAB 2: DATA STRUCTURES & ALGORITHMS (12-Point Topic Explanation)
  Widget _buildDsaTopicsTab(BuildContext context, List<DsaTopicModel> dsaTopics, Color cardColor, Color borderColor, Color textPrimary, Color textSubtitle, bool isDark) {
    if (dsaTopics.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Row(
          children: [
            Icon(Icons.account_tree_rounded, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('CORE DATA STRUCTURES & ALGORITHMS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 4),
        Text('Definition, intuition, approach, algorithm, pseudocode, time/space complexity, & edge cases.', style: TextStyle(color: textSubtitle, fontSize: 12)),
        const SizedBox(height: 14),

        ...dsaTopics.map((top) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: ExpansionTile(
              leading: Chip(label: Text(top.category, style: const TextStyle(fontSize: 10, color: AppColors.primary)), backgroundColor: AppColors.primary.withAlpha(20)),
              title: Text(top.topicName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimary)),
              subtitle: Text(top.timeComplexity, style: TextStyle(fontSize: 11.5, color: textSubtitle)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('DEFINITION:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary)),
                      Text(top.definition, style: TextStyle(fontSize: 12.5, color: textPrimary)),
                      const SizedBox(height: 10),
                      const Text('INTUITION:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.amber)),
                      Text(top.intuition, style: TextStyle(fontSize: 12.5, color: textSubtitle, height: 1.35)),
                      const SizedBox(height: 10),
                      const Text('ALGORITHM & PSEUDOCODE:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF10B981))),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(top.pseudocode, style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: Colors.greenAccent, height: 1.4)),
                      ),
                      const SizedBox(height: 10),
                      const Text('PYTHON CODE IMPLEMENTATION:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.cyanAccent)),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(top.codeImplementation, style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: Colors.cyanAccent, height: 1.4)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Chip(label: Text('Time: ${top.timeComplexity}', style: const TextStyle(fontSize: 10)), backgroundColor: Colors.blueAccent.withAlpha(20)),
                          const SizedBox(width: 8),
                          Chip(label: Text('Space: ${top.spaceComplexity}', style: const TextStyle(fontSize: 10)), backgroundColor: Colors.purple.withAlpha(20)),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DsaTopicDetailScreen(topic: top),
                                ),
                              );
                            },
                            icon: const Icon(Icons.auto_stories_rounded, size: 14),
                            label: const Text('Open 5-Tab DSA Guide', style: TextStyle(fontSize: 11)),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F46E5), foregroundColor: Colors.white),
                          ),
                        ],
                      ),
                      if (top.practiceProblems.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        const Text('INTERVIEW PRACTICE PROBLEMS:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.purpleAccent)),
                        ...top.practiceProblems.map((p) => Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text('• $p', style: TextStyle(fontSize: 12, color: textPrimary)),
                            )),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // TAB 3: PROBLEM SOLVING PATTERNS
  Widget _buildPatternsTab(BuildContext context, Color cardColor, Color borderColor, Color textPrimary, Color textSubtitle, bool isDark) {
    final patterns = [
      {'title': 'Two Pointers Technique', 'desc': 'Use two indices moving towards each other or in parallel to solve array/string search in O(N) time.', 'tag': 'Arrays / Strings'},
      {'title': 'Sliding Window Pattern', 'desc': 'Maintain a running subsegment window of dynamic or fixed length to compute range statistics.', 'tag': 'Subarrays'},
      {'title': 'Fast & Slow Pointer (Floyd Cycle)', 'desc': 'Pointers moving at different speeds (1x vs 2x) to detect cycles or find middle nodes in Linked Lists.', 'tag': 'Linked List'},
      {'title': 'Binary Search on Answer', 'desc': 'Monotonic search space partitioning to find optimal minimum or maximum feasible parameters.', 'tag': 'Search'},
      {'title': 'BFS / DFS Graph Traversal', 'desc': 'Breadth-first search for shortest paths; Depth-first search for connectivity, components, and topological ordering.', 'tag': 'Graphs / Trees'},
      {'title': 'Overlapping Subproblems (DP)', 'desc': 'Memoize state transitions dp[i] to avoid exponential redundant subproblem recalculations.', 'tag': 'Dynamic Programming'},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Row(
          children: [
            Icon(Icons.extension_rounded, color: Colors.amber, size: 20),
            SizedBox(width: 8),
            Text('MUST-KNOW PROBLEM SOLVING PATTERNS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 4),
        Text('Master these 6 recurring coding patterns to solve over 80% of LeetCode Medium/Hard questions.', style: TextStyle(color: textSubtitle, fontSize: 12)),
        const SizedBox(height: 14),

        ...patterns.map((pat) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(pat['title']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary))),
                    Chip(label: Text(pat['tag']!, style: const TextStyle(fontSize: 10, color: Colors.amber)), backgroundColor: Colors.amber.withAlpha(25)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(pat['desc']!, style: TextStyle(fontSize: 12.5, color: textSubtitle, height: 1.4)),
              ],
            ),
          );
        }),
      ],
    );
  }

  // TAB 4: CODING PROJECTS
  Widget _buildProjectsTab(BuildContext context, List<IndustryProjectModel> projects, Color cardColor, Color borderColor, Color textPrimary, Color textSubtitle, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Row(
          children: [
            Icon(Icons.folder_special_rounded, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('DEVELOPMENT & INDUSTRY PROJECTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 4),
        Text('Hands-on project blueprints with folder structure, tech stack, & resume descriptions.', style: TextStyle(color: textSubtitle, fontSize: 12)),
        const SizedBox(height: 14),

        ...projects.map((proj) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(proj.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimary))),
                    Chip(label: Text(proj.difficulty, style: TextStyle(fontSize: 10, color: _getDifficultyColor(proj.difficulty))), backgroundColor: _getDifficultyColor(proj.difficulty).withAlpha(20)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(proj.problemStatement, style: TextStyle(fontSize: 12.5, color: textSubtitle, height: 1.4)),
                const SizedBox(height: 10),
                const Text('Architecture & Tech Stack:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary)),
                const SizedBox(height: 2),
                Text('${proj.architecture} (${proj.techStack.join(", ")})', style: TextStyle(fontSize: 12, color: textPrimary)),
                const SizedBox(height: 10),
                const Text('Suggested Folder Structure:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF10B981))),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(proj.folderStructure, style: const TextStyle(fontFamily: 'monospace', fontSize: 10.5, color: Colors.greenAccent)),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // TAB 5: SHEETS & VERIFIED LINKS
  Widget _buildSheetsTab(BuildContext context, CodingProvider provider, Color cardColor, Color borderColor, Color textPrimary, Color textSubtitle, bool isDark) {
    final resources = provider.filteredResources;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: resources.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final res = resources[index];
        final diffColor = _getDifficultyColor(res.difficulty);

        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: ListTile(
            dense: true,
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withAlpha(25),
              child: const Icon(Icons.code_rounded, color: AppColors.primary, size: 18),
            ),
            title: Text(res.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
            subtitle: Text('${res.platform} • ${res.sheetName}', style: TextStyle(fontSize: 11, color: textSubtitle)),
            trailing: Chip(
              label: Text(res.difficulty, style: TextStyle(fontSize: 10, color: diffColor, fontWeight: FontWeight.bold)),
              backgroundColor: diffColor.withAlpha(20),
            ),
            onTap: () => _launchUrl(res.url),
          ),
        );
      },
    );
  }
}
