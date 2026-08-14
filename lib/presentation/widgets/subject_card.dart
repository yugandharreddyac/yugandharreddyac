import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/subject_model.dart';
import '../providers/study_provider.dart';
import '../screens/resources/resource_screen.dart';

class SubjectCard extends StatefulWidget {
  final SubjectModel subject;
  final VoidCallback? onTap;
  final int index;

  const SubjectCard({
    super.key,
    required this.subject,
    this.onTap,
    this.index = 0,
  });

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  bool _isHovered = false;

  void _navigateToCategory(BuildContext context, String category) {
    final studyProvider = context.read<StudyProvider>();
    studyProvider.setFilterCategory(widget.subject.id, category);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResourceScreen(
          subjectId: widget.subject.id,
          subjectName: widget.subject.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final iconInfo = Formatters.getSubjectIconInfo(widget.subject.name);
    final accentColor = iconInfo.accentColor;

    final cardBgColor = isDark ? AppColors.surfaceDark : Colors.white;
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF09090B);
    final textSecondary = isDark ? AppColors.textSecondaryDark : const Color(0xFF71717A);
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE4E4E7);

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          transform: _isHovered ? (Matrix4.identity()..translate(0, -2)) : Matrix4.identity(),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered ? accentColor.withAlpha(180) : borderColor,
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? accentColor.withAlpha(isDark ? 40 : 25)
                    : Colors.black.withAlpha(isDark ? 25 : 6),
                blurRadius: _isHovered ? 14 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: widget.onTap ??
                  () => _navigateToCategory(context, ''),
              borderRadius: BorderRadius.circular(20),
              splashColor: accentColor.withAlpha(20),
              highlightColor: accentColor.withAlpha(10),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. TOP ROW: Subject Icon, Name, Code & Credits
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Small 40x40 Accent Container
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: accentColor.withAlpha(isDark ? 35 : 20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              iconInfo.emoji,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Subject Name, Code & Credits
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.subject.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    widget.subject.code,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: accentColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '•',
                                    style: TextStyle(fontSize: 12, color: textSecondary),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${widget.subject.creditHours} Credits',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // 2. MIDDLE: Small Subtitle (1 line max)
                    if (widget.subject.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.subject.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: textSecondary,
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    // Divider Line
                    Divider(height: 1, color: borderColor.withAlpha(120)),

                    const SizedBox(height: 6),

                    // 3. BOTTOM: Three Premium Action Rows (List Tiles with Chevron)
                    _buildActionRow(
                      context,
                      iconEmoji: '📄',
                      title: 'Syllabus',
                      accentColor: accentColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      onTap: () => _navigateToCategory(context, 'Syllabus'),
                    ),
                    _buildActionRow(
                      context,
                      iconEmoji: '📝',
                      title: 'Notes',
                      accentColor: accentColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      onTap: () => _navigateToCategory(context, 'Notes'),
                    ),
                    _buildActionRow(
                      context,
                      iconEmoji: '📚',
                      title: 'Previous Papers',
                      accentColor: accentColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      isLast: true,
                      onTap: () => _navigateToCategory(context, 'Previous Question Papers'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionRow(
    BuildContext context, {
    required String iconEmoji,
    required String title,
    required Color accentColor,
    required Color textPrimary,
    required Color textSecondary,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          child: Row(
            children: [
              Text(
                iconEmoji,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: textSecondary.withAlpha(180),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
