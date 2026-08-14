import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const energeticOrange = AppColors.primary;

    return Drawer(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFFAFAFA),
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF18181B) : const Color(0xFF09090B),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: energeticOrange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.terminal_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppConstants.appName,
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              'CS Learning Platform',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: energeticOrange.withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: energeticOrange.withAlpha(80)),
                    ),
                    child: Text(
                      '🎓 Computer Science Learning Hub',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Menu Options
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildSectionHeader(context, 'LEARN'),
                  _buildDrawerTile(
                    context: context,
                    icon: Icons.school_rounded,
                    title: 'Academic Curriculum Overview',
                    subtitle: 'View All 4 Academic Years (1st - 4th Year)',
                    color: energeticOrange,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
                    },
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: Icons.filter_1_rounded,
                    title: '1st Year Academic',
                    subtitle: 'Engineering Maths, C, Physics, Chemistry',
                    color: energeticOrange,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.semesters, arguments: {
                        'yearId': 'year_1',
                        'yearTitle': '1st Year',
                      });
                    },
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: Icons.filter_2_rounded,
                    title: '2nd Year Academic',
                    subtitle: 'Data Structures, OOP Java, OS, DBMS',
                    color: energeticOrange,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.semesters, arguments: {
                        'yearId': 'year_2',
                        'yearTitle': '2nd Year',
                      });
                    },
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: Icons.filter_3_rounded,
                    title: '3rd Year Academic',
                    subtitle: 'Algorithms, Web Dev, Computer Networks',
                    color: energeticOrange,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.semesters, arguments: {
                        'yearId': 'year_3',
                        'yearTitle': '3rd Year',
                      });
                    },
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: Icons.filter_4_rounded,
                    title: '4th Year Academic',
                    subtitle: 'Cloud, Distributed Systems, Capstone Project',
                    color: energeticOrange,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.semesters, arguments: {
                        'yearId': 'year_4',
                        'yearTitle': '4th Year',
                      });
                    },
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Divider(height: 1),
                  ),

                  _buildSectionHeader(context, 'CAREER & PRACTICAL HUBS'),
                  _buildDrawerTile(
                    context: context,
                    icon: Icons.code_rounded,
                    title: 'Coding Hub',
                    subtitle: 'Languages, DSA, Web/App & DBs',
                    color: energeticOrange,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.codingHub);
                    },
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: Icons.rocket_launch_rounded,
                    title: 'Career Hub',
                    subtitle: 'Emerging Tech, Portfolio & Resume Prep',
                    color: energeticOrange,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.careerHub);
                    },
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: Icons.work_history_rounded,
                    title: 'Placement Hub',
                    subtitle: 'Aptitude, Reasoning, Technical & HR',
                    color: energeticOrange,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.placementHub);
                    },
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: Icons.folder_special_rounded,
                    title: 'Project Hub',
                    subtitle: 'Mini & Major Projects, Blueprints',
                    color: energeticOrange,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.projectHub);
                    },
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: Icons.school_rounded,
                    title: 'Higher Education Hub',
                    subtitle: 'GATE, GRE, MS Abroad & Research',
                    color: energeticOrange,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.higherEducationHub);
                    },
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: Icons.lightbulb_rounded,
                    title: 'Entrepreneurship Hub',
                    subtitle: 'Problem Discovery, MVP & Startups',
                    color: energeticOrange,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.entrepreneurshipHub);
                    },
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Divider(height: 1),
                  ),

                  _buildSectionHeader(context, 'LIBRARY & ACCOUNT'),
                  _buildDrawerTile(
                    context: context,
                    icon: Icons.bookmark_rounded,
                    title: 'Saved Resources',
                    subtitle: 'Bookmarked notes and syllabus',
                    color: energeticOrange,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.bookmarks);
                    },
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: Icons.download_rounded,
                    title: 'Offline Downloads',
                    subtitle: 'Saved PDFs for offline viewing',
                    color: energeticOrange,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.downloads);
                    },
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: Icons.person_rounded,
                    title: 'Profile & Settings',
                    subtitle: 'User account preferences',
                    color: energeticOrange,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.profile);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF71717A),
        ),
      ),
    );
  }

  Widget _buildDrawerTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withAlpha(isDark ? 30 : 15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF09090B),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 11,
          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF71717A),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF71717A)),
      onTap: onTap,
    );
  }
}
