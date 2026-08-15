import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/quiz_model.dart';
import '../../../providers/quiz_provider.dart';
import 'quiz_session_screen.dart';

class QuizHubScreen extends StatefulWidget {
  final String? initialCategory;

  const QuizHubScreen({super.key, this.initialCategory});

  @override
  State<QuizHubScreen> createState() => _QuizHubScreenState();
}

class _QuizHubScreenState extends State<QuizHubScreen> {
  late String _selectedCategory;
  QuizMode _selectedMode = QuizMode.practice;
  String _selectedTopic = 'All';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'Quantitative Aptitude';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().init();
    });
  }

  void _startQuiz() async {
    final quizProvider = context.read<QuizProvider>();
    await quizProvider.startQuiz(
      category: _selectedCategory,
      mode: _selectedMode,
      topic: _selectedTopic == 'All' ? null : _selectedTopic,
    );

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const QuizSessionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final quizProvider = context.watch<QuizProvider>();
    final categories = quizProvider.categories;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    const orangeAccent = AppColors.primary;
    const royalBlue = Color(0xFF2563EB);

    final currentCatInfo = categories.firstWhere(
      (c) => c.title.toLowerCase() == _selectedCategory.toLowerCase(),
      orElse: () => categories.isNotEmpty
          ? categories.first
          : const QuizCategoryInfo(
              id: 'aptitude',
              title: 'Quantitative Aptitude',
              description: 'Aptitude tests',
              icon: Icons.calculate_rounded,
              accentColor: orangeAccent,
              subTopics: ['Percentages', 'Time & Work'],
            ),
    );

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                tooltip: 'Back',
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          'Placement Mock Quiz & Test Engine',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: cardColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Top Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [royalBlue, const Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.fact_check_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Interactive Test Simulator',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Practice Aptitude, Reasoning & CS MCQs with instant feedback or timed mock exams.',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 1. Select Category
          Text(
            '1. Select Assessment Track',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
          ),
          const SizedBox(height: 12),
          Column(
            children: categories.map((cat) {
              final isSelected = _selectedCategory.toLowerCase() == cat.title.toLowerCase();
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? cat.accentColor : borderColor,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cat.accentColor.withAlpha(isDark ? 40 : 20),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(cat.icon, color: cat.accentColor, size: 24),
                  ),
                  title: Text(
                    cat.title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    cat.description,
                    style: GoogleFonts.inter(fontSize: 12, color: textSubtitle),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle_rounded, color: cat.accentColor)
                      : const Icon(Icons.radio_button_unchecked_rounded, color: Colors.grey),
                  onTap: () {
                    setState(() {
                      _selectedCategory = cat.title;
                      _selectedTopic = 'All';
                    });
                  },
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // 2. Select Quiz Mode
          Text(
            '2. Select Evaluation Mode',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildModeCard(
                  title: 'Practice Mode',
                  subtitle: 'Untimed • Instant Explanations',
                  mode: QuizMode.practice,
                  icon: Icons.school_rounded,
                  color: const Color(0xFF10B981),
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModeCard(
                  title: 'Timed Mock Test',
                  subtitle: '60s per Q • Final Scorecard',
                  mode: QuizMode.mockTest,
                  icon: Icons.timer_rounded,
                  color: orangeAccent,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 3. Sub-topic Filter
          Text(
            '3. Topic Focus',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', ...currentCatInfo.subTopics].map((top) {
                final isSelected = _selectedTopic == top;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      top,
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: currentCatInfo.accentColor,
                    backgroundColor: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: isSelected ? currentCatInfo.accentColor : borderColor),
                    ),
                    onSelected: (val) {
                      if (val) {
                        setState(() => _selectedTopic = top);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 32),

          // Start Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _startQuiz,
              icon: const Icon(Icons.play_arrow_rounded, size: 22),
              label: Text(
                _selectedMode == QuizMode.mockTest
                    ? 'Start Timed Mock Exam'
                    : 'Start Interactive Practice Session',
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: currentCatInfo.accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required String title,
    required String subtitle,
    required QuizMode mode,
    required IconData icon,
    required Color color,
    required Color cardColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSubtitle,
  }) {
    final isSelected = _selectedMode == mode;

    return InkWell(
      onTap: () => setState(() => _selectedMode = mode),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.inter(fontSize: 11, color: textSubtitle),
            ),
          ],
        ),
      ),
    );
  }
}
