import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class ProjectAdminPage extends StatelessWidget {
  const ProjectAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    const pinkColor = Color(0xFFEC4899);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          '💡 Project Hub Management',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20, color: textPrimary),
        ),
        backgroundColor: cardColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Academic Projects Repositories Control',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Add mini/major projects, update setup guides & GitHub links.',
                  style: GoogleFonts.inter(fontSize: 13, color: textSubtitle),
                ),
                const SizedBox(height: 20),
                _buildActionTile(
                  context,
                  icon: Icons.create_new_folder_rounded,
                  title: 'Add Project',
                  subtitle: 'Create a new mini or major academic project entry',
                  color: pinkColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                ),
                const SizedBox(height: 12),
                _buildActionTile(
                  context,
                  icon: Icons.folder_zip_rounded,
                  title: 'Edit Project',
                  subtitle: 'Update tech stack, architecture or repo link',
                  color: pinkColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                ),
                const SizedBox(height: 12),
                _buildActionTile(
                  context,
                  icon: Icons.folder_delete_rounded,
                  title: 'Delete Project',
                  subtitle: 'Remove project entry from Firestore',
                  color: Colors.redAccent,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color borderColor,
    required Color textPrimary,
    required Color textSubtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withAlpha(20), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimary)),
        subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: textSubtitle)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title functionality ready for Firestore sync.')),
          );
        },
      ),
    );
  }
}
