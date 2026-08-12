import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/higher_education_model.dart';
import '../../widgets/custom_app_bar.dart';

class HigherEdDetailScreen extends StatefulWidget {
  final HigherEducationModel item;

  const HigherEdDetailScreen({super.key, required this.item});

  @override
  State<HigherEdDetailScreen> createState() => _HigherEdDetailScreenState();
}

class _HigherEdDetailScreenState extends State<HigherEdDetailScreen> {
  final Map<int, bool> _expandedFaqs = {};

  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final item = widget.item;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final textSecondary = isDark ? AppColors.textSecondaryDark : const Color(0xFF475569);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: CustomAppBar(
          title: item.title,
          subtitle: '${item.category} • Guide',
        ),
        body: Column(
          children: [
            // Header Banner Card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withAlpha(60),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.category,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                      const Spacer(),
                      if (item.salaryRange.isNotEmpty)
                        Chip(
                          label: Text(item.salaryRange, style: const TextStyle(fontSize: 10.5, color: Colors.white, fontWeight: FontWeight.bold)),
                          backgroundColor: Colors.white.withAlpha(20),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  if (item.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(item.subtitle, style: TextStyle(color: Colors.indigo.shade100, fontSize: 12)),
                  ],
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.05, end: 0),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: TabBar(
                isScrollable: true,
                indicator: BoxDecoration(
                  color: const Color(0xFF4F46E5),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                tabs: const [
                  Tab(text: '📌 Overview & Eligibility'),
                  Tab(text: '📊 Syllabus & Books'),
                  Tab(text: '🗺️ Roadmap'),
                  Tab(text: '📜 Application & SOP'),
                  Tab(text: '🌐 Official Sources'),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                children: [
                  _buildOverviewTab(context, item, cardBg, borderColor, textPrimary, textSecondary, isDark),
                  _buildSyllabusBooksTab(context, item, cardBg, borderColor, textPrimary, textSecondary, isDark),
                  _buildRoadmapTab(context, item, cardBg, borderColor, textPrimary, textSecondary, isDark),
                  _buildApplicationTab(context, item, cardBg, borderColor, textPrimary, textSecondary, isDark),
                  _buildOfficialSourcesTab(context, item, cardBg, borderColor, textPrimary, textSecondary, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, HigherEducationModel item, Color cardBg, Color borderColor, Color textPrimary, Color textSecondary, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Overview & Scope', Icons.description_rounded),
        const SizedBox(height: 8),
        _buildCard(cardBg, borderColor, child: Text(item.overview, style: TextStyle(color: textPrimary, fontSize: 13.5, height: 1.45))),

        const SizedBox(height: 18),
        _buildSectionHeader('Eligibility Criteria', Icons.how_to_reg_rounded),
        const SizedBox(height: 8),
        _buildCard(cardBg, borderColor, child: Text(item.eligibilityCriteria, style: TextStyle(color: textSecondary, fontSize: 13, height: 1.4))),

        if (item.whoShouldApply.isNotEmpty) ...[
          const SizedBox(height: 18),
          _buildSectionHeader('Target Audience / Who Should Apply', Icons.groups_rounded),
          const SizedBox(height: 8),
          _buildCard(cardBg, borderColor, child: Text(item.whoShouldApply, style: TextStyle(color: textPrimary, fontSize: 13, height: 1.4))),
        ],

        if (item.careerOpportunities.isNotEmpty) ...[
          const SizedBox(height: 18),
          _buildSectionHeader('Career Opportunities & Scope', Icons.trending_up_rounded),
          const SizedBox(height: 8),
          _buildCard(cardBg, borderColor, child: Text(item.careerOpportunities, style: TextStyle(color: textSecondary, fontSize: 13, height: 1.4))),
        ],
      ],
    );
  }

  Widget _buildSyllabusBooksTab(BuildContext context, HigherEducationModel item, Color cardBg, Color borderColor, Color textPrimary, Color textSecondary, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (item.examPattern.isNotEmpty) ...[
          _buildSectionHeader('Exam Pattern & Marking Scheme', Icons.assignment_rounded),
          const SizedBox(height: 8),
          _buildCard(cardBg, borderColor, child: Text(item.examPattern, style: TextStyle(color: textPrimary, fontSize: 13, height: 1.4))),
          const SizedBox(height: 18),
        ],

        _buildSectionHeader('Syllabus & Core Topics', Icons.menu_book_rounded),
        const SizedBox(height: 8),
        ...item.syllabusTopics.map((top) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF4F46E5), size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Text(top, style: TextStyle(fontSize: 12.5, color: textPrimary, fontWeight: FontWeight.w600))),
                ],
              ),
            )),

        if (item.recommendedBooks.isNotEmpty) ...[
          const SizedBox(height: 18),
          _buildSectionHeader('Recommended Reference Textbooks', Icons.library_books_rounded),
          const SizedBox(height: 8),
          ...item.recommendedBooks.map((bk) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('• $bk', style: TextStyle(fontSize: 12.5, color: textSecondary)),
              )),
        ],
      ],
    );
  }

  Widget _buildRoadmapTab(BuildContext context, HigherEducationModel item, Color cardBg, Color borderColor, Color textPrimary, Color textSecondary, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Phased Preparation Timeline', Icons.timeline_rounded),
        const SizedBox(height: 10),
        ...item.preparationTimeline.asMap().entries.map((entry) {
          final idx = entry.key + 1;
          final step = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                CircleAvatar(radius: 12, backgroundColor: const Color(0xFF4F46E5), child: Text('$idx', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
                const SizedBox(width: 12),
                Expanded(child: Text(step, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5, color: textPrimary))),
              ],
            ),
          );
        }),

        if (item.successStrategy.isNotEmpty) ...[
          const SizedBox(height: 18),
          _buildSectionHeader('Expert Success Strategy', Icons.stars_rounded),
          const SizedBox(height: 8),
          _buildCard(cardBg, borderColor, child: Text(item.successStrategy, style: TextStyle(color: textPrimary, fontSize: 13, height: 1.4))),
        ],
      ],
    );
  }

  Widget _buildApplicationTab(BuildContext context, HigherEducationModel item, Color cardBg, Color borderColor, Color textPrimary, Color textSecondary, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Application Process & Guidelines', Icons.app_registration_rounded),
        const SizedBox(height: 8),
        _buildCard(cardBg, borderColor, child: Text(item.applicationProcess, style: TextStyle(color: textPrimary, fontSize: 13, height: 1.4))),

        if (item.topInstitutes.isNotEmpty) ...[
          const SizedBox(height: 18),
          _buildSectionHeader('Top Premier Institutes & Colleges', Icons.domain_rounded),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: item.topInstitutes.map((inst) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withAlpha(20),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF4F46E5).withAlpha(40)),
                ),
                child: Text(inst, style: const TextStyle(color: Color(0xFF4F46E5), fontSize: 12, fontWeight: FontWeight.bold)),
              );
            }).toList(),
          ),
        ],

        if (item.scholarships.isNotEmpty) ...[
          const SizedBox(height: 18),
          _buildSectionHeader('Available Scholarships & Stipends', Icons.payments_rounded),
          const SizedBox(height: 8),
          ...item.scholarships.map((sch) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.attach_money_rounded, color: Colors.green, size: 16),
                    const SizedBox(width: 6),
                    Expanded(child: Text(sch, style: TextStyle(fontSize: 12.5, color: textPrimary, fontWeight: FontWeight.w600))),
                  ],
                ),
              )),
        ],
      ],
    );
  }

  Widget _buildOfficialSourcesTab(BuildContext context, HigherEducationModel item, Color cardBg, Color borderColor, Color textPrimary, Color textSecondary, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Verified Official Websites', Icons.verified_user_rounded),
        const SizedBox(height: 10),
        ...item.officialWebsites.map((url) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFF4F46E5), radius: 14, child: Icon(Icons.public_rounded, size: 14, color: Colors.white)),
              title: Text('Official Portal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
              subtitle: Text(url, style: TextStyle(fontSize: 11, color: textSecondary)),
              onTap: () => _launchUrl(url),
            ),
          );
        }),

        if (item.latestNotifications.isNotEmpty) ...[
          const SizedBox(height: 18),
          _buildSectionHeader('Official Notifications & Schedule', Icons.notifications_active_rounded),
          const SizedBox(height: 10),
          ...item.latestNotifications.map((notif) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notif.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: textPrimary)),
                        const SizedBox(height: 2),
                        Text('Date: ${notif.date}', style: TextStyle(fontSize: 11, color: textSecondary)),
                      ],
                    ),
                  ),
                  if (notif.url.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.open_in_new_rounded, size: 16, color: Color(0xFF4F46E5)),
                      onPressed: () => _launchUrl(notif.url),
                    ),
                ],
              ),
            );
          }),
        ],

        if (item.faqs.isNotEmpty) ...[
          const SizedBox(height: 18),
          _buildSectionHeader('Frequently Asked Questions (FAQs)', Icons.quiz_rounded),
          const SizedBox(height: 10),
          ...item.faqs.asMap().entries.map((entry) {
            final idx = entry.key;
            final faq = entry.value;
            final isExpanded = _expandedFaqs[idx] ?? true;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        _expandedFaqs[idx] = !isExpanded;
                      });
                    },
                    title: Text(faq.question, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
                    trailing: Icon(isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: textSecondary),
                  ),
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Text(faq.answer, style: TextStyle(fontSize: 12, color: textSecondary, height: 1.35)),
                    ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4F46E5), size: 18),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildCard(Color cardBg, Color borderColor, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}
