import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/theme_provider.dart';

class SettingsAdminPage extends StatelessWidget {
  const SettingsAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    const royalBlue = Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          '⚙ Admin Settings',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20, color: textPrimary),
        ),
        backgroundColor: cardColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: royalBlue.withAlpha(20), shape: BoxShape.circle),
                    child: Icon(
                      themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: themeProvider.isDarkMode ? Colors.amberAccent : royalBlue,
                      size: 20,
                    ),
                  ),
                  title: Text('Theme Preferences', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimary)),
                  subtitle: Text(themeProvider.isDarkMode ? 'Dark Mode Active' : 'Light Mode Active', style: GoogleFonts.inter(fontSize: 12, color: textSubtitle)),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    activeColor: royalBlue,
                    onChanged: (_) => themeProvider.toggleTheme(),
                  ),
                ),
                Divider(height: 1, color: borderColor),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFF10B981).withAlpha(20), shape: BoxShape.circle),
                    child: const Icon(Icons.info_outline_rounded, color: Color(0xFF10B981), size: 20),
                  ),
                  title: Text('Application Version', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimary)),
                  subtitle: Text('${AppConstants.appName} v${AppConstants.appVersion}', style: GoogleFonts.inter(fontSize: 12, color: textSubtitle)),
                ),
                Divider(height: 1, color: borderColor),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.red.withAlpha(20), shape: BoxShape.circle),
                    child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                  ),
                  title: Text('Admin Logout', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent)),
                  subtitle: Text('Sign out of Administrator Session', style: GoogleFonts.inter(fontSize: 12, color: textSubtitle)),
                  onTap: () {
                    authProvider.signOut();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
