import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csse_study_hub/data/services/code_execution_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 3 — Coding Hub Playground & Execution Service Tests', () {
    late CodeExecutionService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = CodeExecutionService();
    });

    test('SupportedLanguage enum exposes valid templates and metadata', () {
      expect(SupportedLanguage.values.length, equals(3));
      expect(SupportedLanguage.python.displayName, contains('Python'));
      expect(SupportedLanguage.cpp.displayName, contains('C++'));
      expect(SupportedLanguage.java.displayName, contains('Java'));

      expect(SupportedLanguage.python.defaultTemplate.isNotEmpty, isTrue);
      expect(SupportedLanguage.cpp.defaultTemplate.contains('int main'), isTrue);
      expect(SupportedLanguage.java.defaultTemplate.contains('public static void main'), isTrue);
    });

    test('Empty source code returns structured error result without throwing', () async {
      final result = await service.executeCode(
        language: SupportedLanguage.python,
        code: '   ',
      );

      expect(result.isSuccess, isFalse);
      expect(result.exitCode, equals(1));
      expect(result.stderr, contains('empty'));
    });

    test('C++ code without main function returns compilation error', () async {
      final result = await service.executeCode(
        language: SupportedLanguage.cpp,
        code: 'int x = 10;',
      );

      expect(result.isSuccess, isFalse);
      expect(result.stderr, contains('main'));
    });

    test('Java code without main method returns error', () async {
      final result = await service.executeCode(
        language: SupportedLanguage.java,
        code: 'public class Test { int x = 5; }',
      );

      expect(result.isSuccess, isFalse);
      expect(result.stderr, contains('Main method not found'));
    });

    test('Preset algorithm programs execute and produce stdout output', () async {
      // 1. Python Binary Search
      final pyBinarySearch = CodeExecutionService.presets[SupportedLanguage.python]?['Binary Search'];
      expect(pyBinarySearch, isNotNull);

      final pyResult = await service.executeCode(
        language: SupportedLanguage.python,
        code: pyBinarySearch!,
      );

      expect(pyResult.isSuccess, isTrue);
      expect(pyResult.stdout, contains('Target 23 found at index: 5'));
      expect(pyResult.executionTimeMs, greaterThanOrEqualTo(0));
      expect(pyResult.memoryUsageMb, greaterThan(0));

      // 2. C++ Reverse String
      final cppReverse = CodeExecutionService.presets[SupportedLanguage.cpp]?['Reverse String & Palindrome'];
      expect(cppReverse, isNotNull);

      final cppResult = await service.executeCode(
        language: SupportedLanguage.cpp,
        code: cppReverse!,
      );

      expect(cppResult.isSuccess, isTrue);
      expect(cppResult.stdout, contains('Is Palindrome: True'));

      // 3. Java Custom Stack
      final javaStack = CodeExecutionService.presets[SupportedLanguage.java]?['Stack Implementation'];
      expect(javaStack, isNotNull);

      final javaResult = await service.executeCode(
        language: SupportedLanguage.java,
        code: javaStack!,
      );

      expect(javaResult.isSuccess, isTrue);
      expect(javaResult.stdout, contains('Top element: 30'));
    });

    test('Local snippet persistence saves, retrieves, and deletes correctly', () async {
      final initialList = await service.getSavedSnippets();
      expect(initialList.isEmpty, isTrue);

      final snippet1 = CodeSnippetModel(
        id: 'snip_01',
        title: 'Quick Sort Implementation',
        language: SupportedLanguage.python,
        code: 'def quick_sort(arr): return arr',
        stdin: '1 2 3',
        createdAt: DateTime.now(),
      );

      await service.saveSnippet(snippet1);

      final retrieved = await service.getSavedSnippets();
      expect(retrieved.length, equals(1));
      expect(retrieved.first.id, equals('snip_01'));
      expect(retrieved.first.title, equals('Quick Sort Implementation'));
      expect(retrieved.first.language, equals(SupportedLanguage.python));

      // Delete snippet
      await service.deleteSnippet('snip_01');
      final afterDelete = await service.getSavedSnippets();
      expect(afterDelete.isEmpty, isTrue);
    });
  });
}
