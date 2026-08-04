import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/share_helper.dart';
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

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: _isHovered ? (Matrix4.identity()..translate(0, -3)) : Matrix4.identity(),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap ??
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResourceScreen(
                          subjectId: widget.subject.id,
                          subjectName: widget.subject.name,
                        ),
                      ),
                    );
                  },
              borderRadius: BorderRadius.circular(20),
              splashColor: iconInfo.accentColor.withAlpha(30),
              highlightColor: iconInfo.accentColor.withAlpha(15),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isHovered
                        ? iconInfo.accentColor
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    width: _isHovered ? 1.8 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? iconInfo.accentColor.withAlpha(50)
                          : Colors.black.withAlpha(isDark ? 30 : 8),
                      blurRadius: _isHovered ? 18 : 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Subject Icon / Emoji Container
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: iconInfo.accentColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: iconInfo.accentColor.withAlpha(60),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              iconInfo.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Subject Code & Credits Badge
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: iconInfo.accentColor.withAlpha(20),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      widget.subject.code,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: iconInfo.accentColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withAlpha(20),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${widget.subject.creditHours} Credits',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.subject.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Share Action Button
                        IconButton(
                          icon: const Icon(Icons.share_outlined, size: 18, color: Colors.grey),
                          onPressed: () {
                            ShareHelper.shareSubject(context, widget.subject);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Text(
                      widget.subject.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Quick Category Filter Chips
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 6,
                          children: [
                            _quickChip(context, 'Syllabus', 'Syllabus', iconInfo.accentColor),
                            _quickChip(context, 'Notes', 'Notes', iconInfo.accentColor),
                            _quickChip(context, 'Papers', 'Previous Question Papers', iconInfo.accentColor),
                          ],
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _isHovered ? iconInfo.accentColor : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: _isHovered ? Colors.white : iconInfo.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 350.ms, delay: (widget.index * 60).ms),
      ),
    );
  }

  Widget _quickChip(BuildContext context, String label, String category, Color color) {
    return InkWell(
      onTap: () => _navigateToCategory(context, category),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
