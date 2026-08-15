import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/quiz_model.dart';
import '../../../providers/quiz_provider.dart';
import 'quiz_result_screen.dart';

class QuizSessionScreen extends StatelessWidget {
  const QuizSessionScreen({super.key});

  void _confirmSubmit(BuildContext context, QuizProvider quizProvider) async {
    final unansweredCount = quizProvider.currentQuestions.length - quizProvider.userAnswers.length;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Assessment?'),
        content: Text(
          unansweredCount > 0
              ? 'You have $unansweredCount unanswered question(s). Are you sure you want to finalize and submit your test?'
              : 'You have answered all questions. Ready to submit and view your detailed scorecard?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep Practicing')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Submit Test'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final result = quizProvider.submitQuiz();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(result: result),
        ),
      );
    }
  }

  void _showQuestionPalette(BuildContext context, QuizProvider quizProvider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question Palette',
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(quizProvider.currentQuestions.length, (index) {
                  final isAnswered = quizProvider.userAnswers.containsKey(index);
                  final isMarked = quizProvider.markedForReview.contains(index);
                  final isCurrent = quizProvider.currentQuestionIndex == index;

                  Color bg = Colors.grey.shade200;
                  Color textCol = Colors.black87;

                  if (isMarked) {
                    bg = const Color(0xFFF59E0B);
                    textCol = Colors.white;
                  } else if (isAnswered) {
                    bg = const Color(0xFF10B981);
                    textCol = Colors.white;
                  }

                  return InkWell(
                    onTap: () {
                      quizProvider.jumpToQuestion(index);
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isCurrent ? AppColors.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: textCol),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final quizProvider = context.watch<QuizProvider>();
    final q = quizProvider.currentQuestion;
    final currentIndex = quizProvider.currentQuestionIndex;
    final totalCount = quizProvider.currentQuestions.length;

    if (quizProvider.isLoading || q == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);
    const orangeAccent = AppColors.primary;

    final isPractice = quizProvider.currentMode == QuizMode.practice;
    final selectedOption = quizProvider.currentSelectedOption;
    final isMarked = quizProvider.isCurrentMarkedForReview;

    // Timer formatted
    final minutes = (quizProvider.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (quizProvider.remainingSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Question ${currentIndex + 1} of $totalCount',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 17, color: textPrimary),
        ),
        centerTitle: false,
        backgroundColor: cardColor,
        elevation: 0,
        actions: [
          if (!isPractice)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: quizProvider.remainingSeconds < 60 ? Colors.red.withAlpha(25) : orangeAccent.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: quizProvider.remainingSeconds < 60 ? Colors.red : orangeAccent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$minutes:$seconds',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: quizProvider.remainingSeconds < 60 ? Colors.red : orangeAccent,
                    ),
                  ),
                ],
              ),
            ),
          IconButton(
            icon: const Icon(Icons.grid_view_rounded),
            tooltip: 'Question Palette',
            onPressed: () => _showQuestionPalette(context, quizProvider),
          ),
          IconButton(
            icon: Icon(
              isMarked ? Icons.bookmark_added_rounded : Icons.bookmark_border_rounded,
              color: isMarked ? const Color(0xFFF59E0B) : null,
            ),
            tooltip: isMarked ? 'Marked for Review' : 'Mark for Review',
            onPressed: quizProvider.toggleMarkForReview,
          ),
        ],
      ),
      body: Column(
        children: [
          // Linear Progress Bar
          LinearProgressIndicator(
            value: totalCount > 0 ? (currentIndex + 1) / totalCount : 0.0,
            backgroundColor: borderColor,
            color: orangeAccent,
            minHeight: 4,
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Topic & Difficulty Tag
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: orangeAccent.withAlpha(isDark ? 35 : 20),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        q.topic,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: orangeAccent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        q.difficulty.name.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: textSubtitle,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Question Statement Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    q.question,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      height: 1.45,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Options List
                ...List.generate(q.options.length, (optIndex) {
                  final optionText = q.options[optIndex];
                  final isSelected = selectedOption == optIndex;
                  final isAnswered = selectedOption != null;

                  Color optBorder = borderColor;
                  Color optBg = cardColor;
                  Color optTextCol = textPrimary;

                  if (isPractice && isAnswered) {
                    if (optIndex == q.correctOptionIndex) {
                      optBorder = const Color(0xFF10B981);
                      optBg = const Color(0xFF10B981).withAlpha(isDark ? 30 : 15);
                      optTextCol = const Color(0xFF10B981);
                    } else if (isSelected) {
                      optBorder = Colors.redAccent;
                      optBg = Colors.redAccent.withAlpha(isDark ? 30 : 15);
                      optTextCol = Colors.redAccent;
                    }
                  } else if (isSelected) {
                    optBorder = orangeAccent;
                    optBg = orangeAccent.withAlpha(isDark ? 30 : 12);
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: optBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: optBorder, width: isSelected ? 1.8 : 1.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? orangeAccent : (isDark ? Colors.white10 : const Color(0xFFF1F5F9)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          String.fromCharCode(65 + optIndex), // A, B, C, D
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isSelected ? Colors.white : textPrimary,
                          ),
                        ),
                      ),
                      title: Text(
                        optionText,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: optTextCol,
                        ),
                      ),
                      onTap: () {
                        quizProvider.selectOption(optIndex);
                      },
                    ),
                  );
                }),

                // Instant Explanation in Practice Mode
                if (isPractice && selectedOption != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (selectedOption == q.correctOptionIndex
                              ? const Color(0xFF10B981)
                              : Colors.orange)
                          .withAlpha(isDark ? 25 : 12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: (selectedOption == q.correctOptionIndex
                                ? const Color(0xFF10B981)
                                : Colors.orange)
                            .withAlpha(60),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              selectedOption == q.correctOptionIndex
                                  ? Icons.check_circle_rounded
                                  : Icons.info_outline_rounded,
                              size: 18,
                              color: selectedOption == q.correctOptionIndex
                                  ? const Color(0xFF10B981)
                                  : Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              selectedOption == q.correctOptionIndex
                                  ? 'Correct Answer!'
                                  : 'Explanation & Concept',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: selectedOption == q.correctOptionIndex
                                    ? const Color(0xFF10B981)
                                    : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          q.explanation,
                          style: GoogleFonts.inter(fontSize: 13, height: 1.45, color: textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Bottom Bar Navigation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: currentIndex > 0 ? quizProvider.previousQuestion : null,
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Previous'),
                ),
                if (currentIndex < totalCount - 1)
                  ElevatedButton.icon(
                    onPressed: quizProvider.nextQuestion,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orangeAccent,
                      foregroundColor: Colors.white,
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: () => _confirmSubmit(context, quizProvider),
                    icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                    label: const Text('Submit Test'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
