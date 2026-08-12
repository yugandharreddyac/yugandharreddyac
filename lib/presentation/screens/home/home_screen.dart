import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/study_provider.dart';
import '../../providers/recent_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/roadmap_provider.dart';
import '../../../data/datasources/non_academic_data.dart';
import '../../../data/models/hierarchy_node_model.dart';
import '../../../data/models/user_goal_model.dart';
import '../hierarchy/generic_topic_screen.dart';
import '../downloads/downloads_screen.dart';
import '../profile/profile_screen.dart';
import '../pdf_viewer/pdf_viewer_screen.dart';
import '../../widgets/home/unibyte_card.dart';
import '../../widgets/home/academic_year_card.dart';
import '../../widgets/home/motivational_banner_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _HomeDashboardView(),
      const DownloadsScreen(),
      const ProfileScreen(),
    ];

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 50 : 10),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            elevation: 0,
            height: 65,
            backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
            indicatorColor: const Color(0xFF2563EB).withAlpha(30),
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF2563EB)),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.download_outlined),
                selectedIcon: Icon(Icons.download_rounded, color: Color(0xFF2563EB)),
                label: 'Downloads',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded, color: Color(0xFF2563EB)),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeDashboardView extends StatefulWidget {
  const _HomeDashboardView();

  @override
  State<_HomeDashboardView> createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends State<_HomeDashboardView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<StudyProvider>().fetchYears();
      }
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning 👋';
    if (hour < 17) return 'Good Afternoon 👋';
    return 'Good Evening 👋';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();

    final studyProvider = context.watch<StudyProvider>();
    final recentProvider = context.watch<RecentProvider>();
    final recents = recentProvider.recentResources;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    // Strict Dual Colors & Tints
    const royalBlue = Color(0xFF2563EB);
    const emeraldGreen = Color(0xFF10B981);

    final blueTintBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF);
    final greenTintBg = isDark ? const Color(0xFF132A22) : const Color(0xFFECFDF5);
    final whiteCardColor = isDark ? AppColors.cardDark : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: RefreshIndicator(
        onRefresh: () async {
          await studyProvider.fetchYears();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // ==========================================
              // 1. ROYAL BLUE HEADER (28px Bottom Curve) & FLOATING SEARCH BAR
              // ==========================================
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 45),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                            : [royalBlue, const Color(0xFF1D4ED8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: royalBlue.withAlpha(isDark ? 30 : 60),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Row Header Actions
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(35),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.school_rounded, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                AppConstants.appName,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white),
                              tooltip: 'Admin Portal',
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.adminDashboard),
                            ),
                            IconButton(
                              icon: const Icon(Icons.download_rounded, color: Colors.white),
                              tooltip: 'Downloads',
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.downloads),
                            ),
                            IconButton(
                              icon: Icon(
                                themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                                color: themeProvider.isDarkMode ? Colors.amberAccent : Colors.white,
                              ),
                              tooltip: 'Toggle Theme',
                              onPressed: () => themeProvider.toggleTheme(),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                              child: const CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.person_rounded, size: 20, color: royalBlue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const MotivationalBannerWidget(),
                        const SizedBox(height: 10),
                        Text(
                          _getGreeting(),
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ready to learn today? • Academic & Career Development Platform',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withAlpha(220),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Floating Search Bar (30px Rounded, Soft Shadow)
                  Positioned(
                    bottom: -26,
                    left: 24,
                    right: 24,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.search),
                      child: AbsorbPointer(
                        child: Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: whiteCardColor,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: borderColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(isDark ? 30 : 10),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search_rounded, color: royalBlue, size: 22),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Search Notes, PYQs, Subjects, AI, Projects...',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: textSubtitle,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.tune_rounded, color: textSubtitle, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn().slideY(begin: -0.05, end: 0),

              const SizedBox(height: 28),

              // ==========================================
              // UNIBYTE BITE-SIZED LEARNING CARD
              // ==========================================
              const UniByteCard().animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==========================================
                    // 4-YEAR CSE STUDENT ROADMAP & NAVIGATOR
                    // ==========================================
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
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: royalBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.explore_rounded, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '4-Year B.Tech CSE Student Roadmap',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: textPrimary,
                                      ),
                                    ),
                                    Text(
                                      'LEARN → BUILD → PRACTICE → INTERN → GRADUATE',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: royalBlue,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _buildRoadmapPhaseChip(
                                  context,
                                  yearLabel: 'Year 1',
                                  title: 'Programming & Logic',
                                  color: const Color(0xFF2563EB),
                                  onTap: () => Navigator.pushNamed(context, AppRoutes.codingHub),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildRoadmapPhaseChip(
                                  context,
                                  yearLabel: 'Year 2',
                                  title: 'DSA & Full-Stack',
                                  color: const Color(0xFF059669),
                                  onTap: () => Navigator.pushNamed(context, AppRoutes.codingHub),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildRoadmapPhaseChip(
                                  context,
                                  yearLabel: 'Year 3',
                                  title: 'AI/Cloud & Projects',
                                  color: const Color(0xFFD97706),
                                  onTap: () => Navigator.pushNamed(context, AppRoutes.projectHub),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildRoadmapPhaseChip(
                                  context,
                                  yearLabel: 'Year 4',
                                  title: 'Placements & GATE',
                                  color: const Color(0xFF7C3AED),
                                  onTap: () => Navigator.pushNamed(context, AppRoutes.placementHub),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.roadmap);
                              },
                              icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                              label: Text(
                                'OPEN MY PERSONALIZED ROADMAP →',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: royalBlue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.05, end: 0),

                    const SizedBox(height: 24),

                    // ==========================================
                    // CONTINUE LEARNING SECTION
                    // ==========================================
                    _buildContinueLearningCard(context, isDark, textPrimary, textSubtitle, royalBlue, emeraldGreen, whiteCardColor, borderColor),

                    const SizedBox(height: 24),

                    // ==========================================
                    // TODAY'S ACTION PLAN QUICK SECTION
                    // ==========================================
                    _buildHomeTodaysPlan(context, isDark, textPrimary, textSubtitle, royalBlue, whiteCardColor, borderColor),

                    const SizedBox(height: 24),
                    
                    // ==========================================
                    // CAREER PROGRESS SECTION
                    // ==========================================
                    _buildCareerProgressSection(context, isDark, textPrimary, textSubtitle, royalBlue, whiteCardColor, borderColor),

                    const SizedBox(height: 24),

                    // ==========================================
                    // RECENTLY VIEWED TOPICS SECTION
                    // ==========================================
                    _buildRecentlyViewedTopicsRow(context, isDark, textPrimary, textSubtitle, royalBlue, whiteCardColor, borderColor),

                    const SizedBox(height: 24),

                    // ==========================================
                    // 2. ACADEMIC CURRICULUM (4 ALTERNATING TINTED CARDS)
                    // ==========================================
                    Text(
                      'Academic Curriculum',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 16),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 700;
                        final crossAxisCount = isWide ? 4 : 2;
                        final childAspectRatio = isWide ? 1.25 : 1.02;

                        return GridView.count(
                          crossAxisCount: crossAxisCount,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: childAspectRatio,
                          children: const [
                            AcademicYearCard(
                              yearTitle: '1st Year',
                              subtitle: 'Foundation & Basic Concepts',
                              yearId: 'year_1',
                            ),
                            AcademicYearCard(
                              yearTitle: '2nd Year',
                              subtitle: 'Core CS & Data Structures',
                              yearId: 'year_2',
                            ),
                            AcademicYearCard(
                              yearTitle: '3rd Year',
                              subtitle: 'Advanced Tech & AI',
                              yearId: 'year_3',
                            ),
                            AcademicYearCard(
                              yearTitle: '4th Year',
                              subtitle: 'Placements & Graduation',
                              yearId: 'year_4',
                            ),
                          ],
                        );
                      },
                    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),

                    const SizedBox(height: 28),

                    // ==========================================
                    // 3. EXPLORE HUBS (UNIFIED PRIMARY BLUE TINT CARDS)
                    // ==========================================
                    Text(
                      'Explore Hubs',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildTintedExploreHubCard(
                      context,
                      title: 'Career Hub',
                      description: 'Emerging Technologies & Career Roadmaps',
                      icon: Icons.rocket_launch_rounded,
                      accentColor: royalBlue,
                      bgColor: blueTintBg,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.careerHub);
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildTintedExploreHubCard(
                      context,
                      title: 'Coding Hub',
                      description: 'Practice Programming & Data Structures',
                      icon: Icons.code_rounded,
                      accentColor: royalBlue,
                      bgColor: blueTintBg,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.codingHub);
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildTintedExploreHubCard(
                      context,
                      title: 'Placement Hub',
                      description: 'Interview Preparation & Company Profiles',
                      icon: Icons.work_rounded,
                      accentColor: royalBlue,
                      bgColor: blueTintBg,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.placementHub);
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildTintedExploreHubCard(
                      context,
                      title: 'Project Hub',
                      description: 'Real World Mini & Major Student Projects',
                      icon: Icons.lightbulb_rounded,
                      accentColor: royalBlue,
                      bgColor: blueTintBg,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.projectHub);
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildTintedExploreHubCard(
                      context,
                      title: 'Higher Education & Competitive Exams',
                      description: 'GATE, GRE, TOEFL, IELTS, CAT, GMAT, MS Abroad & Research Opportunities',
                      icon: Icons.school_rounded,
                      accentColor: royalBlue,
                      bgColor: blueTintBg,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.higherEducationHub);
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildTintedExploreHubCard(
                      context,
                      title: 'Entrepreneurship & Startup Hub',
                      description: 'Ideation, Lean Startup, MVP, Pitch Decks & Fundraising',
                      icon: Icons.rocket_launch_rounded,
                      accentColor: royalBlue,
                      bgColor: blueTintBg,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.entrepreneurshipHub);
                      },
                    ),

                    const SizedBox(height: 28),

                    // ==========================================
                    // 4. RECENTLY ADDED (COMPACT TINTED LIST)
                    // ==========================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recently Added',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
                          icon: Text(
                            'View All',
                            style: GoogleFonts.inter(
                              color: royalBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          label: const Icon(Icons.arrow_forward_rounded, size: 16, color: royalBlue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    recents.isEmpty
                        ? _buildRecentFallbackList(context, royalBlue, emeraldGreen, whiteCardColor, borderColor, textPrimary, textSubtitle)
                        : Column(
                            children: recents.take(5).map((recent) {
                              final resource = recent.toResourceModel();
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: whiteCardColor,
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
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: royalBlue.withAlpha(20),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.description_rounded, color: royalBlue, size: 20),
                                  ),
                                  title: Text(
                                    recent.resourceTitle,
                                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 17, color: textPrimary),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: royalBlue.withAlpha(12),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            recent.resourceType,
                                            style: GoogleFonts.inter(
                                              color: royalBlue,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          Formatters.formatDate(recent.openedAt),
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
                            }).toList(),
                          ),

                    const SizedBox(height: 28),

                    // ==========================================
                    // 5. QUICK ACTIONS (VERTICAL FULL-WIDTH TINTED CARDS)
                    // ==========================================
                    Text(
                      'Quick Actions',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildVerticalTintedQuickActionTile(
                      context,
                      title: 'Offline Downloads',
                      description: 'Read downloaded PDFs anytime.',
                      icon: Icons.download_rounded,
                      accentColor: emeraldGreen,
                      bgColor: greenTintBg,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.downloads),
                    ),
                    const SizedBox(height: 12),

                    _buildVerticalTintedQuickActionTile(
                      context,
                      title: 'Saved Resources',
                      description: 'Your bookmarked notes and papers.',
                      icon: Icons.bookmark_rounded,
                      accentColor: royalBlue,
                      bgColor: blueTintBg,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.bookmarks),
                    ),
                    const SizedBox(height: 12),

                    _buildVerticalTintedQuickActionTile(
                      context,
                      title: 'Continue Learning',
                      description: 'Resume from your last opened PDF.',
                      icon: Icons.history_rounded,
                      accentColor: emeraldGreen,
                      bgColor: greenTintBg,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                    ),
                    const SizedBox(height: 12),

                    _buildVerticalTintedQuickActionTile(
                      context,
                      title: 'Trusted Content',
                      description: 'Official syllabus, notes & previous papers.',
                      icon: Icons.verified_user_rounded,
                      accentColor: royalBlue,
                      bgColor: blueTintBg,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.about),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  // --- ROADMAP PHASE CHIP ---
  Widget _buildRoadmapPhaseChip(
    BuildContext context, {
    required String yearLabel,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? color.withAlpha(40) : color.withAlpha(18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                yearLabel,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- EXPLORE HUB TINTED CARD ---
  Widget _buildTintedExploreHubCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color accentColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: textSubtitle,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: accentColor),
          ],
        ),
      ),
    );
  }

  // --- RECENTLY ADDED FALLBACK ITEMS ---
  Widget _buildRecentFallbackList(
    BuildContext context,
    Color royalBlue,
    Color emeraldGreen,
    Color whiteCardColor,
    Color borderColor,
    Color textPrimary,
    Color textSubtitle,
  ) {
    final sampleItems = [
      {'title': 'Operating Systems Notes', 'cat': 'Notes', 'time': 'Today', 'color': royalBlue},
      {'title': 'DBMS PYQ', 'cat': 'Question Paper', 'time': 'Yesterday', 'color': emeraldGreen},
      {'title': 'Artificial Intelligence Roadmap', 'cat': 'Career Hub', 'time': 'Today', 'color': royalBlue},
    ];

    return Column(
      children: sampleItems.map((item) {
        final itemColor = item['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: whiteCardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(6),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: itemColor.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.description_rounded, color: itemColor, size: 20),
            ),
            title: Text(item['title'] as String, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 17, color: textPrimary)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: itemColor.withAlpha(15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item['cat'] as String,
                      style: GoogleFonts.inter(
                        color: itemColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(item['time'] as String, style: GoogleFonts.inter(fontSize: 13, color: textSubtitle)),
                ],
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
            onTap: () => Navigator.pushNamed(context, AppRoutes.search),
          ),
        );
      }).toList(),
    );
  }

  // --- VERTICAL QUICK ACTION TILE (Radius 16, Full Width, Tinted) ---
  Widget _buildVerticalTintedQuickActionTile(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color accentColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 25 : 6),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: textSubtitle,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: accentColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTodaysPlan(
    BuildContext context,
    bool isDark,
    Color textPrimary,
    Color textSubtitle,
    Color royalBlue,
    Color whiteCardColor,
    Color borderColor,
  ) {
    RoadmapProvider? roadmapProvider;
    try {
      roadmapProvider = context.watch<RoadmapProvider>();
    } catch (_) {}

    final todaysPlan = roadmapProvider?.getTodaysPlan() ?? [];
    if (todaysPlan.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Recommended Plan',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.roadmap),
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  color: royalBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: todaysPlan.take(3).map((task) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () {
                  if (task.actionRoute != null) {
                     Navigator.pushNamed(context, task.actionRoute!, arguments: task.actionArguments);
                     return;
                  }
                  final match = NonAcademicData.findTopicById(task.topicId);
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
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: whiteCardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(isDark ? 25 : 6),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: royalBlue.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.play_arrow_rounded, color: royalBlue, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.topicTitle,
                              style: GoogleFonts.inter(
                                fontSize: 15,
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
                            if (task.reason != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                task.reason!,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: royalBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (task.progressText != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: royalBlue.withAlpha(20),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                task.progressText!,
                                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: royalBlue),
                              ),
                            ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${task.estimatedMinutes}m',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: textSubtitle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCareerProgressSection(
    BuildContext context,
    bool isDark,
    Color textPrimary,
    Color textSubtitle,
    Color royalBlue,
    Color whiteCardColor,
    Color borderColor,
  ) {
    RoadmapProvider? roadmapProvider;
    try {
      roadmapProvider = context.watch<RoadmapProvider>();
    } catch (_) {}

    final milestones = roadmapProvider?.getCareerMilestones() ?? [];
    if (milestones.isEmpty) return const SizedBox.shrink();

    final goalTitle = roadmapProvider?.profile?.goal.title ?? 'Software / IT Placement';
    final completedCount = milestones.where((m) => m.isCompleted).length;
    final totalCount = milestones.length;
    
    CareerMilestoneModel? nextMilestone;
    try {
      nextMilestone = milestones.firstWhere((m) => !m.isCompleted);
    } catch (_) {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Career Progress',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.careerDashboard);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whiteCardColor,
              borderRadius: BorderRadius.circular(16),
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
              Text('CURRENT GOAL', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: textSubtitle, letterSpacing: 0.5)),
              Text(goalTitle, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: royalBlue)),
              const SizedBox(height: 16),
              if (nextMilestone != null) ...[
                Text('NEXT MILESTONE', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: textSubtitle, letterSpacing: 0.5)),
                Text(nextMilestone.title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
                const SizedBox(height: 16),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$completedCount / $totalCount milestones completed', style: GoogleFonts.inter(fontSize: 12, color: textSubtitle)),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.roadmap),
                    child: Text('VIEW ROADMAP →', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: royalBlue)),
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
      ],
    );
  }

  Widget _buildContinueLearningCard(
    BuildContext context,
    bool isDark,
    Color textPrimary,
    Color textSubtitle,
    Color royalBlue,
    Color emeraldGreen,
    Color whiteCardColor,
    Color borderColor,
  ) {
    RoadmapProvider? roadmapProvider;
    try {
      roadmapProvider = context.watch<RoadmapProvider>();
    } catch (_) {}

    final lastOpenedId = roadmapProvider?.lastOpenedTopicId;
    if (lastOpenedId == null || lastOpenedId.isEmpty) return const SizedBox.shrink();

    final match = NonAcademicData.findTopicById(lastOpenedId);
    if (match == null) return const SizedBox.shrink();

    final progress = roadmapProvider!.getProgressForTopic(lastOpenedId);
    if (progress.isFullyCompleted) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Continue Learning',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: whiteCardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: royalBlue.withAlpha(120), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: royalBlue.withAlpha(isDark ? 30 : 12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: royalBlue.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(match.topic.icon, color: royalBlue, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match.topic.title,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${match.category.title} • ${progress.completedCount}/4 activities (${progress.percentage.toStringAsFixed(0)}%)',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: textSubtitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress.percentage / 100.0,
                  minHeight: 6,
                  backgroundColor: isDark ? Colors.black.withAlpha(64) : const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress.percentage > 0 ? emeraldGreen : royalBlue,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton.icon(
                  onPressed: () {
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
                  },
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  label: Text(
                    'RESUME TOPIC →',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: royalBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentlyViewedTopicsRow(
    BuildContext context,
    bool isDark,
    Color textPrimary,
    Color textSubtitle,
    Color royalBlue,
    Color whiteCardColor,
    Color borderColor,
  ) {
    RoadmapProvider? roadmapProvider;
    try {
      roadmapProvider = context.watch<RoadmapProvider>();
    } catch (_) {}

    final recentIds = roadmapProvider?.recentTopicIds ?? [];
    if (recentIds.isEmpty) return const SizedBox.shrink();

    final validMatches = recentIds
        .map((id) => NonAcademicData.findTopicById(id))
        .where((m) => m != null)
        .cast<({CategoryModel category, HubModel hub, HierarchicalTopicModel topic})>()
        .toList();

    if (validMatches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recently Viewed Topics',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.savedTopics),
              child: Text(
                'View Saved',
                style: GoogleFonts.inter(
                  color: royalBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: validMatches.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final match = validMatches[index];
              return InkWell(
                onTap: () {
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
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: whiteCardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(match.topic.icon, size: 18, color: royalBlue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              match.topic.title,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        match.category.title,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: textSubtitle,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
