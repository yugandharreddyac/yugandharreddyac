import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../providers/study_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/semester_card.dart';
import '../../widgets/shimmer_loading.dart';
import '../../widgets/empty_state_widget.dart';

class SemesterScreen extends StatefulWidget {
  final String yearId;
  final String yearTitle;

  const SemesterScreen({
    super.key,
    required this.yearId,
    required this.yearTitle,
  });

  @override
  State<SemesterScreen> createState() => _SemesterScreenState();
}

class _SemesterScreenState extends State<SemesterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudyProvider>().fetchSemesters(widget.yearId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final studyProvider = context.watch<StudyProvider>();
    final semesters = studyProvider.semesters;

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.yearTitle,
        subtitle: 'Select semester to view enrolled subjects',
      ),
      body: studyProvider.isLoading
          ? const ShimmerListLoading(itemCount: 2, itemHeight: 90)
          : semesters.isEmpty
              ? EmptyStateWidget(
                  title: 'No Semesters Found',
                  message:
                      'No active semesters listed under ${widget.yearTitle}.',
                  onActionTap: () =>
                      studyProvider.fetchSemesters(widget.yearId),
                  actionLabel: 'Retry',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: semesters.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final sem = semesters[index];
                    return SemesterCard(
                      semester: sem,
                      index: index,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.subjects,
                          arguments: {
                            'semesterId': sem.id,
                            'semesterTitle':
                                '${widget.yearTitle} • ${sem.title}',
                          },
                        );
                      },
                    );
                  },
                ),
    );
  }
}
