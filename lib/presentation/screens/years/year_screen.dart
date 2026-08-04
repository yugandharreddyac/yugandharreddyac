import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/study_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/year_card.dart';
import '../../widgets/shimmer_loading.dart';
import '../semesters/semester_screen.dart';

class YearScreen extends StatefulWidget {
  final String? selectedYearId;

  const YearScreen({super.key, this.selectedYearId});

  @override
  State<YearScreen> createState() => _YearScreenState();
}

class _YearScreenState extends State<YearScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<StudyProvider>();
      if (provider.years.isEmpty) {
        provider.fetchYears();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final studyProvider = context.watch<StudyProvider>();
    final years = studyProvider.years;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Academic Years',
        subtitle: 'Select your study year (1st - 4th)',
      ),
      body: studyProvider.isLoading
          ? const ShimmerListLoading(itemCount: 4, itemHeight: 120)
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: years.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final year = years[index];
                return YearCard(
                  year: year,
                  index: index,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SemesterScreen(
                          yearId: year.id,
                          yearTitle: year.title,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
