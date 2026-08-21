import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/quiz_model.dart';
import 'quiz_hub_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizResultModel result;

  const QuizResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle =
        isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    const orangeAccent = AppColors.primary;
    const emeraldGreen = Color(0xFF10B981);
    const royalBlue = Color(0xFF2563EB);

    final isPassed = result.isPassed;
    final accuracyStr = result.accuracyPercentage.toStringAsFixed(0);
    final minutes = result.totalTimeTakenSeconds ~/ 60;
    final seconds = result.totalTimeTakenSeconds % 60;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Assessment Scorecard',
          style: GoogleFonts.inter(
              fontWeight: FontWeight.bold, fontSize: 18, color: textPrimary),
        ),
        centerTitle: false,
        backgroundColor: cardColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Close Result',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 1. Master Score Banner
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isPassed
                    ? (isDark
                        ? [const Color(0xFF064E3B), const Color(0xFF022C22)]
                        : [emeraldGreen, const Color(0xFF047857)])
                    : (isDark
                        ? [const Color(0xFF7F1D1D), const Color(0xFF450A0A)]
                        : [const Color(0xFFEF4444), const Color(0xFFB91C1C)]),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPassed
                        ? Icons.emoji_events_rounded
                        : Icons.trending_up_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isPassed ? 'Performance Qualified' : 'Needs Reinforcement',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  result.quizTitle,
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                ),
                const SizedBox(height: 16),
                Text(
                  '${result.score} / ${result.totalQuestions}',
                  style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  'Overall Accuracy: $accuracyStr%',
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. Metrics 4-Grid
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: 'Correct',
                  value: '${result.correctCount}',
                  icon: Icons.check_circle_rounded,
                  color: emeraldGreen,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  label: 'Incorrect',
                  value: '${result.incorrectCount}',
                  icon: Icons.cancel_rounded,
                  color: Colors.redAccent,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  label: 'Unanswered',
                  value: '${result.unansweredCount}',
                  icon: Icons.help_outline_rounded,
                  color: const Color(0xFFF59E0B),
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  label: 'Time Spent',
                  value: '${minutes}m ${seconds}s',
                  icon: Icons.timer_rounded,
                  color: royalBlue,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 3. Topic-wise Breakdown
          Text(
            'Topic-wise Mastery Breakdown',
            style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
          ),
          const SizedBox(height: 12),
          ...result.topicTotalCount.entries.map((entry) {
            final topic = entry.key;
            final total = entry.value;
            final correct = result.topicCorrectCount[topic] ?? 0;
            final percentage = total > 0 ? (correct / total) : 0.0;
            final isWeak = percentage < 0.6;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        topic,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: textPrimary),
                      ),
                      Text(
                        '$correct / $total (${(percentage * 100).toStringAsFixed(0)}%)',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isWeak ? Colors.redAccent : emeraldGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 6,
                      backgroundColor: borderColor,
                      color: isWeak ? Colors.redAccent : emeraldGreen,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),

          // 4. Weak Areas & Next Action Recommendations
          if (result.weakTopics.isNotEmpty) ...[
            Text(
              'Identified Weak Focus Areas',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textPrimary),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withAlpha(isDark ? 25 : 15),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: const Color(0xFFF59E0B).withAlpha(60)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: result.recommendedNextTopics.map((rec) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.arrow_right_rounded,
                            color: Color(0xFFF59E0B), size: 20),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            rec,
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textPrimary),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // 5. Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuizHubScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Try Another Test'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('Back to Hub'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required Color cardColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSubtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 10, color: textSubtitle),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
