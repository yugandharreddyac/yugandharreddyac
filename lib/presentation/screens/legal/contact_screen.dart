import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/custom_app_bar.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Support & Feedback',
        subtitle: 'Get help, report issues, or suggest new notes',
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
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
                  '📬 Contact Student Support',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Have feedback or need to request additional study materials for your semester? Reach out directly via email.',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    final Uri emailUri = Uri.parse(
                        'mailto:support@cssestudyhub.org?subject=CSSE%20Study%20Hub%20Support');
                    if (await canLaunchUrl(emailUri)) {
                      await launchUrl(emailUri,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Email Support Team'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Frequently Asked Questions (FAQ)',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _faqTile(
            theme,
            isDark,
            question: 'How do offline downloads work?',
            answer:
                'Downloaded PDFs are saved directly to your device storage. You can view them anytime under the Download Manager tab without needing an active internet connection.',
          ),
          _faqTile(
            theme,
            isDark,
            question: 'Are there any fees to access study notes?',
            answer:
                'No, CSSE Study Hub is completely free and accessible for Computer Science and Software Engineering students.',
          ),
          _faqTile(
            theme,
            isDark,
            question: 'How can I contribute study materials?',
            answer:
                'Contact our academic team via the Email Support button above with your notes or syllabus documents.',
          ),
        ],
      ),
    );
  }

  Widget _faqTile(ThemeData theme, bool isDark,
      {required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            answer,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
