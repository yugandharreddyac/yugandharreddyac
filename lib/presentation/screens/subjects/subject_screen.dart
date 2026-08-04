import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../providers/study_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/subject_card.dart';
import '../../widgets/shimmer_loading.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/search_bar_widget.dart';

class SubjectScreen extends StatefulWidget {
  final String semesterId;
  final String semesterTitle;

  const SubjectScreen({
    super.key,
    required this.semesterId,
    required this.semesterTitle,
  });

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudyProvider>().fetchSubjects(widget.semesterId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studyProvider = context.watch<StudyProvider>();
    final allSubjects = studyProvider.subjects;

    final filteredSubjects = allSubjects.where((sub) {
      if (_filterQuery.isEmpty) return true;
      return sub.name.toLowerCase().contains(_filterQuery.toLowerCase()) ||
          sub.code.toLowerCase().contains(_filterQuery.toLowerCase()) ||
          sub.description.toLowerCase().contains(_filterQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.semesterTitle,
        subtitle: 'Core Academic Subjects',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: 'Filter subjects by code or name...',
              onChanged: (val) {
                setState(() {
                  _filterQuery = val;
                });
              },
            ),
          ),
          Expanded(
            child: studyProvider.isLoading
                ? const ShimmerListLoading(itemCount: 4, itemHeight: 140)
                : filteredSubjects.isEmpty
                    ? EmptyStateWidget(
                        title: 'No Subjects Found',
                        message: _filterQuery.isNotEmpty
                            ? 'No subjects match "$_filterQuery".'
                            : 'No subjects listed for this semester.',
                        onActionTap: () => studyProvider.fetchSubjects(widget.semesterId),
                        actionLabel: 'Refresh',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: filteredSubjects.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final subject = filteredSubjects[index];
                          return SubjectCard(
                            subject: subject,
                            index: index,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.resources,
                                arguments: {
                                  'subjectId': subject.id,
                                  'subjectName': subject.name,
                                },
                              );
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
