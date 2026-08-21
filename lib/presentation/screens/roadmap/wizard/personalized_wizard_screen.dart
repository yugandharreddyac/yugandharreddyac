import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/personalized_roadmap_models.dart';
import '../../../../data/repositories/roadmap_repository.dart';

class PersonalizedWizardScreen extends StatefulWidget {
  final PersonalizedProfile? initialProfile;
  final Function(PersonalizedProfile profile)? onProfileCreated;

  const PersonalizedWizardScreen({
    super.key,
    this.initialProfile,
    this.onProfileCreated,
  });

  @override
  State<PersonalizedWizardScreen> createState() =>
      _PersonalizedWizardScreenState();
}

class _PersonalizedWizardScreenState extends State<PersonalizedWizardScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 15; // 14 question steps + 1 review step

  // Form State
  late AcademicStage _academicStage;
  late List<String> _goals;
  late String _primaryCareerDirection;
  String? _secondaryCareerDirection;
  late List<String> _interestAreas;
  late SkillLevel _overallSkillLevel;
  late Map<String, SkillLevel> _skillLevels;
  late List<String> _programmingLanguages;
  late String _primaryLanguage;
  String? _secondaryLanguage;
  late String _projectExperience;
  late String _internshipStatus;
  late String _openSourceExperience;
  late String _codingPracticeLevel;
  late List<String> _targetOrganizationTypes;
  String? _targetCompany;
  late int _dailyLearningTimeMinutes;
  late String _weeklyAvailability;
  late String _targetTimeline;
  late LearningStyle _learningStyle;
  late List<String> _strengths;
  late List<String> _weaknesses;
  late List<String> _placementPreparationAreas;

  // Domain specific sub-ratings
  String _aiExperience = 'Beginner';
  String _webExperience = 'Beginner';
  String _securityExperience = 'Beginner';
  String _cloudExperience = 'Beginner';

  final RoadmapRepository _repository = RoadmapRepository();

  @override
  void initState() {
    super.initState();
    final p = widget.initialProfile;
    _academicStage = p?.academicStage ?? AcademicStage.thirdYear;
    _goals = p?.goals != null
        ? List.from(p!.goals)
        : ['Placement', 'Software Development'];
    _primaryCareerDirection = p?.primaryCareerDirection ?? 'AI Engineer';
    _secondaryCareerDirection = p?.careerDirections.length != null &&
            (p?.careerDirections.length ?? 0) > 1
        ? p!.careerDirections[1]
        : 'Full Stack Developer';
    _interestAreas = p?.interestAreas != null
        ? List.from(p!.interestAreas)
        : ['AI', 'Machine Learning', 'Python', 'DSA'];
    _overallSkillLevel = p?.overallSkillLevel ?? SkillLevel.beginner;
    _skillLevels = p?.skillLevels != null
        ? Map.from(p!.skillLevels)
        : {
            'dsa': SkillLevel.beginner,
            'dbms': SkillLevel.basic,
            'os': SkillLevel.basic,
            'cn': SkillLevel.beginner,
            'oop': SkillLevel.intermediate,
          };
    _programmingLanguages = p?.programmingLanguages != null
        ? List.from(p!.programmingLanguages)
        : ['Python', 'C++', 'SQL'];
    _primaryLanguage = p?.primaryLanguage ?? 'Python';
    _secondaryLanguage = p?.secondaryLanguage ?? 'C++';
    _projectExperience = p?.projectExperience ?? '1 personal project';
    _internshipStatus = p?.internshipStatus ?? 'Looking for internship';
    _openSourceExperience = p?.openSourceExperience ?? 'Interested';
    _codingPracticeLevel = p?.codingPracticeLevel ?? 'Occasionally';
    _targetOrganizationTypes = p?.targetOrganizationTypes != null
        ? List.from(p!.targetOrganizationTypes)
        : ['Product-based companies', 'Startups'];
    _targetCompany = p?.targetCompany;
    _dailyLearningTimeMinutes = p?.dailyLearningTimeMinutes ?? 120;
    _weeklyAvailability = p?.weeklyAvailability ?? 'Weekdays + weekends';
    _targetTimeline = p?.targetTimeline ?? '6 months';
    _learningStyle = p?.learningStyle ?? LearningStyle.balanced;
    _strengths = p?.strengths != null
        ? List.from(p!.strengths)
        : ['Programming', 'Problem Solving'];
    _weaknesses =
        p?.weaknesses != null ? List.from(p!.weaknesses) : ['DSA', 'Aptitude'];
    _placementPreparationAreas = p?.placementPreparationAreas != null
        ? List.from(p!.placementPreparationAreas)
        : [
            'Aptitude',
            'DSA',
            'Technical Interviews',
            'DBMS',
            'Operating Systems'
          ];
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < _totalSteps - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.maybePop(context);
    }
  }

  void _goToStep(int stepIndex) {
    if (stepIndex >= 0 && stepIndex < _totalSteps) {
      _pageController.animateToPage(
        stepIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    if (_currentStep == 1 && _goals.isEmpty) {
      _showWarningSnackBar('Please select at least one primary goal.');
      return false;
    }
    if (_currentStep == 2 && _primaryCareerDirection.isEmpty) {
      _showWarningSnackBar('Please select your primary career direction.');
      return false;
    }
    if (_currentStep == 3 && _interestAreas.isEmpty) {
      _showWarningSnackBar('Please pick at least one interest area.');
      return false;
    }
    if (_currentStep == 5 && _primaryLanguage.isEmpty) {
      _showWarningSnackBar('Please select your primary programming language.');
      return false;
    }
    return true;
  }

  void _showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter()),
        backgroundColor: Colors.amber.shade900,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  PersonalizedProfile _buildProfile() {
    final careerDirs = [_primaryCareerDirection];
    if (_secondaryCareerDirection != null &&
        _secondaryCareerDirection!.isNotEmpty &&
        _secondaryCareerDirection != _primaryCareerDirection) {
      careerDirs.add(_secondaryCareerDirection!);
    }

    final langs = List<String>.from(_programmingLanguages);
    if (!langs.contains(_primaryLanguage)) {
      langs.insert(0, _primaryLanguage);
    }

    return PersonalizedProfile(
      academicStage: _academicStage,
      goals: _goals,
      careerDirections: careerDirs,
      primaryCareerDirection: _primaryCareerDirection,
      interestAreas: _interestAreas,
      overallSkillLevel: _overallSkillLevel,
      skillLevels: _skillLevels,
      programmingLanguages: langs,
      primaryLanguage: _primaryLanguage,
      secondaryLanguage: _secondaryLanguage,
      projectExperience: _projectExperience,
      internshipStatus: _internshipStatus,
      openSourceExperience: _openSourceExperience,
      codingPracticeLevel: _codingPracticeLevel,
      targetOrganizationTypes: _targetOrganizationTypes,
      targetCompany: _targetCompany,
      dailyLearningTimeMinutes: _dailyLearningTimeMinutes,
      weeklyAvailability: _weeklyAvailability,
      targetTimeline: _targetTimeline,
      learningStyle: _learningStyle,
      strengths: _strengths,
      weaknesses: _weaknesses,
      placementPreparationAreas: _placementPreparationAreas,
      createdAt: widget.initialProfile?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Future<void> _submitProfile() async {
    final profile = _buildProfile();
    await _repository.savePersonalizedProfile(profile);

    if (widget.onProfileCreated != null) {
      widget.onProfileCreated!(profile);
    }

    if (mounted) {
      Navigator.pop(context, profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const royalBlue = Color(0xFF2563EB);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personalized Roadmap Wizard',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _prevStep,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '${_currentStep + 1} / $_totalSteps',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isDark ? const Color(0xFF93C5FD) : royalBlue,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / _totalSteps,
            backgroundColor:
                isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation<Color>(royalBlue),
            minHeight: 4,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics:
                        const NeverScrollableScrollPhysics(), // Require button click for validation
                    onPageChanged: (index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                    children: [
                      _buildStep1AcademicStage(
                          isDark, cardBg, textPrimary, textSecondary),
                      _buildStep2PrimaryGoals(
                          isDark, cardBg, textPrimary, textSecondary),
                      _buildStep3CareerDirection(
                          isDark, cardBg, textPrimary, textSecondary),
                      _buildStep4InterestAreas(
                          isDark, cardBg, textPrimary, textSecondary),
                      _buildStep5SkillLevel(
                          isDark, cardBg, textPrimary, textSecondary),
                      _buildStep6ProgrammingLanguages(
                          isDark, cardBg, textPrimary, textSecondary),
                      _buildStep7CoreCsSkills(
                          isDark, cardBg, textPrimary, textSecondary),
                      _buildStep8DomainExperience(
                          isDark, cardBg, textPrimary, textSecondary),
                      _buildStep9PracticalExperience(
                          isDark, cardBg, textPrimary, textSecondary),
                      _buildStep10Strengths(
                          isDark, cardBg, textPrimary, textSecondary),
                      _buildStep11Weaknesses(
                          isDark, cardBg, textPrimary, textSecondary),
                      _buildStep12LearningStyle(
                          isDark, cardBg, textPrimary, textSecondary),
                      _buildStep13TimeAvailability(
                          isDark, cardBg, textPrimary, textSecondary),
                      _buildStep14TimelineAndGoals(
                          isDark, cardBg, textPrimary, textSecondary),
                      _buildStep15FinalReview(
                          isDark, cardBg, textPrimary, textSecondary),
                    ],
                  ),
                ),
                _buildBottomNavigation(isDark, royalBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Step 1: Academic Stage ---
  Widget _buildStep1AcademicStage(
      bool isDark, Color cardBg, Color textPrimary, Color textSecondary) {
    return _WizardStepLayout(
      title: 'Current Academic Stage',
      subtitle:
          'Tell us where you are in your academic or professional journey.',
      icon: Icons.school_rounded,
      child: Column(
        children: AcademicStage.values.map((stage) {
          final isSelected = _academicStage == stage;
          return _SelectableCard(
            title: stage.displayName,
            subtitle: _getAcademicSubtitle(stage),
            icon: _getAcademicIcon(stage),
            isSelected: isSelected,
            isDark: isDark,
            onTap: () {
              setState(() {
                _academicStage = stage;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  // --- Step 2: Primary Goals ---
  Widget _buildStep2PrimaryGoals(
      bool isDark, Color cardBg, Color textPrimary, Color textSecondary) {
    final availableGoals = [
      'Placement',
      'Internship',
      'Higher Studies',
      'Software Development',
      'Research',
      'Entrepreneurship',
      'Freelancing',
      'Competitive Exams',
      'Skill Development',
      'Career Switching',
    ];

    return _WizardStepLayout(
      title: 'Primary Goal(s)',
      subtitle: 'Select one or more targets that drive your learning.',
      icon: Icons.flag_rounded,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: availableGoals.map((goal) {
          final isSelected = _goals.contains(goal);
          return _FilterChipCard(
            label: goal,
            isSelected: isSelected,
            isDark: isDark,
            onTap: () {
              setState(() {
                if (isSelected) {
                  _goals.remove(goal);
                } else {
                  _goals.add(goal);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  // --- Step 3: Career Direction ---
  Widget _buildStep3CareerDirection(
      bool isDark, Color cardBg, Color textPrimary, Color textSecondary) {
    final categories = {
      'Software Development': [
        'Software Engineer',
        'Backend Developer',
        'Frontend Developer',
        'Full Stack Developer',
        'Mobile App Developer',
        'Systems Programmer',
      ],
      'AI & Data Science': [
        'AI Engineer',
        'Machine Learning Engineer',
        'Data Scientist',
        'Data Analyst',
        'Data Engineer',
        'Generative AI Engineer',
      ],
      'Cloud & Infrastructure': [
        'Cloud Engineer',
        'DevOps Engineer',
        'Site Reliability Engineer',
        'Platform Engineer',
      ],
      'Security & Systems': [
        'Cybersecurity Engineer',
        'Security Analyst',
        'Ethical Hacker',
        'Embedded Systems Engineer',
        'IoT Engineer',
      ],
    };

    return _WizardStepLayout(
      title: 'Career Direction',
      subtitle: 'Pick your primary career track and optional secondary focus.',
      icon: Icons.psychology_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  entry.key,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: textSecondary),
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: entry.value.map((role) {
                  final isPrimary = _primaryCareerDirection == role;
                  final isSecondary = _secondaryCareerDirection == role;
                  return ChoiceChip(
                    label: Text(
                      isPrimary ? '★ $role' : role,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight:
                            isPrimary ? FontWeight.bold : FontWeight.normal,
                        color: isPrimary || isSecondary
                            ? Colors.white
                            : textPrimary,
                      ),
                    ),
                    selected: isPrimary || isSecondary,
                    selectedColor: isPrimary
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF059669),
                    backgroundColor: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    onSelected: (selected) {
                      setState(() {
                        if (isPrimary) {
                          // keep
                        } else if (_primaryCareerDirection.isEmpty) {
                          _primaryCareerDirection = role;
                        } else {
                          _primaryCareerDirection = role;
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ),
    );
  }

  // --- Step 4: Interest Areas ---
  Widget _buildStep4InterestAreas(
      bool isDark, Color cardBg, Color textPrimary, Color textSecondary) {
    final areas = [
      'Programming',
      'Data Structures & Algorithms',
      'Web Development',
      'Mobile Development',
      'AI',
      'Machine Learning',
      'Deep Learning',
      'Generative AI',
      'Data Science',
      'Data Engineering',
      'Cybersecurity',
      'Ethical Hacking',
      'Cloud Computing',
      'DevOps',
      'Networking',
      'Operating Systems',
      'Databases',
      'Software Engineering',
      'Embedded Systems',
      'IoT',
      'UI/UX',
      'Open Source',
      'Competitive Programming',
    ];

    return _WizardStepLayout(
      title: 'Interest Areas',
      subtitle: 'What technical domains are you most excited to master?',
      icon: Icons.interests_rounded,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: areas.map((area) {
          final isSelected = _interestAreas.contains(area);
          return _FilterChipCard(
            label: area,
            isSelected: isSelected,
            isDark: isDark,
            onTap: () {
              setState(() {
                if (isSelected) {
                  _interestAreas.remove(area);
                } else {
                  _interestAreas.add(area);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  // --- Step 5: Overall Skill Level ---
  Widget _buildStep5SkillLevel(
      bool isDark, Color cardBg, Color textPrimary, Color textSecondary) {
    return _WizardStepLayout(
      title: 'Overall Skill Level',
      subtitle:
          'How would you rate your current overall computer science & coding proficiency?',
      icon: Icons.trending_up_rounded,
      child: Column(
        children: SkillLevel.values.map((level) {
          final isSelected = _overallSkillLevel == level;
          return _SelectableCard(
            title: level.displayName,
            subtitle: _getSkillLevelDescription(level),
            icon: Icons.bolt_rounded,
            isSelected: isSelected,
            isDark: isDark,
            onTap: () {
              setState(() {
                _overallSkillLevel = level;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  // --- Step 6: Programming Languages ---
  Widget _buildStep6ProgrammingLanguages(
      bool isDark, Color cardBg, Color textPrimary, Color textSecondary) {
    final availableLangs = [
      'Python',
      'C++',
      'Java',
      'C',
      'JavaScript',
      'TypeScript',
      'Dart',
      'Go',
      'Rust',
      'SQL',
    ];

    return _WizardStepLayout(
      title: 'Programming Languages',
      subtitle:
          'Select languages you know or want to use. Pick your primary language.',
      icon: Icons.code_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Primary Language (Selected: $_primaryLanguage)',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableLangs.map((lang) {
              final isPrimary = _primaryLanguage == lang;
              return ChoiceChip(
                label: Text(
                  isPrimary ? '★ $lang (Primary)' : lang,
                  style: GoogleFonts.inter(
                    fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
                    color: isPrimary ? Colors.white : textPrimary,
                  ),
                ),
                selected: isPrimary,
                selectedColor: const Color(0xFF2563EB),
                backgroundColor:
                    isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                onSelected: (selected) {
                  setState(() {
                    _primaryLanguage = lang;
                    if (!_programmingLanguages.contains(lang)) {
                      _programmingLanguages.add(lang);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text(
            'Other Languages Known / Practiced:',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                availableLangs.where((l) => l != _primaryLanguage).map((lang) {
              final isKnown = _programmingLanguages.contains(lang);
              return _FilterChipCard(
                label: lang,
                isSelected: isKnown,
                isDark: isDark,
                onTap: () {
                  setState(() {
                    if (isKnown) {
                      _programmingLanguages.remove(lang);
                    } else {
                      _programmingLanguages.add(lang);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- Step 7: Core CS / DSA Skills ---
  Widget _buildStep7CoreCsSkills(
      bool isDark, Color cardBg, Color textPrimary, Color textSecondary) {
    final coreSubjects = [
      {'key': 'dsa', 'title': 'Data Structures & Algorithms (DSA)'},
      {'key': 'dbms', 'title': 'Database Management Systems (DBMS)'},
      {'key': 'os', 'title': 'Operating Systems (OS)'},
      {'key': 'cn', 'title': 'Computer Networks (CN)'},
      {'key': 'oop', 'title': 'Object-Oriented Programming (OOP)'},
    ];

    return _WizardStepLayout(
      title: 'Core CS & DSA Assessment',
      subtitle:
          'Rate your familiarity with fundamental Computer Science pillars.',
      icon: Icons.account_tree_rounded,
      child: Column(
        children: coreSubjects.map((sub) {
          final key = sub['key']!;
          final title = sub['title']!;
          final currentLevel = _skillLevels[key] ?? SkillLevel.beginner;

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color:
                    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: textPrimary)),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SkillLevel.beginner,
                      SkillLevel.basic,
                      SkillLevel.intermediate,
                      SkillLevel.advanced,
                    ].map((lvl) {
                      final isSelected = currentLevel == lvl;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: ChoiceChip(
                          label: Text(
                            lvl.displayName,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isSelected ? Colors.white : textPrimary,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF2563EB),
                          backgroundColor: isDark
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFF8FAFC),
                          onSelected: (selected) {
                            setState(() {
                              _skillLevels[key] = lvl;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Step 8: Domain Experience (Conditional) ---
  Widget _buildStep8DomainExperience(
      bool isDark, Color cardBg, Color textPrimary, Color textSecondary) {
    final isAi = _primaryCareerDirection.contains('AI') ||
        _primaryCareerDirection.contains('Machine Learning') ||
        _interestAreas.contains('AI');
    final isWeb = _primaryCareerDirection.contains('Web') ||
        _primaryCareerDirection.contains('Full Stack') ||
        _interestAreas.contains('Web Development');
    final isSecurity = _primaryCareerDirection.contains('Cyber') ||
        _primaryCareerDirection.contains('Security') ||
        _interestAreas.contains('Cybersecurity');
    final isCloud = _primaryCareerDirection.contains('Cloud') ||
        _primaryCareerDirection.contains('DevOps') ||
        _interestAreas.contains('Cloud Computing');

    return _WizardStepLayout(
      title: 'Domain Experience Check',
      subtitle: 'Tailored questions based on your chosen career direction.',
      icon: Icons.tune_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isAi)
            _buildDomainRatingCard(
              title: 'AI / Machine Learning Experience',
              description:
                  'Familiarity with Python libraries (NumPy, Pandas, Scikit-learn, PyTorch)',
              current: _aiExperience,
              isDark: isDark,
              cardBg: cardBg,
              textPrimary: textPrimary,
              onChanged: (val) => setState(() => _aiExperience = val),
            ),
          if (isWeb)
            _buildDomainRatingCard(
              title: 'Web Development Experience',
              description:
                  'Frontend frameworks (React, HTML/CSS) and backend APIs',
              current: _webExperience,
              isDark: isDark,
              cardBg: cardBg,
              textPrimary: textPrimary,
              onChanged: (val) => setState(() => _webExperience = val),
            ),
          if (isSecurity)
            _buildDomainRatingCard(
              title: 'Cybersecurity & Linux Exposure',
              description:
                  'Linux command line, networking protocols, security fundamentals',
              current: _securityExperience,
              isDark: isDark,
              cardBg: cardBg,
              textPrimary: textPrimary,
              onChanged: (val) => setState(() => _securityExperience = val),
            ),
          if (isCloud)
            _buildDomainRatingCard(
              title: 'Cloud & DevOps Tooling',
              description: 'Docker, CI/CD pipelines, AWS/GCP services',
              current: _cloudExperience,
              isDark: isDark,
              cardBg: cardBg,
              textPrimary: textPrimary,
              onChanged: (val) => setState(() => _cloudExperience = val),
            ),
          if (!isAi && !isWeb && !isSecurity && !isCloud)
            _buildDomainRatingCard(
              title: 'Software Engineering & Git Version Control',
              description: 'Git branching, clean code practices, testing',
              current: 'Intermediate',
              isDark: isDark,
              cardBg: cardBg,
              textPrimary: textPrimary,
              onChanged: (val) {},
            ),
        ],
      ),
    );
  }

  Widget _buildDomainRatingCard({
    required String title,
    required String description,
    required String current,
    required bool isDark,
    required Color cardBg,
    required Color textPrimary,
    required Function(String) onChanged,
  }) {
    final levels = ['None / Beginner', 'Basic', 'Intermediate', 'Experienced'];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: textPrimary)),
          const SizedBox(height: 4),
          Text(description,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B))),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: levels.map((lvl) {
              final isSel = current == lvl;
              return ChoiceChip(
                label: Text(lvl,
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isSel ? Colors.white : textPrimary)),
                selected: isSel,
                selectedColor: const Color(0xFF2563EB),
                backgroundColor:
                    isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                onSelected: (s) => onChanged(lvl),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- Step 9: Practical Experience ---
  Widget _buildStep9PracticalExperience(
      bool isDark, Color cardBg, Color textPrimary, Color textSecondary) {
    return _WizardStepLayout(
      title: 'Practical Experience',
      subtitle: 'Tell us about your hands-on coding and project portfolio.',
      icon: Icons.developer_mode_rounded,
      child: Column(
        children: [
          _buildExperienceGroup(
            title: 'Project Portfolio',
            options: [
              'No projects',
              'Academic projects only',
              '1 personal project',
              '2–3 personal projects',
              'Multiple production projects'
            ],
            selected: _projectExperience,
            onSelected: (val) => setState(() => _projectExperience = val),
            isDark: isDark,
            textPrimary: textPrimary,
          ),
          const SizedBox(height: 16),
          _buildExperienceGroup(
            title: 'Internship Status',
            options: [
              'No internship yet',
              'Looking for internship',
              'Currently doing internship',
              'Internship completed'
            ],
            selected: _internshipStatus,
            onSelected: (val) => setState(() => _internshipStatus = val),
            isDark: isDark,
            textPrimary: textPrimary,
          ),
          const SizedBox(height: 16),
          _buildExperienceGroup(
            title: 'Open Source Experience',
            options: [
              'Never contributed',
              'Interested',
              'Beginner contributor',
              'Regular contributor'
            ],
            selected: _openSourceExperience,
            onSelected: (val) => setState(() => _openSourceExperience = val),
            isDark: isDark,
            textPrimary: textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceGroup({
    required String title,
    required List<String> options,
    required String selected,
    required Function(String) onSelected,
    required bool isDark,
    required Color textPrimary,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSel = selected == opt;
            return ChoiceChip(
              label: Text(opt,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: isSel ? Colors.white : textPrimary)),
              selected: isSel,
              selectedColor: const Color(0xFF2563EB),
              backgroundColor:
                  isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              onSelected: (s) => onSelected(opt),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- Step 10: Strengths ---
  Widget _buildStep10Strengths(
      bool isDark, Color cardBg, Color textPrimary, Color textSecondary) {
    final strengthOptions = [
      'Programming',
      'Mathematics',
      'Problem Solving',
      'Communication',
      'Academics',
      'Projects',
      'Technical Knowledge',
      'Creativity',
      'Leadership',
      'Fast Learner',
    ];

    return _WizardStepLayout(
      title: 'Your Strengths',
      subtitle: 'Select the skills where you feel most confident.',
      icon: Icons.star_rounded,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: strengthOptions.map((s) {
          final isSel = _strengths.contains(s);
          return _FilterChipCard(
            label: s,
            isSelected: isSel,
            isDark: isDark,
            onTap: () {
              setState(() {
                if (isSel) {
                  _strengths.remove(s);
                } else {
                  _strengths.add(s);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  // --- Step 11: Weaknesses / Improvement Areas ---
  Widget _buildStep11Weaknesses(
      bool isDark, Color cardBg, Color textPrimary, Color textSecondary) {
    final weaknessOptions = [
      'DSA',
      'Mathematics',
      'Coding Consistency',
      'Communication',
      'Aptitude',
      'Technical Interviews',
      'Projects',
      'CS Fundamentals',
      'Time Management',
      'Confidence',
    ];

    return _WizardStepLayout(
      title: 'What would you like to improve?',
      subtitle:
          'Your roadmap will prioritize guided practice for these focus areas.',
      icon: Icons.build_circle_rounded,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: weaknessOptions.map((w) {
          final isSel = _weaknesses.contains(w);
          return _FilterChipCard(
            label: w,
            isSelected: isSel,
            isDark: isDark,
            onTap: () {
              setState(() {
                if (isSel) {
                  _weaknesses.remove(w);
                } else {
                  _weaknesses.add(w);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  // --- Step 12: Learning Style ---
  Widget _buildStep12LearningStyle(
      bool isDark, Color cardBg, Color textPrimary, Color textSecondary) {
    return _WizardStepLayout(
      title: 'Learning Style Preference',
      subtitle: 'How do you learn technical concepts most effectively?',
      icon: Icons.menu_book_rounded,
      child: Column(
        children: LearningStyle.values.map((style) {
          final isSel = _learningStyle == style;
          return _SelectableCard(
            title: style.displayName,
            subtitle: style.description,
            icon: Icons.auto_stories_rounded,
            isSelected: isSel,
            isDark: isDark,
            onTap: () {
              setState(() {
                _learningStyle = style;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  // --- Step 13: Time Availability ---
  Widget _buildStep13TimeAvailability(
      bool isDark, Color cardBg, Color textPrimary, Color textSecondary) {
    final timeOptions = [
      {
        'min': 30,
        'label': '30 minutes / day',
        'desc': 'Light pace • Micro-learning daily'
      },
      {
        'min': 60,
        'label': '1 hour / day',
        'desc': 'Standard pace • Consistent progress'
      },
      {
        'min': 120,
        'label': '2 hours / day',
        'desc': 'Accelerated pace • Solid project building'
      },
      {
        'min': 180,
        'label': '3 hours / day',
        'desc': 'Intensive pace • Rapid mastery'
      },
      {
        'min': 240,
        'label': '4+ hours / day',
        'desc': 'Bootcamp pace • Placement sprint'
      },
    ];

    return _WizardStepLayout(
      title: 'Time Availability',
      subtitle: 'How much time can you realistically invest in learning?',
      icon: Icons.schedule_rounded,
      child: Column(
        children: timeOptions.map((opt) {
          final minutes = opt['min'] as int;
          final isSel = _dailyLearningTimeMinutes == minutes;
          return _SelectableCard(
            title: opt['label'] as String,
            subtitle: opt['desc'] as String,
            icon: Icons.timer_outlined,
            isSelected: isSel,
            isDark: isDark,
            onTap: () {
              setState(() {
                _dailyLearningTimeMinutes = minutes;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  // --- Step 14: Timeline & Target Organizations ---
  Widget _buildStep14TimelineAndGoals(
      bool isDark, Color cardBg, Color textPrimary, Color textSecondary) {
    final timelines = [
      '1 month',
      '3 months',
      '6 months',
      '9 months',
      '1 year',
      '2 years',
      'Until graduation'
    ];
    final orgTypes = [
      'Product-based companies',
      'Service-based companies',
      'Startups',
      'Big Tech',
      'Government / PSU',
      'Research institutions',
      'Freelancing',
    ];

    final isPlacementGoal =
        _goals.contains('Placement') || _goals.contains('Internship');
    final placementTopics = [
      'Aptitude',
      'Logical Reasoning',
      'Verbal Ability',
      'DSA',
      'Coding Interviews',
      'Technical Interviews',
      'OOP',
      'DBMS',
      'Operating Systems',
      'Computer Networks',
      'System Design',
      'HR Interviews',
      'Resume',
      'Mock Interviews',
    ];

    return _WizardStepLayout(
      title: 'Target Timeline & Goals',
      subtitle: 'Set your horizon and company preferences.',
      icon: Icons.event_available_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Target Timeline:',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: textPrimary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: timelines.map((t) {
              final isSel = _targetTimeline == t;
              return ChoiceChip(
                label: Text(t,
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isSel ? Colors.white : textPrimary)),
                selected: isSel,
                selectedColor: const Color(0xFF2563EB),
                backgroundColor:
                    isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                onSelected: (s) => setState(() => _targetTimeline = t),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text('Target Organization Types:',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: textPrimary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: orgTypes.map((org) {
              final isSel = _targetOrganizationTypes.contains(org);
              return _FilterChipCard(
                label: org,
                isSelected: isSel,
                isDark: isDark,
                onTap: () {
                  setState(() {
                    if (isSel) {
                      _targetOrganizationTypes.remove(org);
                    } else {
                      _targetOrganizationTypes.add(org);
                    }
                  });
                },
              );
            }).toList(),
          ),
          if (isPlacementGoal) ...[
            const SizedBox(height: 20),
            Text('Placement Prep Focus Areas:',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: textPrimary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: placementTopics.map((pt) {
                final isSel = _placementPreparationAreas.contains(pt);
                return _FilterChipCard(
                  label: pt,
                  isSelected: isSel,
                  isDark: isDark,
                  onTap: () {
                    setState(() {
                      if (isSel) {
                        _placementPreparationAreas.remove(pt);
                      } else {
                        _placementPreparationAreas.add(pt);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // --- Step 15: Final Review ---
  Widget _buildStep15FinalReview(
      bool isDark, Color cardBg, Color textPrimary, Color textSecondary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF2563EB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_user_rounded,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review Your Profile',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: textPrimary),
                    ),
                    Text(
                      'Verify your selections before generating your personalized roadmap.',
                      style:
                          GoogleFonts.inter(fontSize: 12, color: textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildReviewSection('Academic Stage', _academicStage.displayName, 0,
              isDark, cardBg, textPrimary),
          _buildReviewSection('Primary Goal(s)', _goals.join(', '), 1, isDark,
              cardBg, textPrimary),
          _buildReviewSection('Target Career', _primaryCareerDirection, 2,
              isDark, cardBg, textPrimary),
          _buildReviewSection('Interest Areas', _interestAreas.join(', '), 3,
              isDark, cardBg, textPrimary),
          _buildReviewSection(
              'Primary Language',
              '$_primaryLanguage (${_overallSkillLevel.displayName})',
              5,
              isDark,
              cardBg,
              textPrimary),
          _buildReviewSection(
              'Daily Commitment',
              '${_dailyLearningTimeMinutes ~/ 60}h (${_dailyLearningTimeMinutes}m) / day',
              12,
              isDark,
              cardBg,
              textPrimary),
          _buildReviewSection('Target Timeline', _targetTimeline, 13, isDark,
              cardBg, textPrimary),
          _buildReviewSection('Learning Style', _learningStyle.displayName, 11,
              isDark, cardBg, textPrimary),
          _buildReviewSection('Improvement Areas', _weaknesses.join(', '), 10,
              isDark, cardBg, textPrimary),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isDark
                      ? const Color(0xFF4338CA)
                      : const Color(0xFFBFDBFE)),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome_rounded,
                    color: Color(0xFF2563EB), size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'UniDocs will synthesize these selections into a phased, prerequisite-aware roadmap with direct academic and hub links.',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark ? Colors.white : const Color(0xFF1E3A8A)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection(
    String title,
    String value,
    int stepIndex,
    bool isDark,
    Color cardBg,
    Color textPrimary,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B))),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? 'None' : value,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined,
                size: 18, color: Color(0xFF2563EB)),
            tooltip: 'Edit $title',
            onPressed: () => _goToStep(stepIndex),
          ),
        ],
      ),
    );
  }

  // --- Bottom Navigation Bar ---
  Widget _buildBottomNavigation(bool isDark, Color royalBlue) {
    final isLastStep = _currentStep == _totalSteps - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          top: BorderSide(
              color:
                  isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            OutlinedButton.icon(
              onPressed: _prevStep,
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: Text('Back',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: isLastStep ? _submitProfile : _nextStep,
            icon: Icon(
                isLastStep
                    ? Icons.auto_awesome_rounded
                    : Icons.arrow_forward_rounded,
                size: 18),
            label: Text(
              isLastStep ? 'Generate My Personalized Roadmap' : 'Next',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isLastStep ? AppColors.primary : royalBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  // --- Helpers ---
  IconData _getAcademicIcon(AcademicStage stage) {
    switch (stage) {
      case AcademicStage.firstYear:
      case AcademicStage.secondYear:
      case AcademicStage.thirdYear:
      case AcademicStage.fourthYear:
        return Icons.school_rounded;
      case AcademicStage.graduate:
        return Icons.workspace_premium_rounded;
      case AcademicStage.workingProfessional:
        return Icons.business_center_rounded;
      case AcademicStage.other:
        return Icons.person_rounded;
    }
  }

  String _getAcademicSubtitle(AcademicStage stage) {
    switch (stage) {
      case AcademicStage.firstYear:
        return 'Building core coding fundamentals & foundation';
      case AcademicStage.secondYear:
        return 'Core CS subjects, DSA, and initial personal projects';
      case AcademicStage.thirdYear:
        return 'Advanced tech stack, internships, and placement prep';
      case AcademicStage.fourthYear:
        return 'Final year placement drives, capstone & career launch';
      case AcademicStage.graduate:
        return 'Postgraduate, gate preparation, or job hunting';
      case AcademicStage.workingProfessional:
        return 'Upskilling or switching domains to AI / Cloud';
      case AcademicStage.other:
        return 'Self-taught learner or non-traditional background';
    }
  }

  String _getSkillLevelDescription(SkillLevel level) {
    switch (level) {
      case SkillLevel.completeBeginner:
        return 'New to programming, haven\'t written much code yet.';
      case SkillLevel.beginner:
        return 'Know basics of one language, can write simple loops/conditions.';
      case SkillLevel.basic:
        return 'Comfortable with OOP, basic data structures (arrays/strings).';
      case SkillLevel.intermediate:
        return 'Solved multiple DSA problems, built 1–2 practical projects.';
      case SkillLevel.advanced:
        return 'Strong in complex DSA, architecture, and production tooling.';
    }
  }
}

// --- Reusable Layout & Card Widgets ---

class _WizardStepLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const _WizardStepLayout({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF2563EB), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: textPrimary),
                    ),
                    Text(
                      subtitle,
                      style:
                          GoogleFonts.inter(fontSize: 12, color: textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _SelectableCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _SelectableCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const royalBlue = Color(0xFF2563EB);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? const Color(0xFF1E3A8A).withAlpha(120)
                  : const Color(0xFFEFF6FF))
              : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? royalBlue
                : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? royalBlue
                    : (isDark
                        ? const Color(0xFF0F172A)
                        : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  size: 20,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white70 : const Color(0xFF475569))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 14,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: royalBlue, size: 22),
          ],
        ),
      ),
    );
  }
}

class _FilterChipCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterChipCard({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const royalBlue = Color(0xFF2563EB);

    return FilterChip(
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Colors.white
              : (isDark ? Colors.white : const Color(0xFF0F172A)),
        ),
      ),
      selected: isSelected,
      selectedColor: royalBlue,
      checkmarkColor: Colors.white,
      backgroundColor:
          isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
      side: BorderSide(
        color: isSelected
            ? royalBlue
            : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (val) => onTap(),
    );
  }
}
