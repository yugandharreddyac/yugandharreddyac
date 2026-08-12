import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/beyond_academics_model.dart';
import '../../widgets/custom_app_bar.dart';

class CodingLanguageDetailScreen extends StatefulWidget {
  final CodingLanguageModel language;

  const CodingLanguageDetailScreen({super.key, required this.language});

  @override
  State<CodingLanguageDetailScreen> createState() => _CodingLanguageDetailScreenState();
}

class _CodingLanguageDetailScreenState extends State<CodingLanguageDetailScreen> {
  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lang = widget.language;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final textSecondary = isDark ? AppColors.textSecondaryDark : const Color(0xFF475569);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: CustomAppBar(
          title: lang.name,
          subtitle: 'Programming Language Master Guide',
        ),
        body: Column(
          children: [
            // Top Header Card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D9488), Color(0xFF06B6D4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF06B6D4).withAlpha(60),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.code_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lang.introduction,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withAlpha(230),
                            fontSize: 11.5,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.05, end: 0),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: TabBar(
                isScrollable: true,
                indicator: BoxDecoration(
                  color: const Color(0xFF0D9488),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                tabs: const [
                  Tab(text: '📘 Syntax & Core'),
                  Tab(text: '🧱 Collections & OOP'),
                  Tab(text: '⚡ Memory & Exceptions'),
                  Tab(text: '💻 Projects & Practice'),
                  Tab(text: '🌐 Official Docs'),
                ],
              ),
            ),

            // Tab View
            Expanded(
              child: TabBarView(
                children: [
                  _buildSyntaxTab(context, lang, isDark, textPrimary, textSecondary),
                  _buildCollectionsTab(context, lang, isDark, textPrimary, textSecondary),
                  _buildMemoryTab(context, lang, isDark, textPrimary, textSecondary),
                  _buildProjectsTab(context, lang, isDark, textPrimary, textSecondary),
                  _buildOfficialDocsTab(context, lang, isDark, textPrimary, textSecondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyntaxTab(BuildContext context, CodingLanguageModel lang, bool isDark, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Why Learn ${lang.name}?', Icons.star_outline_rounded),
        const SizedBox(height: 8),
        _buildCard(context, text: lang.whyLearn, isDark: isDark, textPrimary: textPrimary),
        const SizedBox(height: 16),

        _buildSectionHeader('Syntax & Language Fundamentals', Icons.terminal_rounded),
        const SizedBox(height: 8),
        _buildCard(context, text: lang.syntaxFundamentals, isDark: isDark, textPrimary: textPrimary),
        const SizedBox(height: 16),

        _buildSectionHeader('Variables & Data Types', Icons.data_object_rounded),
        const SizedBox(height: 8),
        _buildCard(context, text: lang.variablesAndDataTypes, isDark: isDark, textPrimary: textPrimary),
        const SizedBox(height: 16),

        _buildSectionHeader('Operators & Conditional Logic', Icons.alt_route_rounded),
        const SizedBox(height: 8),
        _buildCard(context, text: lang.operatorsAndConditions, isDark: isDark, textPrimary: textPrimary),
        const SizedBox(height: 16),

        _buildSectionHeader('Loops & Control Flow', Icons.loop_rounded),
        const SizedBox(height: 8),
        _buildCard(context, text: lang.loopsAndControlFlow, isDark: isDark, textPrimary: textPrimary),
      ],
    );
  }

  Widget _buildCollectionsTab(BuildContext context, CodingLanguageModel lang, bool isDark, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Functions & Scoping', Icons.functions_rounded),
        const SizedBox(height: 8),
        _buildCard(context, text: lang.functionsAndScope, isDark: isDark, textPrimary: textPrimary),
        const SizedBox(height: 16),

        _buildSectionHeader('Collections, Arrays & Data Structures', Icons.view_module_rounded),
        const SizedBox(height: 8),
        _buildCard(context, text: lang.collectionsAndArrays, isDark: isDark, textPrimary: textPrimary),
        const SizedBox(height: 16),

        _buildSectionHeader('String Handling & Manipulations', Icons.short_text_rounded),
        const SizedBox(height: 8),
        _buildCard(context, text: lang.stringHandling, isDark: isDark, textPrimary: textPrimary),
        const SizedBox(height: 16),

        _buildSectionHeader('Object-Oriented Programming (OOP) & Paradigms', Icons.account_tree_rounded),
        const SizedBox(height: 8),
        _buildCard(context, text: lang.objectOrientedProgramming, isDark: isDark, textPrimary: textPrimary),
      ],
    );
  }

  Widget _buildMemoryTab(BuildContext context, CodingLanguageModel lang, bool isDark, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Error Handling, Exceptions & File I/O', Icons.bug_report_rounded),
        const SizedBox(height: 8),
        _buildCard(context, text: lang.errorAndFileHandling, isDark: isDark, textPrimary: textPrimary),
      ],
    );
  }

  Widget _buildProjectsTab(BuildContext context, CodingLanguageModel lang, bool isDark, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (lang.practiceProblems.isNotEmpty) ...[
          _buildSectionHeader('Must-Do Practice Problems', Icons.task_alt_rounded),
          const SizedBox(height: 8),
          ...lang.practiceProblems.map((prob) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.code_rounded, color: Color(0xFF0D9488), size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text(prob, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary))),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 16),
        ],

        if (lang.recommendedProjects.isNotEmpty) ...[
          _buildSectionHeader('Recommended Portfolio Projects', Icons.folder_special_rounded),
          const SizedBox(height: 8),
          ...lang.recommendedProjects.map((proj) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.rocket_launch_rounded, color: Colors.orange, size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text(proj, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary))),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 16),
        ],

        if (lang.interviewQuestions.isNotEmpty) ...[
          _buildSectionHeader('Common Interview Questions', Icons.psychology_rounded),
          const SizedBox(height: 8),
          ...lang.interviewQuestions.map((q) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.help_outline_rounded, color: AppColors.primary, size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text(q, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary))),
                    ],
                  ),
                ),
              )),
        ],
      ],
    );
  }

  Widget _buildOfficialDocsTab(BuildContext context, CodingLanguageModel lang, bool isDark, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Official Documentation & Channels', Icons.verified_rounded),
        const SizedBox(height: 12),

        if (lang.officialDocsUrl.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
            ),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFF0D9488), radius: 14, child: Icon(Icons.open_in_new_rounded, size: 14, color: Colors.white)),
              title: Text('Official Documentation Portal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
              subtitle: Text(lang.officialDocsUrl, style: TextStyle(fontSize: 11, color: textSecondary)),
              onTap: () => _launchUrl(lang.officialDocsUrl),
            ),
          ),

        if (lang.youtubePlaylistUrl.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
            ),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.red, radius: 14, child: Icon(Icons.play_arrow_rounded, size: 16, color: Colors.white)),
              title: Text('Recommended YouTube Learning Playlist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
              subtitle: Text(lang.youtubePlaylistUrl, style: TextStyle(fontSize: 11, color: textSecondary)),
              onTap: () => _launchUrl(lang.youtubePlaylistUrl),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0D9488), size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
      ],
    );
  }

  Widget _buildCard(BuildContext context, {required String text, required bool isDark, required Color textPrimary}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
      ),
      child: Text(
        text.isEmpty ? 'Exhaustive textbook content provided in full.' : text,
        style: TextStyle(fontSize: 13, color: textPrimary, height: 1.45),
      ),
    );
  }
}
