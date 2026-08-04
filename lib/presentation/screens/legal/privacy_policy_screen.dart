import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/custom_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Privacy Policy',
        subtitle: 'Data protection and privacy guidelines',
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection(
            theme,
            isDark,
            title: '1. Introduction',
            content:
                'Welcome to CSSE Study Hub. We value your privacy and are committed to protecting your personal data while providing a high-quality academic resource platform for Computer Science & Software Engineering students.',
          ),
          _buildSection(
            theme,
            isDark,
            title: '2. Data We Collect',
            content:
                '• Anonymous Usage Data: Firebase Analytics collects non-personally identifiable metrics (such as resource view frequency and app crash diagnostics via Firebase Crashlytics).\n• User Profile Data: If you create an account, we store your display name and email strictly for bookmark and download synchronization.\n• Local Storage Data: Bookmarks and downloaded PDFs remain cached locally on your device.',
          ),
          _buildSection(
            theme,
            isDark,
            title: '3. How We Use Data',
            content:
                'Data collected is solely utilized to:\n• Sync academic bookmarks and downloads across your sessions.\n• Improve document loading speeds and application stability.\n• Ensure offline availability of your saved study notes.',
          ),
          _buildSection(
            theme,
            isDark,
            title: '4. Third-Party Services',
            content:
                'CSSE Study Hub uses Google Firebase services (Cloud Firestore, Storage, Analytics, and Crashlytics). No personal data is sold or shared with commercial third parties.',
          ),
          _buildSection(
            theme,
            isDark,
            title: '5. Contact Us',
            content:
                'If you have questions regarding this Privacy Policy, please contact our support team at support@cssestudyhub.org.',
          ),
        ],
      ),
    );
  }

  Widget _buildSection(ThemeData theme, bool isDark, {required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
