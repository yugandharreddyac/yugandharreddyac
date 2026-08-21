import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../providers/theme_provider.dart';

class AppDesktopShell extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const AppDesktopShell({
    super.key,
    required this.child,
    this.currentRoute = AppRoutes.home,
  });

  @override
  State<AppDesktopShell> createState() => _AppDesktopShellState();
}

class _AppDesktopShellState extends State<AppDesktopShell> {
  bool _isCollapsed = false;
  bool _isSidebarHidden = false;

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final isDesktop = mediaWidth >= 850;

    if (!isDesktop) {
      return widget.child;
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();

    final sidebarBg =
        isDark ? const Color(0xFF09090B) : const Color(0xFF18181B);
    final sidebarBorder =
        isDark ? const Color(0xFF27272A) : const Color(0xFF3F3F46);
    final sidebarWidth = _isSidebarHidden ? 0.0 : (_isCollapsed ? 72.0 : 250.0);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : const Color(0xFFF4F4F5),
      body: Row(
        children: [
          // Sidebar Container (Optional & Toggleable)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: sidebarWidth,
            child: _isSidebarHidden
                ? const SizedBox.shrink()
                : Container(
                    decoration: BoxDecoration(
                      color: sidebarBg,
                      border: Border(
                        right: BorderSide(color: sidebarBorder, width: 1),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Sidebar Header
                        Container(
                          height: 64,
                          padding: EdgeInsets.symmetric(
                              horizontal: _isCollapsed ? 12 : 18),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.terminal_rounded,
                                    color: Colors.white, size: 20),
                              ),
                              if (!_isCollapsed) ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppConstants.appName,
                                        style: GoogleFonts.outfit(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: -0.3,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'CS Learning Platform',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: Colors.white60,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFF27272A)),

                        // Navigation Items
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            children: [
                              _buildSidebarItem(
                                icon: Icons.grid_view_rounded,
                                label: 'Home',
                                route: AppRoutes.home,
                              ),
                              _buildSidebarItem(
                                icon: Icons.school_rounded,
                                label: 'Academic Curriculum',
                                route: AppRoutes.years,
                              ),
                              _buildSidebarItem(
                                icon: Icons.code_rounded,
                                label: 'Coding Hub',
                                route: AppRoutes.codingHub,
                              ),
                              _buildSidebarItem(
                                icon: Icons.rocket_launch_rounded,
                                label: 'Career Hub',
                                route: AppRoutes.careerHub,
                              ),
                              _buildSidebarItem(
                                icon: Icons.work_history_rounded,
                                label: 'Placement Hub',
                                route: AppRoutes.placementHub,
                              ),
                              _buildSidebarItem(
                                icon: Icons.folder_special_rounded,
                                label: 'Project Hub',
                                route: AppRoutes.projectHub,
                              ),
                              _buildSidebarItem(
                                icon: Icons.auto_graph_rounded,
                                label: 'Roadmap',
                                route: AppRoutes.roadmap,
                              ),
                              _buildSidebarItem(
                                icon: Icons.auto_awesome_rounded,
                                label: 'UniDocs AI',
                                route: AppRoutes.ai,
                              ),
                              _buildSidebarItem(
                                icon: Icons.bookmark_rounded,
                                label: 'Saved Resources',
                                route: AppRoutes.bookmarks,
                              ),
                              _buildSidebarItem(
                                icon: Icons.download_rounded,
                                label: 'Offline Downloads',
                                route: AppRoutes.downloads,
                              ),
                              _buildSidebarItem(
                                icon: Icons.person_rounded,
                                label: 'Profile & Activity',
                                route: AppRoutes.profile,
                              ),
                            ],
                          ),
                        ),

                        // Collapse Toggle
                        const Divider(height: 1, color: Color(0xFF27272A)),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isCollapsed = !_isCollapsed;
                            });
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: _isCollapsed
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.start,
                              children: [
                                Icon(
                                  _isCollapsed
                                      ? Icons.chevron_right_rounded
                                      : Icons.chevron_left_rounded,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                                if (!_isCollapsed) ...[
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Text(
                                      'Collapse Sidebar',
                                      style: GoogleFonts.inter(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          // Main Page Content Area
          Expanded(
            child: Column(
              children: [
                // Top Header Bar
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? AppColors.borderDark
                            : const Color(0xFFE4E4E7),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Sidebar Optional Toggle Button
                      IconButton(
                        icon: Icon(
                          _isSidebarHidden
                              ? Icons.menu_rounded
                              : Icons.menu_open_rounded,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          size: 22,
                        ),
                        tooltip:
                            _isSidebarHidden ? 'Show Sidebar' : 'Hide Sidebar',
                        onPressed: () {
                          setState(() {
                            _isSidebarHidden = !_isSidebarHidden;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Computer Science Learning Workspace',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Search Trigger
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.search),
                        child: Container(
                          width: 280,
                          height: 38,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF09090B)
                                : const Color(0xFFF4F4F5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.borderDark
                                  : const Color(0xFFE4E4E7),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search_rounded,
                                  color: AppColors.primary, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Search subjects, notes, PYQs...',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF27272A)
                                      : const Color(0xFFE4E4E7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Ctrl+K',
                                  style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          color: themeProvider.isDarkMode
                              ? Colors.amberAccent
                              : AppColors.textPrimaryLight,
                          size: 20,
                        ),
                        tooltip: 'Toggle Theme',
                        onPressed: () => themeProvider.toggleTheme(),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.profile),
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.person_rounded,
                              size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                // Wrapped Content View with Max-Width Desktop Framing
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1360),
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String label,
    required String route,
  }) {
    final isSelected = widget.currentRoute == route;
    const primaryColor = AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isSelected ? primaryColor.withAlpha(40) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            if (widget.currentRoute != route) {
              Navigator.pushReplacementNamed(context, route);
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 44,
            padding: EdgeInsets.symmetric(horizontal: _isCollapsed ? 14 : 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(color: primaryColor.withAlpha(120), width: 1)
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? primaryColor : Colors.white70,
                  size: 20,
                ),
                if (!_isCollapsed) ...[
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
