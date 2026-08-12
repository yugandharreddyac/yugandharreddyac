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
}
