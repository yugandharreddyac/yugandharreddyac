import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/beyond_academics_model.dart';
import '../../widgets/custom_app_bar.dart';

class DsaTopicDetailScreen extends StatefulWidget {
  final DsaTopicModel topic;

  const DsaTopicDetailScreen({super.key, required this.topic});

  @override
  State<DsaTopicDetailScreen> createState() => _DsaTopicDetailScreenState();
}

class _DsaTopicDetailScreenState extends State<DsaTopicDetailScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final topic = widget.topic;

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
          title: topic.topicName,
          subtitle: '${topic.category} • DSA Topic Guide',
        ),
        body: Column(
          children: [
            // Header Card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withAlpha(60),
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
                      Icons.account_tree_rounded,
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
                          topic.topicName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Chip(
                              label: Text(topic.timeComplexity, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                              backgroundColor: Colors.white.withAlpha(40),
                              visualDensity: VisualDensity.compact,
                            ),
                            const SizedBox(width: 6),
                            Chip(
                              label: Text(topic.spaceComplexity, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                              backgroundColor: Colors.white.withAlpha(40),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
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
                  color: const Color(0xFF4F46E5),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                tabs: const [
                  Tab(text: '💡 Concept & Intuition'),
                  Tab(text: '📝 Algorithm & Pseudocode'),
                  Tab(text: '💻 Working Code'),
                  Tab(text: '📊 Complexity & Edge Cases'),
                  Tab(text: '🎯 Practice & Interview'),
                ],
              ),
            ),

            // Tab View
            Expanded(
              child: TabBarView(
                children: [
                  _buildConceptTab(context, topic, isDark, textPrimary, textSecondary),
                  _buildAlgorithmTab(context, topic, isDark, textPrimary, textSecondary),
                  _buildCodeTab(context, topic, isDark, textPrimary, textSecondary),
                  _buildComplexityTab(context, topic, isDark, textPrimary, textSecondary),
                  _buildPracticeTab(context, topic, isDark, textPrimary, textSecondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConceptTab(BuildContext context, DsaTopicModel topic, bool isDark, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Definition', Icons.description_rounded),
        const SizedBox(height: 8),
        _buildCard(context, text: topic.definition, isDark: isDark, textPrimary: textPrimary),
        const SizedBox(height: 16),

        _buildSectionHeader('Real-World Intuition', Icons.lightbulb_outline_rounded),
        const SizedBox(height: 8),
        _buildCard(context, text: topic.intuition, isDark: isDark, textPrimary: textPrimary),
        const SizedBox(height: 16),

        _buildSectionHeader('Problem Solving Approach', Icons.alt_route_rounded),
        const SizedBox(height: 8),
        _buildCard(context, text: topic.approach, isDark: isDark, textPrimary: textPrimary),
      ],
    );
  }

  Widget _buildAlgorithmTab(BuildContext context, DsaTopicModel topic, bool isDark, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Step-by-Step Algorithm Logic', Icons.format_list_numbered_rounded),
        const SizedBox(height: 8),
        _buildCard(context, text: topic.algorithm, isDark: isDark, textPrimary: textPrimary),
        const SizedBox(height: 16),

        _buildSectionHeader('Standard Pseudocode', Icons.code_rounded),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(14),
          ),
          child: SelectableText(
            topic.pseudocode,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12.5, color: Colors.cyanAccent, height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeTab(BuildContext context, DsaTopicModel topic, bool isDark, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Executable Code Implementation', Icons.terminal_rounded),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(14),
          ),
          child: SelectableText(
            topic.codeImplementation,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12.5, color: Color(0xFF38BDF8), height: 1.45),
          ),
        ),
        if (topic.example.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSectionHeader('Worked Out Example Walkthrough', Icons.smart_toy_rounded),
          const SizedBox(height: 8),
          _buildCard(context, text: topic.example, isDark: isDark, textPrimary: textPrimary),
        ],
      ],
    );
  }

  Widget _buildComplexityTab(BuildContext context, DsaTopicModel topic, bool isDark, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Time Complexity Analysis', Icons.timer_rounded),
        const SizedBox(height: 8),
        _buildCard(context, text: topic.timeComplexity, isDark: isDark, textPrimary: textPrimary),
        const SizedBox(height: 16),

        _buildSectionHeader('Space Complexity Analysis', Icons.memory_rounded),
        const SizedBox(height: 8),
        _buildCard(context, text: topic.spaceComplexity, isDark: isDark, textPrimary: textPrimary),
        const SizedBox(height: 16),

        if (topic.commonMistakes.isNotEmpty) ...[
          _buildSectionHeader('Common Pitfalls & Off-by-One Traps', Icons.warning_amber_rounded),
          const SizedBox(height: 8),
          ...topic.commonMistakes.map((mistake) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withAlpha(100)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.amber, size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text(mistake, style: TextStyle(fontSize: 12.5, color: textPrimary, height: 1.35))),
                    ],
                  ),
                ),
              )),
        ],
      ],
    );
  }

  Widget _buildPracticeTab(BuildContext context, DsaTopicModel topic, bool isDark, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (topic.practiceProblems.isNotEmpty) ...[
          _buildSectionHeader('Curated LeetCode / Striver Practice Problems', Icons.task_alt_rounded),
          const SizedBox(height: 8),
          ...topic.practiceProblems.map((prob) => Padding(
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
                      const Icon(Icons.fitness_center_rounded, color: Color(0xFF4F46E5), size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text(prob, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary))),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 16),
        ],

        if (topic.interviewQuestions.isNotEmpty) ...[
          _buildSectionHeader('Top Tech Interview Questions', Icons.psychology_rounded),
          const SizedBox(height: 8),
          ...topic.interviewQuestions.map((q) => Padding(
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4F46E5), size: 20),
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
