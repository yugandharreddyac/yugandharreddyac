import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/higher_education_model.dart';
import '../../providers/higher_education_provider.dart';
import '../../widgets/custom_app_bar.dart';

class ExamDetailScreen extends StatelessWidget {
  final HigherEducationModel exam;

  const ExamDetailScreen({super.key, required this.exam});

  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<HigherEducationProvider>();
    final isSaved = provider.isSaved(exam.id);

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    const royalBlue = Color(0xFF2563EB);
    const emeraldGreen = Color(0xFF10B981);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar(
        title: exam.title,
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isSaved ? royalBlue : Colors.grey,
            ),
            onPressed: () => provider.toggleSave(exam.id),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Header Banner
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [royalBlue, const Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    exam.category.toUpperCase(),
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  exam.title,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  exam.subtitle,
                  style: GoogleFonts.inter(color: Colors.white.withAlpha(220), fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 1. Overview & Eligibility
          _buildCard(
            cardColor: cardColor,
            borderColor: borderColor,
            title: '📖 Overview & Eligibility Criteria',
            textPrimary: textPrimary,
            children: [
              Text(exam.overview, style: GoogleFonts.inter(fontSize: 14, color: textSubtitle, height: 1.5)),
              const SizedBox(height: 14),
              _buildSubHeading('Eligibility Criteria', textPrimary),
              const SizedBox(height: 4),
              Text(exam.eligibilityCriteria, style: GoogleFonts.inter(fontSize: 13, color: textSubtitle)),
              const SizedBox(height: 14),
              _buildSubHeading('Who Should Apply', textPrimary),
              const SizedBox(height: 4),
              Text(exam.whoShouldApply, style: GoogleFonts.inter(fontSize: 13, color: textSubtitle)),
            ],
          ),

          const SizedBox(height: 20),

          // 2. Exam Pattern & Syllabus
          _buildCard(
            cardColor: cardColor,
            borderColor: borderColor,
            title: '📝 Exam Pattern & Detailed Syllabus',
            textPrimary: textPrimary,
            children: [
              _buildSubHeading('Exam Pattern', textPrimary),
              const SizedBox(height: 4),
              Text(exam.examPattern, style: GoogleFonts.inter(fontSize: 13, color: textSubtitle)),
              const SizedBox(height: 14),
              _buildSubHeading('Syllabus Core Modules', textPrimary),
              const SizedBox(height: 8),
              ...exam.syllabusTopics.map((topic) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, color: emeraldGreen, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(topic, style: GoogleFonts.inter(fontSize: 13, color: textSubtitle))),
                      ],
                    ),
                  )),
            ],
          ),

          const SizedBox(height: 20),

          // 3. Preparation Timeline & Roadmap
          _buildCard(
            cardColor: cardColor,
            borderColor: borderColor,
            title: '🗓️ Preparation Timeline & Strategy',
            textPrimary: textPrimary,
            children: [
              ...exam.preparationTimeline.map((step) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Text(step, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary)),
                    ),
                  )),
              const SizedBox(height: 12),
              _buildSubHeading('Success Strategy', textPrimary),
              const SizedBox(height: 4),
              Text(exam.successStrategy, style: GoogleFonts.inter(fontSize: 13, color: textSubtitle)),
            ],
          ),

          const SizedBox(height: 20),

          // 4. Recommended Books & Resources
          _buildCard(
            cardColor: cardColor,
            borderColor: borderColor,
            title: '📚 Recommended Standard Books',
            textPrimary: textPrimary,
            children: [
              ...exam.recommendedBooks.map((book) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.menu_book_rounded, color: royalBlue, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(book, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary))),
                      ],
                    ),
                  )),
            ],
          ),

          const SizedBox(height: 20),

          // 5. YouTube Channels & Official Websites
          _buildCard(
            cardColor: cardColor,
            borderColor: borderColor,
            title: '🌐 Free Online Resources & Websites',
            textPrimary: textPrimary,
            children: [
              _buildSubHeading('Top Recommended YouTube Channels', textPrimary),
              const SizedBox(height: 6),
              ...exam.youtubeChannels.map((ch) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.play_circle_fill_rounded, color: Colors.redAccent, size: 18),
                        const SizedBox(width: 8),
                        Text(ch, style: GoogleFonts.inter(fontSize: 13, color: textSubtitle)),
                      ],
                    ),
                  )),
              const SizedBox(height: 14),
              _buildSubHeading('Official Websites & Portals', textPrimary),
              const SizedBox(height: 8),
              ...exam.officialWebsites.map((url) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.language_rounded, color: royalBlue, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            url,
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: royalBlue),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => _launchUrl(url),
                          icon: const Icon(Icons.open_in_new_rounded, size: 14),
                          label: const Text('Open Official Website', style: TextStyle(fontSize: 11)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: royalBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),

          const SizedBox(height: 20),

          // 6. Career Opportunities & Salary
          _buildCard(
            cardColor: cardColor,
            borderColor: borderColor,
            title: '💼 Career Scope, Salary & Institutes',
            textPrimary: textPrimary,
            children: [
              _buildSubHeading('Expected Salary Range', textPrimary),
              const SizedBox(height: 4),
              Text(exam.salaryRange, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: emeraldGreen)),
              const SizedBox(height: 14),
              _buildSubHeading('Career Opportunities', textPrimary),
              const SizedBox(height: 4),
              Text(exam.careerOpportunities, style: GoogleFonts.inter(fontSize: 13, color: textSubtitle)),
              if (exam.topInstitutes.isNotEmpty) ...[
                const SizedBox(height: 14),
                _buildSubHeading('Top Participating Institutes / Universities', textPrimary),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: exam.topInstitutes.map((inst) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: royalBlue.withAlpha(20), borderRadius: BorderRadius.circular(8)),
                        child: Text(inst, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: royalBlue)),
                      )).toList(),
                ),
              ],
            ],
          ),

          const SizedBox(height: 20),

          // 7. Latest Notifications & FAQs
          _buildCard(
            cardColor: cardColor,
            borderColor: borderColor,
            title: '🔔 Notifications & FAQs',
            textPrimary: textPrimary,
            children: [
              if (exam.latestNotifications.isNotEmpty) ...[
                _buildSubHeading('Latest Notifications', textPrimary),
                const SizedBox(height: 6),
                ...exam.latestNotifications.map((notif) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.notifications_active_rounded, color: Colors.orangeAccent, size: 20),
                      title: Text(notif.title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary)),
                      subtitle: Text('Date: ${notif.date}', style: GoogleFonts.inter(fontSize: 11, color: textSubtitle)),
                      trailing: const Icon(Icons.open_in_new_rounded, size: 16, color: royalBlue),
                      onTap: () => _launchUrl(notif.url),
                    )),
                const SizedBox(height: 14),
              ],
              _buildSubHeading('Frequently Asked Questions', textPrimary),
              const SizedBox(height: 6),
              ...exam.faqs.map((faq) => ExpansionTile(
                    title: Text(faq.question, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(faq.answer, style: GoogleFonts.inter(fontSize: 13, color: textSubtitle)),
                      ),
                    ],
                  )),
            ],
          ),

          const SizedBox(height: 30),

          // Action Button: Download Syllabus & Guide
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${exam.title} Preparation Guide downloaded for offline reading!')),
                );
              },
              icon: const Icon(Icons.download_rounded, size: 20),
              label: Text('Download Complete Syllabus PDF ➔', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildCard({
    required Color cardColor,
    required Color borderColor,
    required String title,
    required Color textPrimary,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSubHeading(String text, Color textPrimary) {
    return Text(text, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary));
  }
}
