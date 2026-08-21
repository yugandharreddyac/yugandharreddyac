import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/placement_model.dart';
import '../../widgets/custom_app_bar.dart';

class PlacementDetailScreen extends StatefulWidget {
  final PlacementModel placement;

  const PlacementDetailScreen({super.key, required this.placement});

  @override
  State<PlacementDetailScreen> createState() => _PlacementDetailScreenState();
}

class _PlacementDetailScreenState extends State<PlacementDetailScreen> {
  final Map<int, bool> _expandedAnswers = {};

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
    final placement = widget.placement;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : const Color(0xFF475569);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: CustomAppBar(
          title: placement.title,
          subtitle: '${placement.category} • Placement Guide',
        ),
        body: Column(
          children: [
            // Top Header Card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF059669), Color(0xFF10B981)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withAlpha(60),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.work_history_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          placement.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(40),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            placement.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  color: const Color(0xFF059669),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: textSecondary,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                tabs: const [
                  Tab(text: '💡 Learn & Principles'),
                  Tab(text: '📝 Preparation Strategy'),
                  Tab(text: '🗣️ Interview Q&A'),
                  Tab(text: '⚡ Expert Tips'),
                  Tab(text: '🌐 Verified Links'),
                ],
              ),
            ),

            // Tab View
            Expanded(
              child: TabBarView(
                children: [
                  _buildOverviewTab(context, placement, cardBg, borderColor,
                      textPrimary, textSecondary, isDark),
                  _buildRoadmapTab(context, placement, cardBg, borderColor,
                      textPrimary, textSecondary, isDark),
                  _buildInterviewQaTab(context, placement, cardBg, borderColor,
                      textPrimary, textSecondary, isDark),
                  _buildTipsTab(context, placement, cardBg, borderColor,
                      textPrimary, textSecondary, isDark),
                  _buildResourcesTab(context, placement, cardBg, borderColor,
                      textPrimary, textSecondary, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(
      BuildContext context,
      PlacementModel placement,
      Color cardBg,
      Color borderColor,
      Color textPrimary,
      Color textSecondary,
      bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
            'Module Overview & Objectives', Icons.info_outline_rounded),
        const SizedBox(height: 8),
        _buildCard(cardBg, borderColor,
            child: Text(placement.description,
                style: TextStyle(
                    color: textPrimary, fontSize: 13.5, height: 1.45))),
      ],
    );
  }

  Widget _buildRoadmapTab(
      BuildContext context,
      PlacementModel placement,
      Color cardBg,
      Color borderColor,
      Color textPrimary,
      Color textSecondary,
      bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
            'Preparation Roadmap & Timeline', Icons.map_rounded),
        const SizedBox(height: 8),
        _buildCard(cardBg, borderColor,
            child: Text(
                placement.roadmap.isNotEmpty
                    ? placement.roadmap
                    : 'Follow structured practice daily for 4-6 weeks.',
                style:
                    TextStyle(color: textPrimary, fontSize: 13, height: 1.45))),
      ],
    );
  }

  Widget _buildInterviewQaTab(
      BuildContext context,
      PlacementModel placement,
      Color cardBg,
      Color borderColor,
      Color textPrimary,
      Color textSecondary,
      bool isDark) {
    if (placement.questionsAndAnswers.isEmpty) {
      return const Center(child: Text('No Q&A items available.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: placement.questionsAndAnswers.length,
      itemBuilder: (context, index) {
        final qa = placement.questionsAndAnswers[index];
        final isExpanded = _expandedAnswers[index] ?? true;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () {
                  setState(() {
                    _expandedAnswers[index] = !isExpanded;
                  });
                },
                leading: CircleAvatar(
                  radius: 12,
                  backgroundColor: const Color(0xFF059669),
                  child: Text('${index + 1}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ),
                title: Text(qa.question,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: textPrimary)),
                trailing: Icon(
                    isExpanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: textSecondary),
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      Text(qa.answer,
                          style: TextStyle(
                              fontSize: 12.5,
                              color: textSecondary,
                              height: 1.4)),
                      if (qa.keyPoints.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text('Key Takeaways:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Color(0xFF059669))),
                        const SizedBox(height: 4),
                        ...qa.keyPoints.map((kp) => Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text('• $kp',
                                  style: TextStyle(
                                      fontSize: 12, color: textPrimary)),
                            )),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTipsTab(
      BuildContext context,
      PlacementModel placement,
      Color cardBg,
      Color borderColor,
      Color textPrimary,
      Color textSecondary,
      bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
            'Pro Tips for Placement Success', Icons.lightbulb_rounded),
        const SizedBox(height: 8),
        ...placement.tips.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Colors.amber, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(tip,
                            style: TextStyle(
                                fontSize: 12.5,
                                color: textPrimary,
                                height: 1.35))),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildResourcesTab(
      BuildContext context,
      PlacementModel placement,
      Color cardBg,
      Color borderColor,
      Color textPrimary,
      Color textSecondary,
      bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
            'Verified Practice Platforms & Links', Icons.verified_rounded),
        const SizedBox(height: 10),
        ...placement.resourceUrls.map((url) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                  backgroundColor: Color(0xFF059669),
                  radius: 14,
                  child: Icon(Icons.open_in_new_rounded,
                      size: 14, color: Colors.white)),
              title: Text('Practice Platform Link',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: textPrimary)),
              subtitle: Text(url,
                  style: TextStyle(fontSize: 11, color: textSecondary)),
              onTap: () => _launchUrl(url),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF059669), size: 18),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
