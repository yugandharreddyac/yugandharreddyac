import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/higher_education_model.dart';
import '../../providers/higher_education_provider.dart';
import '../../widgets/custom_app_bar.dart';
import 'higher_ed_detail_screen.dart';

class OfficialPortalItem {
  final String title;
  final String description;
  final String category;
  final String url;
  final IconData icon;

  const OfficialPortalItem({
    required this.title,
    required this.description,
    required this.category,
    required this.url,
    required this.icon,
  });
}

class HigherEducationHubScreen extends StatefulWidget {
  const HigherEducationHubScreen({super.key});

  @override
  State<HigherEducationHubScreen> createState() =>
      _HigherEducationHubScreenState();
}

class _HigherEducationHubScreenState extends State<HigherEducationHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  static const List<OfficialPortalItem> _officialPortals = [
    OfficialPortalItem(
      title: 'GATE 2025 (IIT Roorkee)',
      description:
          'Official GATE 2025 website (IIT Roorkee) for GOAPS registration, syllabus & admit card download.',
      category: 'GATE 2025',
      url: 'https://gate2025.iitr.ac.in',
      icon: Icons.school_rounded,
    ),
    OfficialPortalItem(
      title: 'COAP Portal (IIT M.Tech Admission)',
      description:
          'Common Offer Acceptance Portal for checking & accepting M.Tech admission offers in all IITs.',
      category: 'Counselling',
      url: 'https://coap.iitk.ac.in',
      icon: Icons.domain_rounded,
    ),
    OfficialPortalItem(
      title: 'CCMT Counselling (NIT / IIIT M.Tech)',
      description:
          'Centralized Counselling for M.Tech/M.Arch/M.Plan admissions in NITs, IIITs & CFTIs.',
      category: 'Counselling',
      url: 'https://ccmt.admissions.nic.in',
      icon: Icons.account_balance_rounded,
    ),
    OfficialPortalItem(
      title: 'NPTEL Official IIT Online Courses',
      description:
          'Free online video lectures & courseware by 7 IITs & IISc for GATE CSSE preparation.',
      category: 'Learning Portal',
      url: 'https://nptel.ac.in',
      icon: Icons.play_circle_fill_rounded,
    ),
    OfficialPortalItem(
      title: 'SWAYAM Govt Learning Portal',
      description:
          'Ministry of Education portal offering free online courses for engineering students.',
      category: 'Learning Portal',
      url: 'https://swayam.gov.in',
      icon: Icons.auto_stories_rounded,
    ),
    OfficialPortalItem(
      title: 'AICTE Official Portal',
      description:
          'All India Council for Technical Education portal for engineering scholarships & approvals.',
      category: 'Governing Body',
      url: 'https://www.aicte-india.org',
      icon: Icons.verified_rounded,
    ),
    OfficialPortalItem(
      title: 'UGC Official Portal',
      description:
          'University Grants Commission portal for higher education grants & fellowships.',
      category: 'Governing Body',
      url: 'https://www.ugc.gov.in',
      icon: Icons.account_balance_outlined,
    ),
    OfficialPortalItem(
      title: 'Official GRE (ETS Portal)',
      description:
          'Educational Testing Service portal for scheduling GRE exam dates & sending scores.',
      category: 'Global Exam',
      url: 'https://www.ets.org/gre',
      icon: Icons.language_rounded,
    ),
    OfficialPortalItem(
      title: 'Official TOEFL (ETS Portal)',
      description:
          'Official ETS portal for TOEFL iBT English proficiency test registration & score reports.',
      category: 'Global Exam',
      url: 'https://www.ets.org/toefl',
      icon: Icons.translate_rounded,
    ),
    OfficialPortalItem(
      title: 'Official IELTS Portal',
      description:
          'Official IELTS test booking, score checking & preparation materials for foreign study.',
      category: 'Global Exam',
      url: 'https://www.ielts.org',
      icon: Icons.public_rounded,
    ),
    OfficialPortalItem(
      title: 'Official GMAT Focus Edition (mba.com)',
      description:
          'Official GMAC portal for booking GMAT Focus Edition exam dates & business school applications.',
      category: 'Global Exam',
      url: 'https://www.mba.com',
      icon: Icons.business_center_rounded,
    ),
    OfficialPortalItem(
      title: 'Official CAT (IIM Portal)',
      description:
          'Common Admission Test official portal for IIM MBA registration & scorecard download.',
      category: 'Management',
      url: 'https://iimcat.ac.in',
      icon: Icons.workspace_premium_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      if (mounted) {
        context.read<HigherEducationProvider>().fetchHigherEducationResources();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _launchExternalUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final Uri uri = Uri.parse(urlString);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $urlString: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<HigherEducationProvider>();

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle =
        isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    const primaryBlue = AppColors.primary;
    const navyBlue = AppColors.primaryDark;

    final higherStudiesExams = provider.higherStudiesItems.where((i) {
      if (_searchController.text.trim().isEmpty) return true;
      final q = _searchController.text.toLowerCase();
      return i.title.toLowerCase().contains(q) ||
          i.subtitle.toLowerCase().contains(q) ||
          i.overview.toLowerCase().contains(q);
    }).toList();

    final governmentExams = provider.governmentItems.where((i) {
      if (_searchController.text.trim().isEmpty) return true;
      final q = _searchController.text.toLowerCase();
      return i.title.toLowerCase().contains(q) ||
          i.subtitle.toLowerCase().contains(q) ||
          i.overview.toLowerCase().contains(q);
    }).toList();

    final filteredPortals = _officialPortals.where((p) {
      if (_searchController.text.trim().isEmpty) return true;
      final q = _searchController.text.toLowerCase();
      return p.title.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: const CustomAppBar(
        title: '🎓 Higher Ed & Competitive Exams',
        showBackButton: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryBlue))
          : RefreshIndicator(
              onRefresh: () => provider.fetchHigherEducationResources(),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // HERO BANNER (GATE CSE 2027 FOCUS)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                            : [primaryBlue, navyBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withAlpha(isDark ? 30 : 60),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: Icon(
                            Icons.school_rounded,
                            size: 140,
                            color: Colors.white.withAlpha(isDark ? 15 : 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(22),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(35),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.school_rounded,
                                    color: Colors.white, size: 32),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '🎓 Higher Education & Competitive Exams',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'GATE, GRE, TOEFL, IELTS, CAT, GMAT, MS Abroad & Research Opportunities',
                                      style: GoogleFonts.inter(
                                        color: Colors.white.withAlpha(220),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: -0.05, end: 0),

                  const SizedBox(height: 20),

                  // SEARCH INPUT BAR
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(isDark ? 25 : 8),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText:
                            'Search GATE, GRE, TOEFL, IELTS, CAT, GMAT, MS Abroad...',
                        prefixIcon:
                            Icon(Icons.search_rounded, color: primaryBlue),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SEGMENTED TABS (3 TABS)
                  Container(
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: textSubtitle,
                      labelStyle: GoogleFonts.inter(
                          fontWeight: FontWeight.bold, fontSize: 12),
                      tabs: const [
                        Tab(text: '🎓 Higher Studies & Exams'),
                        Tab(text: '🏛️ Govt & PSUs'),
                        Tab(text: '🌐 Official Portals'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // TAB VIEW CONTENTS
                  SizedBox(
                    height: 620,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildExamList(
                            context,
                            higherStudiesExams,
                            primaryBlue,
                            cardColor,
                            borderColor,
                            textPrimary,
                            textSubtitle,
                            isDark),
                        _buildExamList(
                            context,
                            governmentExams,
                            navyBlue,
                            cardColor,
                            borderColor,
                            textPrimary,
                            textSubtitle,
                            isDark),
                        _buildPortalsList(
                            context,
                            filteredPortals,
                            primaryBlue,
                            cardColor,
                            borderColor,
                            textPrimary,
                            textSubtitle,
                            isDark),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildExamList(
    BuildContext context,
    List<HigherEducationModel> exams,
    Color themeColor,
    Color cardColor,
    Color borderColor,
    Color textPrimary,
    Color textSubtitle,
    bool isDark,
  ) {
    if (exams.isEmpty) {
      return Center(
        child: Text(
          'No matching exams found.',
          style: GoogleFonts.inter(color: textSubtitle, fontSize: 14),
        ),
      );
    }

    return ListView.builder(
      itemCount: exams.length,
      padding: const EdgeInsets.only(bottom: 24),
      itemBuilder: (ctx, idx) {
        final exam = exams[idx];
        final provider = context.watch<HigherEducationProvider>();
        final isSaved = provider.isSaved(exam.id);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HigherEdDetailScreen(item: exam),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: themeColor.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.workspace_premium_rounded,
                            color: themeColor, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exam.title,
                              style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              exam.subtitle,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: themeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isSaved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: isSaved ? themeColor : Colors.grey,
                        ),
                        onPressed: () => provider.toggleSave(exam.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    exam.overview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 13, color: textSubtitle),
                  ),
                  const SizedBox(height: 16),

                  // Chips Grid
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildBadge('Syllabus & Pattern', themeColor),
                      _buildBadge('Books & Resources', const Color(0xFF8B5CF6)),
                      _buildBadge(
                          'Salary: ${exam.salaryRange.split('|').first.trim()}',
                          const Color(0xFF10B981)),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Divider(height: 1, color: borderColor),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'View GATE CSE 2027 Full Roadmap & Exam Guide ➔',
                        style: GoogleFonts.inter(
                          color: themeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          size: 14, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPortalsList(
    BuildContext context,
    List<OfficialPortalItem> portals,
    Color royalBlue,
    Color cardColor,
    Color borderColor,
    Color textPrimary,
    Color textSubtitle,
    bool isDark,
  ) {
    if (portals.isEmpty) {
      return Center(
        child: Text(
          'No official portals match search query.',
          style: GoogleFonts.inter(color: textSubtitle, fontSize: 14),
        ),
      );
    }

    return ListView.builder(
      itemCount: portals.length,
      padding: const EdgeInsets.only(bottom: 24),
      itemBuilder: (ctx, idx) {
        final portal = portals[idx];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
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
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: royalBlue.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(portal.icon, color: royalBlue, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            portal.title,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: royalBlue.withAlpha(15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              portal.category,
                              style: GoogleFonts.inter(
                                color: royalBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  portal.description,
                  style: GoogleFonts.inter(fontSize: 13, color: textSubtitle),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _launchExternalUrl(portal.url),
                    icon: const Icon(Icons.open_in_new_rounded, size: 16),
                    label: const Text('Open Official Website'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: royalBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (20 * idx).ms).slideY(begin: 0.05, end: 0);
      },
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(40), width: 0.8),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
