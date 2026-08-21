import '../models/career_models.dart';
import '../models/user_goal_model.dart';
import 'non_academic_data.dart';

class CareerDataMapper {
  CareerDataMapper._();

  // Maps a skill name (e.g. "Python") to its category and the list of related topic IDs
  static const Map<String, Map<String, dynamic>> _skillDefinitions = {
    'Python': {
      'category': 'Programming',
      'topics': ['python_basics', 'lists_tuples', 'python_oop', 'python_dsa']
    },
    'Java': {
      'category': 'Programming',
      'topics': ['java_intro', 'java_oop', 'java_collections']
    },
    'C++': {
      'category': 'Programming',
      'topics': ['cpp_basics', 'cpp_stl', 'cpp_pointers']
    },
    'Arrays & Strings': {
      'category': 'Problem Solving',
      'topics': ['arrays_strings_dsa']
    },
    'Trees & Graphs': {
      'category': 'Problem Solving',
      'topics': ['trees_bst', 'graph_algorithms']
    },
    'Dynamic Programming': {
      'category': 'Problem Solving',
      'topics': ['dp_basics']
    },
    'Web Development': {
      'category': 'Development',
      'topics': ['html_css', 'javascript_basics', 'react_intro', 'node_backend']
    },
    'Git & GitHub': {
      'category': 'Development',
      'topics': ['git_basics']
    },
    'Machine Learning': {
      'category': 'AI / ML',
      'topics': ['ml_intro', 'supervised_learning', 'neural_networks']
    },
    'Cloud Computing': {
      'category': 'Cloud',
      'topics': ['cloud_basics', 'aws_intro']
    },
  };

  // Dimensions mapping depending on CareerGoal
  static Map<String, List<String>> getDimensionsForGoal(CareerGoal goal) {
    switch (goal) {
      case CareerGoal.softwarePlacement:
        return {
          'Programming': [
            'python_basics',
            'java_intro',
            'cpp_basics',
            'python_oop'
          ],
          'DSA': [
            'arrays_strings_dsa',
            'trees_bst',
            'graph_algorithms',
            'dp_basics'
          ],
          'Core CS': ['os_basics', 'dbms_intro', 'networks_basics'],
          'Projects': [
            'portfolio_project',
            'ecommerce_clone'
          ], // using sample project topic ids
          'Interview Prep': [
            'aptitude_basics',
            'hr_interview',
            'mock_interviews'
          ],
        };
      case CareerGoal.gateExam:
        return {
          'Core CS': [
            'os_basics',
            'dbms_intro',
            'networks_basics',
            'toc_basics'
          ],
          'DSA': ['arrays_strings_dsa', 'trees_bst', 'graph_algorithms'],
          'Practice': ['gate_mock_test_1', 'gate_pyq'],
        };
      case CareerGoal.msHigherStudies:
        return {
          'Technical Prep': [
            'os_basics',
            'dbms_intro',
            'networks_basics',
            'ml_intro'
          ],
          'GRE / TOEFL': ['gre_verbal', 'gre_quant'],
          'Research': ['research_methodology', 'sop_writing'],
        };
      case CareerGoal.mbaCat:
        return {
          'Quantitative Aptitude': ['quant_basics', 'quant_advanced'],
          'Logical Reasoning': ['logical_reasoning_1', 'data_interpretation'],
          'Verbal Ability': ['verbal_ability', 'reading_comprehension'],
        };
      case CareerGoal.entrepreneurship:
        return {
          'Ideation': ['problem_discovery', 'customer_validation'],
          'Product': ['mvp_development', 'agile_basics'],
          'Business': ['business_model_canvas', 'pitch_deck'],
        };
      case CareerGoal.generalSkillDev:
        return {
          'Programming': ['python_basics', 'java_intro', 'cpp_basics'],
          'Web / App': ['html_css', 'javascript_basics', 'flutter_intro'],
          'Emerging Tech': ['ml_intro', 'cloud_basics', 'cybersecurity_intro'],
        };
    }
  }

  static SkillEvidenceLevel calculateSkillLevel(
      String skillName, Map<String, TopicProgressModel> progressMap) {
    final def = _skillDefinitions[skillName];
    if (def == null) return SkillEvidenceLevel.notStarted;

    final topicIds = List<String>.from(def['topics'] as List);
    bool hasLearned = false;
    bool hasPracticed = false;
    bool hasDemonstrated = false;

    for (final tId in topicIds) {
      final prog = progressMap[tId];
      if (prog != null) {
        if (prog.learnCompleted) hasLearned = true;
        if (prog.practiceCompleted) hasPracticed = true;
        if (prog.buildCompleted) hasDemonstrated = true;
      }
    }

    if (hasDemonstrated) return SkillEvidenceLevel.demonstrated;
    if (hasPracticed) return SkillEvidenceLevel.practiced;
    if (hasLearned) return SkillEvidenceLevel.learning;
    return SkillEvidenceLevel.notStarted;
  }

  static List<SkillEvidenceModel> getAllSkills(
      Map<String, TopicProgressModel> progressMap) {
    return _skillDefinitions.entries.map((e) {
      final skillName = e.key;
      final category = e.value['category'] as String;
      final topicIds = List<String>.from(e.value['topics'] as List);
      final level = calculateSkillLevel(skillName, progressMap);
      return SkillEvidenceModel(
        skillName: skillName,
        category: category,
        relatedTopicIds: topicIds,
        level: level,
      );
    }).toList();
  }

  static List<SkillEvidenceModel> getSkillsForTopic(
      String topicId, Map<String, TopicProgressModel> progressMap) {
    return getAllSkills(progressMap)
        .where((s) => s.relatedTopicIds.contains(topicId))
        .toList();
  }

  static List<ProjectPortfolioModel> getProjects(
      Map<String, TopicProgressModel> progressMap) {
    final List<ProjectPortfolioModel> projects = [];
    final hub = NonAcademicData.getHubById('projects');
    if (hub == null) return projects;

    for (final category in hub.categories) {
      for (final topic in category.topics) {
        ProjectState state = ProjectState.notStarted;
        final prog = progressMap[topic.id];

        if (prog != null) {
          if (prog.reviewCompleted) {
            state = ProjectState.completed;
          } else if (prog.buildCompleted) {
            state = ProjectState.testing; // testing/documented
          } else if (prog.practiceCompleted) {
            state = ProjectState.building;
          } else if (prog.learnCompleted) {
            state = ProjectState.planning;
          }
        }

        // Dummy mapping for demonstrated skills based on project topic title
        List<String> skills = [];
        if (topic.title.toLowerCase().contains('python')) skills.add('Python');
        if (topic.title.toLowerCase().contains('web') ||
            topic.title.toLowerCase().contains('portfolio'))
          skills.addAll(['HTML', 'CSS', 'JavaScript', 'Web Development']);
        if (topic.title.toLowerCase().contains('app')) skills.add('Flutter');
        if (topic.title.toLowerCase().contains('ml') ||
            topic.title.toLowerCase().contains('predictor'))
          skills.add('Machine Learning');

        projects.add(ProjectPortfolioModel(
          topicId: topic.id,
          projectName: topic.title,
          state: state,
          demonstratedSkills: skills,
        ));

        for (final sub in topic.subtopics) {
          ProjectState subState = ProjectState.notStarted;
          final subProg = progressMap[sub.id];

          if (subProg != null) {
            if (subProg.reviewCompleted) {
              subState = ProjectState.completed;
            } else if (subProg.buildCompleted) {
              subState = ProjectState.testing;
            } else if (subProg.practiceCompleted) {
              subState = ProjectState.building;
            } else if (subProg.learnCompleted) {
              subState = ProjectState.planning;
            }
          }
          List<String> subSkills = [];
          if (sub.title.toLowerCase().contains('python'))
            subSkills.add('Python');
          if (sub.title.toLowerCase().contains('web') ||
              sub.title.toLowerCase().contains('portfolio'))
            subSkills.addAll(['HTML', 'CSS', 'JavaScript', 'Web Development']);
          if (sub.title.toLowerCase().contains('app')) subSkills.add('Flutter');
          if (sub.title.toLowerCase().contains('ml') ||
              sub.title.toLowerCase().contains('predictor'))
            subSkills.add('Machine Learning');

          projects.add(ProjectPortfolioModel(
            topicId: sub.id,
            projectName: sub.title,
            state: subState,
            demonstratedSkills: subSkills,
          ));
        }
      }
    }
    return projects;
  }
}
