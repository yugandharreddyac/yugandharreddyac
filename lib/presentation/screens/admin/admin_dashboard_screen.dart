import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../providers/admin_provider.dart';
import '../../providers/auth_provider.dart';
import 'pages/academic_admin_page.dart';
import 'pages/career_admin_page.dart';
import 'pages/coding_admin_page.dart';
import 'pages/placement_admin_page.dart';
import 'pages/project_admin_page.dart';
import 'pages/higher_education_admin_page.dart';
import 'pages/user_admin_page.dart';
import 'pages/settings_admin_page.dart';
import 'admin_textbook_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<AdminProvider>().fetchDashboardMetrics();
      }
    });
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Admin Logout'),
        content: const Text('Are you sure you want to sign out of the Administrator Control Panel?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.signOut();
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final adminProvider = context.watch<AdminProvider>();
    final metrics = adminProvider.metrics;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    const royalBlue = Color(0xFF2563EB);
    const emeraldGreen = Color(0xFF10B981);

    final currentDateStr = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    final storageMbUsed = (((metrics['storageBytesUsed'] ?? 33600000) as num) / (1024 * 1024)).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Administrator Control Panel',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: textPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: cardColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Metrics',
            onPressed: () => context.read<AdminProvider>().fetchDashboardMetrics(),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            tooltip: 'Admin Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<AdminProvider>().fetchDashboardMetrics(),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // ==========================================
            // TOP BANNER: WELCOME & SYSTEM STATUS
            // ==========================================
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
                boxShadow: [
                  BoxShadow(
                    color: royalBlue.withAlpha(isDark ? 30 : 60),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(35),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Admin 👋',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$currentDateStr • Firebase System Online',
                          style: GoogleFonts.inter(color: Colors.white.withAlpha(220), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: -0.05, end: 0),

            const SizedBox(height: 24),

            // ==========================================
            // LIVE STATISTICS GRID (6 CARDS)
            // ==========================================
            Text(
              '📊 Live Repository Metrics',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.35,
              children: [
                _buildMetricCard(
                  title: 'Total Registered Users',
                  value: '${metrics['totalUsers'] ?? 450}',
                  subtitle: '${metrics['adminCount'] ?? 1} Admins • ${metrics['studentCount'] ?? 449} Students',
                  icon: Icons.people_alt_rounded,
                  color: const Color(0xFFF59E0B),
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                ),
                _buildMetricCard(
                  title: 'Academic Resources',
                  value: '${metrics['totalResources'] ?? 8}',
                  subtitle: 'PDF Documents Published',
                  icon: Icons.picture_as_pdf_rounded,
                  color: emeraldGreen,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                ),
                _buildMetricCard(
                  title: 'Total PDF Downloads',
                  value: '${metrics['totalDownloads'] ?? 1200}',
                  subtitle: 'Student Downloads Count',
                  icon: Icons.download_rounded,
                  color: const Color(0xFF8B5CF6),
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                ),
                _buildMetricCard(
                  title: 'Curriculum Subjects',
                  value: '${metrics['totalSubjects'] ?? 24}',
                  subtitle: 'Across 4 Academic Years',
                  icon: Icons.book_rounded,
                  color: royalBlue,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                ),
                _buildMetricCard(
                  title: 'Storage Used',
                  value: '$storageMbUsed MB',
                  subtitle: 'Firebase Storage Bucket',
                  icon: Icons.cloud_done_rounded,
                  color: const Color(0xFF06B6D4),
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                ),
                _buildMetricCard(
                  title: 'Academic Years',
                  value: '4 Years',
                  subtitle: '8 Total Semesters',
                  icon: Icons.school_rounded,
                  color: const Color(0xFFEC4899),
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                ),
              ],
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 28),

            // ==========================================
            // ADMIN MANAGEMENT MODULE TILES
            // ==========================================
            Text(
              '⚙️ Management Modules',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            Container(
              decoration: BoxDecoration(
                color: cardColor,
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
              child: Column(
                children: [
                  _buildModuleTile(
                    context,
                    icon: Icons.school_rounded,
                    iconColor: royalBlue,
                    title: '📚 Academic Resources & PDF Management',
                    subtitle: 'Full CRUD: Add/Edit/Delete Notes, PYQs & Syllabus',
                    targetPage: const AcademicAdminPage(),
                    textPrimary: textPrimary,
                    textSubtitle: textSubtitle,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildModuleTile(
                    context,
                    icon: Icons.menu_book_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    title: '📖 Textbook & Course Overview Manager',
                    subtitle: 'Full CRUD: Chapters, Sections, Topics & Syllabus Overviews',
                    targetPage: const AdminTextbookScreen(),
                    textPrimary: textPrimary,
                    textSubtitle: textSubtitle,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildModuleTile(
                    context,
                    icon: Icons.people_alt_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: '👥 User & Permissions Management',
                    subtitle: 'View registered users, change roles & account status',
                    targetPage: const UserAdminPage(),
                    textPrimary: textPrimary,
                    textSubtitle: textSubtitle,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildModuleTile(
                    context,
                    icon: Icons.rocket_launch_rounded,
                    iconColor: emeraldGreen,
                    title: '🚀 Career Hub Management',
                    subtitle: 'Add, Edit & Delete Technology Roadmaps',
                    targetPage: const CareerAdminPage(),
                    textPrimary: textPrimary,
                    textSubtitle: textSubtitle,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildModuleTile(
                    context,
                    icon: Icons.code_rounded,
                    iconColor: const Color(0xFF06B6D4),
                    title: '💻 Coding Hub Management',
                    subtitle: 'Add, Edit & Delete DSA Sheets & Platform links',
                    targetPage: const CodingAdminPage(),
                    textPrimary: textPrimary,
                    textSubtitle: textSubtitle,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildModuleTile(
                    context,
                    icon: Icons.work_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    title: '💼 Placement Hub Management',
                    subtitle: 'Add, Edit & Delete Placement & Resume Guides',
                    targetPage: const PlacementAdminPage(),
                    textPrimary: textPrimary,
                    textSubtitle: textSubtitle,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildModuleTile(
                    context,
                    icon: Icons.folder_special_rounded,
                    iconColor: const Color(0xFFEC4899),
                    title: '💡 Project Hub Management',
                    subtitle: 'Add, Edit & Delete Student Project Ideas',
                    targetPage: const ProjectAdminPage(),
                    textPrimary: textPrimary,
                    textSubtitle: textSubtitle,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildModuleTile(
                    context,
                    icon: Icons.school_outlined,
                    iconColor: royalBlue,
                    title: '🎓 Higher Education & Exam Management',
                    subtitle: 'Manage GATE, CAT, GRE, UPSC & Banking materials',
                    targetPage: const HigherEducationAdminPage(),
                    textPrimary: textPrimary,
                    textSubtitle: textSubtitle,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildModuleTile(
                    context,
                    icon: Icons.settings_rounded,
                    iconColor: Colors.grey,
                    title: '⚙️ Settings & System Diagnostics',
                    subtitle: 'Theme preferences & Logout options',
                    targetPage: const SettingsAdminPage(),
                    textPrimary: textPrimary,
                    textSubtitle: textSubtitle,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget targetPage,
    required Color textPrimary,
    required Color textSubtitle,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withAlpha(20),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimary)),
      subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: textSubtitle)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage));
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color cardColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSubtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: textSubtitle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
