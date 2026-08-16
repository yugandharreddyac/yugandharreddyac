import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/user_goal_model.dart';
import '../../../data/models/personalized_roadmap_models.dart';
import '../../../data/datasources/non_academic_data.dart';
import '../../providers/roadmap_provider.dart';
import '../hierarchy/generic_topic_screen.dart';
import 'roadmap_onboarding_screen.dart';
import 'wizard/personalized_wizard_screen.dart';

class MyRoadmapScreen extends StatelessWidget {
  const MyRoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roadmapProvider = context.watch<RoadmapProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const orangeAccent = AppColors.primary;
    const royalBlue = Color(0xFF2563EB);
    const emeraldGreen = Color(0xFF059669);
    final cardBg = isDark ? AppColors.surfaceDark : Colors.white;
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    if (roadmapProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (roadmapProvider.hasPersonalizedRoadmap) {
      return _buildPersonalizedScreen(
        context,
        roadmapProvider,
        roadmapProvider.personalizedRoadmap!,
        isDark,
        royalBlue,
        orangeAccent,
        emeraldGreen,
        cardBg,
        textPrimary,
        textSubtitle,
      );
    }

    final profile = roadmapProvider.profile;
    final overallProgress = roadmapProvider.calculateOverallProgress();
    final stages = roadmapProvider.getRoadmapStages();
    final todaysPlan = roadmapProvider.getTodaysPlan();
    final stageHealths = roadmapProvider.roadmapHealth?.stageHealths ?? [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          tooltip: 'Back',
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
        ),
        title: Text(
          'My CSE Learning Navigator',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Customize Target Goal',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RoadmapOnboardingScreen(),
                ),
              );
            },
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Goal Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                      : [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF4338CA) : const Color(0xFFBFDBFE),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: orangeAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          profile?.goal.icon ?? Icons.work_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.goal.title ?? 'Software Engineer Roadmap',
                              style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            Text(
                              'Target: ${profile?.year.label ?? '1st Year'} • ${profile?.preferredDomain ?? 'Full-Stack'}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: orangeAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Progress Bar & Percentage
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Overall Completion',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textSubtitle,
                        ),
                      ),
                      Text(
                        '${overallProgress.toStringAsFixed(0)}%',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: overallProgress > 0 ? emeraldGreen : orangeAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: overallProgress / 100.0,
                      minHeight: 10,
                      backgroundColor: isDark ? Colors.black.withAlpha(64) : const Color(0xFFCBD5E1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        overallProgress > 0 ? emeraldGreen : orangeAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Today's Action Plan Header
            Text(
              'Today\'s Recommended Action Plan',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Recommended daily learning activities based on your year and target goal.',
              style: GoogleFonts.inter(fontSize: 12, color: textSubtitle),
            ),
            const SizedBox(height: 12),

            // Today's Plan Cards
            Column(
              children: todaysPlan.map((task) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => _navigateToTopic(context, task.topicId),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: royalBlue.withAlpha(20),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.play_arrow_rounded, color: royalBlue, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.topicTitle,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  task.actionTitle,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: textSubtitle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: textSubtitle),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            // Roadmap Stages Progression
            Text(
              'Your 4-Stage Learning Path',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            Column(
              children: stages.asMap().entries.map((entry) {
                final index = entry.key;
                final stage = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: royalBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'STAGE ${index + 1}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              stage.stageTitle,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Roadmap Health metrics for this stage
                      if (index < stageHealths.length) ...[
                        Builder(
                          builder: (context) {
                            final stageHealth = stageHealths[index];
                            final isCurrent = roadmapProvider.roadmapHealth?.currentStageName == stageHealth.name;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isCurrent ? royalBlue.withAlpha(20) : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: isCurrent ? royalBlue.withAlpha(50) : Colors.transparent),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.bar_chart_rounded, size: 14, color: isCurrent ? royalBlue : textSubtitle),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${stageHealth.completed} / ${stageHealth.total} completed',
                                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: isCurrent ? royalBlue : textSubtitle),
                                  ),
                                  if (isCurrent) ...[
                                    const Spacer(),
                                    Text(
                                      'CURRENT STAGE',
                                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: royalBlue, letterSpacing: 0.5),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                        if (roadmapProvider.roadmapHealth?.blockingTopicTitle != null && roadmapProvider.roadmapHealth?.currentStageName == stage.stageTitle)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red.withAlpha(20),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.withAlpha(50)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.block_rounded, size: 14, color: Colors.red),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'BLOCKING: ${roadmapProvider.roadmapHealth?.blockingTopicTitle ?? ''}',
                                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                      Text(
                        stage.stageDescription,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: textSubtitle,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: stage.topicIds.map((tId) {
                          final match = NonAcademicData.findTopicById(tId);
                          final title = match?.topic.title ?? tId;
                          final progress = roadmapProvider.getProgressForTopic(tId);
                          final isDone = progress.isFullyCompleted;

                          return InkWell(
                            onTap: () => _navigateToTopic(context, tId),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDone
                                    ? emeraldGreen.withAlpha(20)
                                    : progress.isInProgress ? royalBlue.withAlpha(20) : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDone
                                      ? emeraldGreen
                                      : progress.isInProgress ? royalBlue : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                                  width: (isDone || progress.isInProgress) ? 1.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isDone) ...[
                                    const Icon(Icons.check_circle_rounded, size: 13, color: emeraldGreen),
                                    const SizedBox(width: 4),
                                  ] else if (progress.isInProgress) ...[
                                    const Icon(Icons.arrow_forward_rounded, size: 13, color: royalBlue),
                                    const SizedBox(width: 4),
                                  ] else ...[
                                    Icon(Icons.radio_button_unchecked_rounded, size: 13, color: textSubtitle.withOpacity(0.5)),
                                    const SizedBox(width: 4),
                                  ],
                                  Flexible(
                                    child: Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: isDone ? FontWeight.bold : FontWeight.w600,
                                        color: isDone ? emeraldGreen : (progress.isInProgress ? royalBlue : textPrimary),
                                      ),
                                    ),
                                  ),
                                  if (!isDone) ...[
                                    const SizedBox(width: 4),
                                    const Icon(Icons.arrow_forward_rounded, size: 12, color: royalBlue),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTopic(BuildContext context, String topicId) {
    final match = NonAcademicData.findTopicById(topicId);
    if (match != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GenericTopicScreen(
            hub: match.hub,
            category: match.category,
            topic: match.topic,
            breadcrumbTrail: [match.hub.title, match.category.title, match.topic.title],
          ),
        ),
      );
    }
  }

  Widget _buildPersonalizedScreen(
    BuildContext context,
    RoadmapProvider provider,
    PersonalizedRoadmap roadmap,
    bool isDark,
    Color royalBlue,
    Color orangeAccent,
    Color emeraldGreen,
    Color cardBg,
    Color textPrimary,
    Color textSubtitle,
  ) {
    final todaysTasks = provider.getTodaysPersonalizedTasks();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          tooltip: 'Back',
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
        ),
        title: Text(
          roadmap.title,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Update / Recalculate Roadmap',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonalizedWizardScreen(
                    initialProfile: provider.personalizedProfile,
                    onProfileCreated: (updatedProfile) {
                      provider.recalculatePersonalizedRoadmap(updatedProfile);
                    },
                  ),
                ),
              );
            },
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Stats Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                      : [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF4338CA) : const Color(0xFFBFDBFE),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2563EB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              roadmap.targetCareer,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            Text(
                              'Goal: ${roadmap.mainGoal} • ${roadmap.targetTimeline} • ${roadmap.dailyMinutes}m/day',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF2563EB),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Overall Progress',
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textSubtitle),
                      ),
                      Text(
                        '${roadmap.overallProgress.toStringAsFixed(0)}% (${roadmap.completedItemsCount}/${roadmap.totalItemsCount})',
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: roadmap.overallProgress / 100.0,
                      minHeight: 8,
                      backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.ai,
                        arguments: {
                          'roadmapTitle': roadmap.targetCareer,
                          'prompt': 'Analyze my active roadmap "${roadmap.targetCareer}" (Phase ${roadmap.currentPhaseIndex + 1}: ${roadmap.currentPhase?.title ?? 'Active Phase'}) and recommend the best strategy to complete today\'s tasks efficiently.',
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withOpacity(isDark ? 0.2 : 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_awesome_rounded, size: 14, color: Color(0xFF6366F1)),
                          const SizedBox(width: 6),
                          Text(
                            'Ask UniDocs AI About Roadmap',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6366F1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Today's Learning Plan
            if (todaysTasks.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Learning Plan",
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Target: ${roadmap.dailyMinutes} min',
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF2563EB)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                children: todaysTasks.map((task) {
                  return _buildPersonalizedItemCard(
                    context,
                    provider,
                    task,
                    isDark,
                    cardBg,
                    textPrimary,
                    textSubtitle,
                    royalBlue,
                    emeraldGreen,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Phased Learning Tracks
            Text(
              'Roadmap Learning Phases',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
            ),
            const SizedBox(height: 12),
            Column(
              children: roadmap.phases.map((phase) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              phase.title,
                              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimary),
                            ),
                          ),
                          Text(
                            phase.estimatedDuration,
                            style: GoogleFonts.inter(fontSize: 11, color: textSubtitle, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        phase.description,
                        style: GoogleFonts.inter(fontSize: 12, color: textSubtitle),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: phase.completionPercentage / 100.0,
                          minHeight: 6,
                          backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            phase.isFullyCompleted ? emeraldGreen : royalBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Column(
                        children: phase.items.map((item) {
                          return _buildPersonalizedItemCard(
                            context,
                            provider,
                            item,
                            isDark,
                            isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                            textPrimary,
                            textSubtitle,
                            royalBlue,
                            emeraldGreen,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalizedItemCard(
    BuildContext context,
    RoadmapProvider provider,
    RoadmapItem item,
    bool isDark,
    Color cardBg,
    Color textPrimary,
    Color textSubtitle,
    Color royalBlue,
    Color emeraldGreen,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isCompleted
              ? emeraldGreen.withAlpha(120)
              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  item.isCompleted
                      ? Icons.check_circle_rounded
                      : (item.isLocked ? Icons.lock_outline_rounded : Icons.radio_button_unchecked_rounded),
                  color: item.isCompleted ? emeraldGreen : (item.isLocked ? Colors.grey : royalBlue),
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: item.isLocked
                    ? null
                    : () {
                        provider.markPersonalizedItemStatus(
                          item.id,
                          item.isCompleted ? RoadmapItemStatus.notStarted : RoadmapItemStatus.completed,
                        );
                      },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.title,
                  style: GoogleFonts.inter(
                    fontWeight: item.isCompleted ? FontWeight.bold : FontWeight.w600,
                    fontSize: 13,
                    color: item.isCompleted
                        ? emeraldGreen
                        : (item.isLocked ? textSubtitle : textPrimary),
                    decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              _buildPriorityChip(item.priority),
            ],
          ),
          if (item.recommendationReason != null) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                '💡 ${item.recommendationReason!}',
                style: GoogleFonts.inter(fontSize: 11, color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E40AF)),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Row(
              children: [
                Text(
                  '⏱ ${item.estimatedMinutes}m • ${item.difficulty.displayName}',
                  style: GoogleFonts.inter(fontSize: 11, color: textSubtitle),
                ),
                const Spacer(),
                if (item.deepRoute != null && !item.isLocked)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.open_in_new_rounded, size: 13),
                    label: Text('Open Resource', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      if (item.resourceType == 'hub_topic' && item.resourceReference != null) {
                        final match = NonAcademicData.findTopicById(item.resourceReference!);
                        if (match != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GenericTopicScreen(
                                hub: match.hub,
                                category: match.category,
                                topic: match.topic,
                                breadcrumbTrail: [match.hub.title, match.category.title, match.topic.title],
                              ),
                            ),
                          );
                          return;
                        }
                      }
                      if (item.deepRoute != null) {
                        Navigator.pushNamed(
                          context,
                          item.deepRoute!,
                          arguments: item.routeArguments,
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(RoadmapItemPriority priority) {
    Color bg;
    Color fg;

    switch (priority) {
      case RoadmapItemPriority.critical:
        bg = const Color(0xFFEF4444).withAlpha(25);
        fg = const Color(0xFFEF4444);
        break;
      case RoadmapItemPriority.high:
        bg = const Color(0xFFF59E0B).withAlpha(25);
        fg = const Color(0xFFF59E0B);
        break;
      case RoadmapItemPriority.medium:
        bg = const Color(0xFF2563EB).withAlpha(25);
        fg = const Color(0xFF2563EB);
        break;
      case RoadmapItemPriority.optional:
        bg = const Color(0xFF6B7280).withAlpha(25);
        fg = const Color(0xFF6B7280);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        priority.displayName,
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
}
