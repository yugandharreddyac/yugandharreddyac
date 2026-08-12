import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/datasources/non_academic_data.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Master Content & Hierarchy Audit Tests', () {
    test('Verify all 6 hubs + Entrepreneurship Hub exist in NonAcademicData', () {
      final hubs = NonAcademicData.allHubs;
      expect(hubs.length, greaterThanOrEqualTo(6));

      final hubIds = hubs.map((h) => h.id).toList();
      expect(hubIds, contains('coding'));
      expect(hubIds, contains('emerging_tech'));
      expect(hubIds, contains('placement'));
      expect(hubIds, contains('projects'));
      expect(hubIds, contains('higher_education'));
      expect(hubIds, contains('entrepreneurship'));
    });

    test('Verify all external resource URLs across all hubs use valid HTTPS schemes', () {
      int totalResources = 0;
      int validHttpsUrls = 0;
      int invalidUrls = 0;

      for (final hub in NonAcademicData.allHubs) {
        for (final category in hub.categories) {
          for (final topic in category.topics) {
            // Direct resources
            for (final res in topic.resources) {
              totalResources++;
              if (res.url.startsWith('https://') || res.url.startsWith('http://')) {
                validHttpsUrls++;
              } else {
                invalidUrls++;
              }
            }
            // Subtopic resources
            for (final subtopic in topic.subtopics) {
              for (final res in subtopic.resources) {
                totalResources++;
                if (res.url.startsWith('https://') || res.url.startsWith('http://')) {
                  validHttpsUrls++;
                } else {
                  invalidUrls++;
                }
              }
            }
          }
        }
      }

      expect(invalidUrls, equals(0));
      expect(validHttpsUrls, equals(totalResources));
      expect(totalResources, greaterThanOrEqualTo(100));
    });

    test('Verify SearchIndexEngine indexes Entrepreneurship and all non-academic hubs', () {
      final searchEngine = SearchIndexEngine();
      searchEngine.buildIndex([], []);

      expect(searchEngine.itemCount, greaterThan(340));

      final startupResults = searchEngine.search('Startup');
      expect(startupResults.isNotEmpty, isTrue);

      final mvpResults = searchEngine.search('MVP');
      expect(mvpResults.isNotEmpty, isTrue);

      final pythonResults = searchEngine.search('Python');
      expect(pythonResults.isNotEmpty, isTrue);
    });
  });
}
