import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/sort_option.dart';

import '../../providers/study_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/resource_card.dart';
import '../../widgets/shimmer_loading.dart';
import '../../widgets/empty_state_widget.dart';

class ResourceScreen extends StatefulWidget {
  final String subjectId;
  final String subjectName;

  const ResourceScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<ResourceScreen> createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  String _selectedCategory = '';
  SortOption _currentSort = SortOption.newest;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudyProvider>().fetchResources(widget.subjectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final studyProvider = context.watch<StudyProvider>();
    final rawResources = studyProvider.resources;

    final processedResources = ResourceSorter.sort(rawResources, _currentSort);

    final categories = ['All', ...AppConstants.resourceTypes];

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.subjectName,
        subtitle: 'Syllabus, Notes & Previous Question Papers',
      ),
      body: Column(
        children: [
          // Filter Chips & Sort Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((cat) {
                        final isSelected =
                            (_selectedCategory == '' && cat == 'All') || (_selectedCategory == cat);

                        final chipColor = cat == 'All' ? AppColors.primary : AppColors.secondary;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = cat == 'All' ? '' : cat;
                              });
                              studyProvider.setFilterCategory(
                                widget.subjectId,
                                _selectedCategory,
                              );
                            },
                            selectedColor: chipColor.withAlpha(30),
                            checkmarkColor: chipColor,
                            labelStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected
                                  ? chipColor
                                  : (isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight),
                            ),
                            backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: isSelected
                                    ? chipColor
                                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Popup Sort Menu
                PopupMenuButton<SortOption>(
                  icon: const Icon(Icons.sort_rounded, color: AppColors.primary),
                  tooltip: 'Sort Resources',
                  onSelected: (option) {
                    setState(() {
                      _currentSort = option;
                    });
                  },
                  itemBuilder: (ctx) => SortOption.values.map((opt) {
                    return PopupMenuItem<SortOption>(
                      value: opt,
                      child: Row(
                        children: [
                          if (_currentSort == opt)
                            const Icon(Icons.check_rounded, size: 16, color: AppColors.primary)
                          else
                            const SizedBox(width: 16),
                          const SizedBox(width: 8),
                          Text(opt.label),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Resource List
          Expanded(
            child: studyProvider.isLoading
                ? const ShimmerListLoading(itemCount: 4, itemHeight: 140)
                : processedResources.isEmpty
                    ? EmptyStateWidget(
                        title: 'Resources Will Be Available Soon',
                        message: _selectedCategory.isNotEmpty
                            ? 'No "$_selectedCategory" documents currently uploaded for this subject.'
                            : 'Study notes, question papers & syllabus for ${widget.subjectName} will be available soon.',
                        onActionTap: () => studyProvider.fetchResources(widget.subjectId),
                        actionLabel: 'Refresh',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: processedResources.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final res = processedResources[index];
                          return ResourceCard(
                            resource: res,
                            index: index,
                            onTap: () async {
                              if (res.videoUrl != null && res.videoUrl!.isNotEmpty) {
                                final Uri uri = Uri.parse(res.videoUrl!);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                }
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.pdfViewer,
                                  arguments: res,
                                );
                              }
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
