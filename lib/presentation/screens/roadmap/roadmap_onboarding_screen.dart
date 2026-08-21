import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/user_goal_model.dart';
import '../../providers/roadmap_provider.dart';

class RoadmapOnboardingScreen extends StatefulWidget {
  const RoadmapOnboardingScreen({super.key});

  @override
  State<RoadmapOnboardingScreen> createState() =>
      _RoadmapOnboardingScreenState();
}

class _RoadmapOnboardingScreenState extends State<RoadmapOnboardingScreen> {
  StudentYear _selectedYear = StudentYear.firstYear;
  CareerGoal _selectedGoal = CareerGoal.softwarePlacement;
  final String _selectedDomain = 'Full-Stack Web & Mobile';
  final int _hoursPerWeek = 10;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const royalBlue = Color(0xFF2563EB);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubtitle =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personalize Your CSE Roadmap',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), royalBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.explore_rounded,
                          color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'CSSED Navigator',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Set your academic year and career target to generate your customized 4-year Computer Science learning path.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white.withAlpha(220),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Step-by-Step Personalized Wizard CTA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF4338CA)
                      : const Color(0xFFBFDBFE),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded,
                          color: Color(0xFF2563EB), size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Comprehensive 14-Step Personalization',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: textPrimary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Build an in-depth profile covering strengths, weaknesses, coding experience, available daily hours, and target companies.',
                    style: GoogleFonts.inter(fontSize: 12, color: textSubtitle),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AppRoutes.personalizedWizard);
                      },
                      icon: const Icon(Icons.psychology_rounded, size: 18),
                      label: Text('Launch 14-Step Wizard',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: royalBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Step 1: Select Academic Year
            Text(
              'Quick Setup: Academic Year',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: StudentYear.values.map((year) {
                final isSelected = _selectedYear == year;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedYear = year),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? royalBlue
                            : isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? royalBlue : Colors.transparent,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            year.shortLabel,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isSelected ? Colors.white : textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            year.label,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: isSelected
                                  ? Colors.white.withAlpha(200)
                                  : textSubtitle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            // Step 2: Select Primary Career Goal
            Text(
              '2. What is Your Primary Career Target?',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: CareerGoal.values.map((goal) {
                final isSelected = _selectedGoal == goal;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => setState(() => _selectedGoal = goal),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                ? const Color(0xFF1E3A8A)
                                : const Color(0xFFEFF6FF))
                            : cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? royalBlue
                              : (isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE2E8F0)),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? royalBlue
                                  : royalBlue.withAlpha(20),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              goal.icon,
                              color: isSelected ? Colors.white : royalBlue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  goal.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle_rounded,
                                color: royalBlue, size: 22),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Save & Launch Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () async {
                  final provider = context.read<RoadmapProvider>();
                  final navigator = Navigator.of(context);
                  final profile = UserGoalProfile(
                    year: _selectedYear,
                    goal: _selectedGoal,
                    preferredDomain: _selectedDomain,
                    hoursPerWeek: _hoursPerWeek,
                  );
                  await provider.setGoalProfile(profile);
                  if (mounted) {
                    navigator.pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: royalBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Generate My CSE Roadmap',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
