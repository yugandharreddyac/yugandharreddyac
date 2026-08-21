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
import '../../widgets/navigation/app_desktop_shell.dart';
import '../../widgets/navigation/app_navigation_drawer.dart';

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

    final isDesktop = MediaQuery.of(context).size.width >= 850;

    return AppDesktopShell(
      currentRoute: AppRoutes.home,
      child: Scaffold(
        drawer: const AppNavigationDrawer(),
        backgroundColor:
            isDark ? AppColors.backgroundDark : const Color(0xFFF4F4F5),
        body: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
        bottomNavigationBar: isDesktop
            ? null
            : Container(
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
                    backgroundColor:
                        isDark ? AppColors.surfaceDark : Colors.white,
                    indicatorColor: AppColors.primary.withAlpha(35),
                    onDestinationSelected: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon:
                            Icon(Icons.home_rounded, color: AppColors.primary),
                        label: 'Home',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.download_outlined),
                        selectedIcon: Icon(Icons.download_rounded,
                            color: AppColors.primary),
                        label: 'Downloads',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.person_outline_rounded),
                        selectedIcon: Icon(Icons.person_rounded,
                            color: AppColors.primary),
                        label: 'Profile',
                      ),
                    ],
                  ),
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

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF4F4F5);
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE4E4E7);
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : const Color(0xFF09090B);
    final textSubtitle =
        isDark ? AppColors.textSecondaryDark : const Color(0xFF71717A);
    const orangeAccent = AppColors.primary;
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;
    final isDesktop = MediaQuery.of(context).size.width >= 850;

    return Container(
      color: bgColor,
      child: RefreshIndicator(
        color: orangeAccent,
        onRefresh: () async {
          await studyProvider.fetchYears();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // --- STREAMLINED HEADER BASED ON VIEWPORT ---
              if (isDesktop)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting(),
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Continue your Computer Science journey.',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: textSubtitle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          const Flexible(
                            child: MotivationalBannerWidget(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Desktop Search Bar
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.search),
                        child: AbsorbPointer(
                          child: Container(
                            height: 46,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(23),
                              border:
                                  Border.all(color: orangeAccent, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withAlpha(isDark ? 40 : 10),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search_rounded,
                                    color: orangeAccent, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Search subjects, notes, PYQs, coding, projects...',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: textSubtitle,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.tune_rounded,
                                    color: textSubtitle, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                // --- MOBILE COMPACT HEADER ---
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 42),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF18181B)
                            : const Color(0xFF09090B),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 50 : 30),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Builder(
                                builder: (scaffoldCtx) => IconButton(
                                  icon: const Icon(Icons.menu_rounded,
                                      color: Colors.white, size: 24),
                                  tooltip: 'Navigation Menu',
                                  onPressed: () =>
                                      Scaffold.of(scaffoldCtx).openDrawer(),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: orangeAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.terminal_rounded,
                                    color: Colors.white, size: 18),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  AppConstants.appName,
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF6366F1),
                                        Color(0xFF8B5CF6)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.auto_awesome_rounded,
                                      size: 14, color: Colors.white),
                                ),
                                tooltip: 'UniDocs AI',
                                onPressed: () =>
                                    Navigator.pushNamed(context, AppRoutes.ai),
                              ),
                              IconButton(
                                icon: Icon(
                                  themeProvider.isDarkMode
                                      ? Icons.light_mode_rounded
                                      : Icons.dark_mode_rounded,
                                  color: themeProvider.isDarkMode
                                      ? Colors.amberAccent
                                      : Colors.white70,
                                ),
                                tooltip: 'Toggle Theme',
                                onPressed: () => themeProvider.toggleTheme(),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, AppRoutes.profile),
                                child: const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: orangeAccent,
                                  child: Icon(Icons.person_rounded,
                                      size: 18, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const MotivationalBannerWidget(),
                          const SizedBox(height: 8),
                          Text(
                            _getGreeting(),
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Continue your Computer Science journey.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Mobile Search Bar Overlay
                    Positioned(
                      bottom: -24,
                      left: 20,
                      right: 20,
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.search),
                        child: AbsorbPointer(
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(24),
                              border:
                                  Border.all(color: orangeAccent, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withAlpha(isDark ? 40 : 10),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search_rounded,
                                    color: orangeAccent, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Search subjects, notes, PYQs...',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: textSubtitle,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.tune_rounded,
                                    color: textSubtitle, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn().slideY(begin: -0.05, end: 0),

              SizedBox(height: isDesktop ? 16 : 32),

              // --- CS QUICK BYTE ---
              const UniByteCard()
                  .animate()
                  .fadeIn(delay: 80.ms)
                  .slideY(begin: 0.05, end: 0),

              const SizedBox(height: 12),

              // --- COMPACT ROADMAP SUMMARY TILE ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: orangeAccent.withAlpha(20),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.map_rounded,
                            color: orangeAccent, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PERSONAL ROADMAP',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                                color: orangeAccent,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Track your CS milestones & topics',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.roadmap),
                        style: TextButton.styleFrom(
                          foregroundColor: orangeAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Open Path',
                              style: GoogleFonts.inter(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.arrow_forward_rounded, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // --- COMPACT QUICK ACCESS GRID ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildCompactQuickAccessGrid(
                    context,
                    isDark,
                    textPrimary,
                    textSubtitle,
                    cardColor,
                    borderColor,
                    orangeAccent),
              ),
              const SizedBox(height: 20),

              // --- ACADEMIC CURRICULUM GRID ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Academic Curriculum',
                                style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                    letterSpacing: -0.3),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Explore core computer science courses organized by academic year',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: textSubtitle,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.years),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View All',
                                style: GoogleFonts.inter(
                                  color: orangeAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_rounded,
                                  size: 14, color: orangeAccent),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 700;
                        final isMedium = constraints.maxWidth > 480;
                        final crossAxisCount = isWide ? 4 : (isMedium ? 2 : 1);
                        final childAspectRatio =
                            isWide ? 2.5 : (isMedium ? 2.6 : 3.8);

                        return GridView.count(
                          crossAxisCount: crossAxisCount,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: childAspectRatio,
                          children: const [
                            AcademicYearCard(
                                yearTitle: '1st Year',
                                subtitle: 'Foundation & Basic Concepts',
                                yearId: 'year_1'),
                            AcademicYearCard(
                                yearTitle: '2nd Year',
                                subtitle: 'Core CS & Data Structures',
                                yearId: 'year_2'),
                            AcademicYearCard(
                                yearTitle: '3rd Year',
                                subtitle: 'Advanced Tech & Systems',
                                yearId: 'year_3'),
                            AcademicYearCard(
                                yearTitle: '4th Year',
                                subtitle: 'Placements & Capstone',
                                yearId: 'year_4'),
                          ],
                        );
                      },
                    )
                        .animate()
                        .fadeIn(delay: 100.ms)
                        .slideY(begin: 0.05, end: 0),
                    const SizedBox(height: 24),

                    // --- CAREER & PRACTICAL HUBS ---
                    Text(
                      'Career & Practical Hubs',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Specialized hubs for coding, placements, projects & higher studies',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: textSubtitle,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildHubsGrid(context, isDark, textPrimary, textSubtitle,
                        cardColor, borderColor, orangeAccent),
                    const SizedBox(height: 24),

                    // --- RECENTLY ADDED RESOURCES ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Recently Added',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                              letterSpacing: -0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.search),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View All',
                                style: GoogleFonts.inter(
                                  color: orangeAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_rounded,
                                  size: 14, color: orangeAccent),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    recents.isEmpty
                        ? _buildRecentFallbackList(context, orangeAccent,
                            cardColor, borderColor, textPrimary, textSubtitle)
                        : Column(
                            children: recents.take(4).map((recent) {
                              final resource = recent.toResourceModel();
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: borderColor),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withAlpha(isDark ? 30 : 5),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 4),
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: orangeAccent.withAlpha(20),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.description_rounded,
                                        color: orangeAccent, size: 18),
                                  ),
                                  title: Text(
                                    recent.resourceTitle,
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: textPrimary),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: orangeAccent.withAlpha(15),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            recent.resourceType,
                                            style: GoogleFonts.inter(
                                              color: orangeAccent,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          Formatters.formatDate(
                                              recent.openedAt),
                                          style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: textSubtitle),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 12,
                                      color: Colors.grey),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PdfViewerScreen(resource: resource),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                          ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- COMPACT QUICK ACCESS GRID ---
  Widget _buildCompactQuickAccessGrid(
    BuildContext context,
    bool isDark,
    Color textPrimary,
    Color textSubtitle,
    Color cardColor,
    Color borderColor,
    Color orangeAccent,
  ) {
    final actions = [
      (
        title: 'Downloads',
        subtitle: 'Offline PDFs',
        icon: Icons.download_rounded,
        color: orangeAccent,
        onTap: () => Navigator.pushNamed(context, AppRoutes.downloads),
      ),
      (
        title: 'Saved',
        subtitle: 'Bookmarks & Notes',
        icon: Icons.bookmark_rounded,
        color: orangeAccent,
        onTap: () => Navigator.pushNamed(context, AppRoutes.bookmarks),
      ),
      (
        title: 'Continue',
        subtitle: 'Resume Reading',
        icon: Icons.history_rounded,
        color: orangeAccent,
        onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
      ),
      (
        title: 'Roadmap',
        subtitle: 'Learning Path',
        icon: Icons.map_rounded,
        color: orangeAccent,
        onTap: () => Navigator.pushNamed(context, AppRoutes.roadmap),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK ACCESS',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: textSubtitle,
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            final crossAxisCount = isWide ? 4 : 2;
            final childAspectRatio =
                isWide ? 3.4 : (constraints.maxWidth < 360 ? 2.3 : 2.8);

            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: childAspectRatio,
              children: actions.map((item) {
                return Material(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: item.onTap,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 20 : 4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: item.color.withAlpha(isDark ? 30 : 15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(item.icon, color: item.color, size: 18),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  item.subtitle,
                                  style: GoogleFonts.inter(
                                    fontSize: 9.5,
                                    color: textSubtitle,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  // --- CAREER & PRACTICAL HUBS GRID ---
  Widget _buildHubsGrid(
    BuildContext context,
    bool isDark,
    Color textPrimary,
    Color textSubtitle,
    Color cardColor,
    Color borderColor,
    Color orangeAccent,
  ) {
    final hubs = [
      (
        title: 'Coding Hub',
        subtitle: 'Languages, DSA, Web/App & DBs',
        icon: Icons.code_rounded,
        route: AppRoutes.codingHub,
      ),
      (
        title: 'Career Hub',
        subtitle: 'Emerging Tech, Portfolio & Resume',
        icon: Icons.rocket_launch_rounded,
        route: AppRoutes.careerHub,
      ),
      (
        title: 'Placement Hub',
        subtitle: 'Aptitude, Tech & HR Interviews',
        icon: Icons.work_history_rounded,
        route: AppRoutes.placementHub,
      ),
      (
        title: 'Project Hub',
        subtitle: 'Mini/Major Projects & Systems',
        icon: Icons.folder_special_rounded,
        route: AppRoutes.projectHub,
      ),
      (
        title: 'Higher Education Hub',
        subtitle: 'GATE, GRE, MS Abroad & Research',
        icon: Icons.school_rounded,
        route: AppRoutes.higherEducationHub,
      ),
      (
        title: 'Entrepreneurship Hub',
        subtitle: 'Idea Validation, MVP & Startups',
        icon: Icons.lightbulb_rounded,
        route: AppRoutes.entrepreneurshipHub,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final crossAxisCount = isWide ? 3 : 2;
        final childAspectRatio =
            isWide ? 1.45 : (constraints.maxWidth < 360 ? 1.02 : 1.10);

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: childAspectRatio,
          children: hubs.map((hub) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pushNamed(context, hub.route);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 20 : 4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: orangeAccent.withAlpha(isDark ? 35 : 18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(hub.icon, color: orangeAccent, size: 26),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: textSubtitle.withAlpha(180),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            hub.title,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            hub.subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              color: textSubtitle,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // --- RECENTLY ADDED FALLBACK ITEMS ---
  Widget _buildRecentFallbackList(
    BuildContext context,
    Color orangeAccent,
    Color cardColor,
    Color borderColor,
    Color textPrimary,
    Color textSubtitle,
  ) {
    final sampleItems = [
      {'title': 'Operating Systems Notes', 'cat': 'Notes', 'time': 'Today'},
      {'title': 'DBMS PYQ', 'cat': 'Question Paper', 'time': 'Yesterday'},
      {
        'title': 'Artificial Intelligence Roadmap',
        'cat': 'Career Hub',
        'time': 'Today'
      },
    ];

    return Column(
      children: sampleItems.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: orangeAccent.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.description_rounded,
                  color: orangeAccent, size: 18),
            ),
            title: Text(item['title'] as String,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: textPrimary)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                runSpacing: 2,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: orangeAccent.withAlpha(15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item['cat'] as String,
                      style: GoogleFonts.inter(
                        color: orangeAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    item['time'] as String,
                    style: GoogleFonts.inter(fontSize: 11, color: textSubtitle),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                size: 12, color: Colors.grey),
          ),
        );
      }).toList(),
    );
  }
}
