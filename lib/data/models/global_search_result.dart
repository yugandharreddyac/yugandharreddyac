import 'subject_model.dart';
import 'resource_model.dart';
import 'career_model.dart';
import 'coding_resource_model.dart';
import 'placement_model.dart';
import 'project_model.dart';

class GlobalSearchResult {
  final List<SubjectModel> matchingSubjects;
  final List<ResourceModel> matchingResources;
  final List<CareerModel> matchingCareerTechs;
  final List<CodingResourceModel> matchingCodingResources;
  final List<PlacementModel> matchingPlacementItems;
  final List<ProjectModel> matchingProjects;

  const GlobalSearchResult({
    this.matchingSubjects = const [],
    this.matchingResources = const [],
    this.matchingCareerTechs = const [],
    this.matchingCodingResources = const [],
    this.matchingPlacementItems = const [],
    this.matchingProjects = const [],
  });

  bool get isEmpty =>
      matchingSubjects.isEmpty &&
      matchingResources.isEmpty &&
      matchingCareerTechs.isEmpty &&
      matchingCodingResources.isEmpty &&
      matchingPlacementItems.isEmpty &&
      matchingProjects.isEmpty;

  bool get isNotEmpty => !isEmpty;
}
