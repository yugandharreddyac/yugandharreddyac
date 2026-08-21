import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/textbook_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/resource_card.dart';

class TopicDetailScreen extends StatelessWidget {
  final TextbookTopicModel topic;
  final String subjectName;
  final String chapterTitle;
  final String sectionTitle;

  const TopicDetailScreen({
    super.key,
    required this.topic,
    required this.subjectName,
    required this.chapterTitle,
    required this.sectionTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : const Color(0xFF475569);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar(
        title: '${topic.topicNumber} ${topic.title}',
        subtitle: sectionTitle,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Breadcrumb Navigation Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color:
                      isDark ? AppColors.borderDark : const Color(0xFFFFEDD5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.school_rounded,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$subjectName  →  $chapterTitle  →  $sectionTitle  →  ${topic.topicNumber}',
                    style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: -0.05, end: 0),

          const SizedBox(height: 16),

          // Header Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 25 : 6),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'TOPIC ${topic.topicNumber}',
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  topic.title,
                  style: TextStyle(
                      color: textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 1. Definition
          _buildSectionHeader(
              '1. Formal Academic Definition', Icons.menu_book_rounded),
          const SizedBox(height: 8),
          _buildCard(
            cardBg,
            borderColor,
            child: Text(
              topic.definition,
              style: TextStyle(
                  color: textPrimary,
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w500),
            ),
          ),

          const SizedBox(height: 20),

          // 2. Intuition
          _buildSectionHeader(
              '2. Intuition & Concept', Icons.lightbulb_outline_rounded),
          const SizedBox(height: 8),
          _buildCard(
            cardBg,
            borderColor,
            child: Text(
              topic.intuition,
              style:
                  TextStyle(color: textSecondary, fontSize: 13.5, height: 1.5),
            ),
          ),

          const SizedBox(height: 20),

          // 3. Working Principle
          _buildSectionHeader(
              '3. Working Principle', Icons.settings_suggest_rounded),
          const SizedBox(height: 8),
          _buildCard(
            cardBg,
            borderColor,
            child: Text(
              topic.workingPrinciple,
              style: TextStyle(color: textPrimary, fontSize: 13.5, height: 1.5),
            ),
          ),

          if (topic.algorithm != null && topic.algorithm!.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildSectionHeader(
                '4. Algorithm & Steps', Icons.alt_route_rounded),
            const SizedBox(height: 8),
            _buildCard(
              cardBg,
              borderColor,
              child: Text(
                topic.algorithm!,
                style: TextStyle(
                    color: textPrimary,
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],

          if (topic.pseudocode != null && topic.pseudocode!.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildSectionHeader('5. Standard Pseudocode', Icons.code_rounded),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : const Color(0xFF334155)),
              ),
              child: Text(
                topic.pseudocode!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Color(0xFF38BDF8),
                  height: 1.4,
                ),
              ),
            ),
          ],

          if (topic.codeImplementation != null &&
              topic.codeImplementation!.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildSectionHeader(
                '6. Code Implementation', Icons.terminal_rounded),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF0F172A) : const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: SelectableText(
                topic.codeImplementation!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Color(0xFF4ADE80),
                  height: 1.4,
                ),
              ),
            ),
          ],

          if (topic.timeComplexity != null ||
              topic.spaceComplexity != null) ...[
            const SizedBox(height: 20),
            _buildSectionHeader('7. Complexity Analysis', Icons.timer_outlined),
            const SizedBox(height: 8),
            Row(
              children: [
                if (topic.timeComplexity != null)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Time Complexity',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(topic.timeComplexity!,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                if (topic.timeComplexity != null &&
                    topic.spaceComplexity != null)
                  const SizedBox(width: 10),
                if (topic.spaceComplexity != null)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.purple.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Space Complexity',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(topic.spaceComplexity!,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],

          if (topic.advantages.isNotEmpty ||
              topic.disadvantages.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildSectionHeader(
                '8. Trade-offs & Evaluation', Icons.thumbs_up_down_rounded),
            const SizedBox(height: 8),
            if (topic.advantages.isNotEmpty)
              _buildListCard('Advantages', topic.advantages, Colors.green,
                  cardBg, borderColor, textPrimary),
            if (topic.disadvantages.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildListCard('Disadvantages', topic.disadvantages, Colors.red,
                  cardBg, borderColor, textPrimary),
            ],
          ],

          if (topic.practiceQuestions.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildSectionHeader(
                '9. Practice Problems', Icons.assignment_outlined),
            const SizedBox(height: 8),
            _buildListCard('Self-Assessment Questions', topic.practiceQuestions,
                AppColors.primary, cardBg, borderColor, textPrimary),
          ],

          if (topic.examQuestions.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildSectionHeader('10. University Exam Questions',
                Icons.workspace_premium_rounded),
            const SizedBox(height: 8),
            _buildListCard(
                'High-Probability Exam Questions',
                topic.examQuestions,
                Colors.orange,
                cardBg,
                borderColor,
                textPrimary),
          ],

          if (topic.attachedResource != null) ...[
            const SizedBox(height: 20),
            _buildSectionHeader(
                '11. Attached Reference PDF', Icons.picture_as_pdf_rounded),
            const SizedBox(height: 8),
            ResourceCard(
              resource: topic.attachedResource!,
              index: 0,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.pdfViewer,
                  arguments: topic.attachedResource,
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildCard(Color cardBg, Color borderColor, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }

  Widget _buildListCard(String title, List<String> items, Color accentColor,
      Color cardBg, Color borderColor, Color textPrimary) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: accentColor)),
          const SizedBox(height: 8),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 4, backgroundColor: accentColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(item,
                        style: TextStyle(
                            fontSize: 12.5, color: textPrimary, height: 1.35)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
