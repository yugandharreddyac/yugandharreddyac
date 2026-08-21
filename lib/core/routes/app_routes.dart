import 'package:flutter/material.dart';
import '../../data/models/resource_model.dart';
import '../../data/models/textbook_model.dart';
import '../../data/models/personalized_roadmap_models.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/years/year_screen.dart';
import '../../presentation/screens/semesters/semester_screen.dart';
import '../../presentation/screens/subjects/subject_screen.dart';
import '../../presentation/screens/resources/resource_screen.dart';
import '../../presentation/screens/topic/topic_detail_screen.dart';
import '../../presentation/screens/pdf_viewer/pdf_viewer_screen.dart';
import '../../presentation/screens/search/search_screen.dart';
import '../../presentation/screens/bookmarks/bookmarks_screen.dart';
import '../../presentation/screens/downloads/downloads_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/legal/privacy_policy_screen.dart';
import '../../presentation/screens/legal/about_screen.dart';
import '../../presentation/screens/legal/contact_screen.dart';
import '../../presentation/screens/admin/admin_upload_screen.dart';
import '../../presentation/screens/admin/admin_dashboard_screen.dart';
import '../../presentation/screens/admin/admin_textbook_screen.dart';
import '../../presentation/screens/admin/archive_upload_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/signup_screen.dart';
import '../../presentation/screens/admin/admin_login_screen.dart';
import '../../presentation/widgets/admin_auth_guard.dart';
import '../../data/datasources/non_academic_data.dart';
import '../../presentation/screens/hierarchy/generic_hub_screen.dart';

import '../../presentation/screens/roadmap/my_roadmap_screen.dart';
import '../../presentation/screens/roadmap/roadmap_onboarding_screen.dart';
import '../../presentation/screens/roadmap/wizard/personalized_wizard_screen.dart';

import '../../presentation/screens/saved/saved_topics_screen.dart';
import '../../presentation/screens/insights/student_insights_screen.dart';
import '../../presentation/screens/career/career_dashboard_screen.dart';
import '../../presentation/screens/career/career_skills_screen.dart';
import '../../presentation/screens/career/project_portfolio_screen.dart';
import '../../presentation/screens/career/resume_readiness_screen.dart';
import '../../presentation/screens/placement/quiz/quiz_hub_screen.dart';
import '../../presentation/screens/ai/unidocs_ai_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String years = '/years';
  static const String semesters = '/semesters';
  static const String subjects = '/subjects';
  static const String resources = '/resources';
  static const String pdfViewer = '/pdf_viewer';
  static const String search = '/search';
  static const String bookmarks = '/bookmarks';
  static const String downloads = '/downloads';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String privacyPolicy = '/privacy_policy';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String adminLogin = '/admin-login';
  static const String adminDashboard = '/admin-dashboard';
  static const String adminUpload = '/admin-upload';
  static const String archiveUpload = '/archive-upload';
  static const String adminTextbook = '/admin-textbook';
  static const String careerHub = '/career';
  static const String codingHub = '/coding';
  static const String placementHub = '/placement';
  static const String quizHub = '/placement/quiz';
  static const String projectHub = '/projects';
  static const String higherEducationHub = '/higher-education';
  static const String entrepreneurshipHub = '/entrepreneurship';
  static const String roadmap = '/roadmap';
  static const String roadmapOnboarding = '/roadmap-onboarding';
  static const String personalizedWizard = '/roadmap/personalized-wizard';
  static const String savedTopics = '/saved';
  static const String insights = '/insights';
  static const String examDetail = '/exam-detail';
  static const String topicDetail = '/topic_detail';

  // Phase 5 Career Routes
  static const String careerDashboard = '/career-dashboard';
  static const String careerSkills = '/career-skills';
  static const String projectPortfolio = '/project-portfolio';
  static const String resumeReadiness = '/resume-readiness';
  static const String ai = '/ai';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return _buildPageRoute(const SplashScreen(), routeSettings);

      case login:
        return _buildPageRoute(const LoginScreen(), routeSettings);

      case signup:
        return _buildPageRoute(const SignUpScreen(), routeSettings);

      case home:
        return _buildPageRoute(const HomeScreen(), routeSettings);

      case years:
        return _buildPageRoute(const YearScreen(), routeSettings);

      case semesters:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        if (args == null || args['yearId'] == null) {
          return _buildPageRoute(const HomeScreen(), routeSettings);
        }
        return _buildPageRoute(
          SemesterScreen(
            yearId: args['yearId']!,
            yearTitle: args['yearTitle'] ?? 'Academic Semesters',
          ),
          routeSettings,
        );

      case subjects:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        return _buildPageRoute(
          SubjectScreen(
            semesterId: args['semesterId'] ?? 'sem_1',
            semesterTitle: args['semesterTitle'] ?? '1-1 Semester',
          ),
          routeSettings,
        );

      case resources:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        return _buildPageRoute(
          ResourceScreen(
            subjectId: args['subjectId'] ?? '',
            subjectName: args['subjectName'] ?? 'Subject',
            initialSectionIndex: args['initialSectionIndex'] as int?,
          ),
          routeSettings,
        );

      case pdfViewer:
        final resource = routeSettings.arguments is ResourceModel
            ? routeSettings.arguments as ResourceModel
            : null;
        if (resource == null) {
          return _buildPageRoute(const HomeScreen(), routeSettings);
        }
        return _buildPageRoute(
            PdfViewerScreen(resource: resource), routeSettings);

      case search:
        return _buildPageRoute(const SearchScreen(), routeSettings);

      case bookmarks:
        return _buildPageRoute(const BookmarksScreen(), routeSettings);

      case downloads:
        return _buildPageRoute(const DownloadsScreen(), routeSettings);

      case profile:
        return _buildPageRoute(const ProfileScreen(), routeSettings);

      case settings:
        return _buildPageRoute(const SettingsScreen(), routeSettings);

      case privacyPolicy:
        return _buildPageRoute(const PrivacyPolicyScreen(), routeSettings);

      case about:
        return _buildPageRoute(const AboutScreen(), routeSettings);

      case contact:
        return _buildPageRoute(const ContactScreen(), routeSettings);

      case adminLogin:
        return _buildPageRoute(const AdminLoginScreen(), routeSettings);

      case adminDashboard:
        return _buildPageRoute(
          const AdminAuthGuard(child: AdminDashboardScreen()),
          routeSettings,
        );

      case adminUpload:
        return _buildPageRoute(
          const AdminAuthGuard(child: AdminUploadScreen()),
          routeSettings,
        );

      case archiveUpload:
        return _buildPageRoute(
          const ArchiveUploadScreen(),
          routeSettings,
        );

      case adminTextbook:
        return _buildPageRoute(
          const AdminAuthGuard(child: AdminTextbookScreen()),
          routeSettings,
        );

      case careerHub:
        return _buildPageRoute(
            const GenericHubScreen(hub: NonAcademicData.emergingTechHub),
            routeSettings);

      case codingHub:
        return _buildPageRoute(
            const GenericHubScreen(hub: NonAcademicData.codingHub),
            routeSettings);

      case placementHub:
        return _buildPageRoute(
            const GenericHubScreen(hub: NonAcademicData.placementHub),
            routeSettings);

      case quizHub:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return _buildPageRoute(
          QuizHubScreen(initialCategory: args?['category'] as String?),
          routeSettings,
        );

      case projectHub:
        return _buildPageRoute(
            const GenericHubScreen(hub: NonAcademicData.projectsHub),
            routeSettings);

      case higherEducationHub:
        return _buildPageRoute(
            const GenericHubScreen(hub: NonAcademicData.higherEducationHub),
            routeSettings);

      case entrepreneurshipHub:
        return _buildPageRoute(
            const GenericHubScreen(hub: NonAcademicData.entrepreneurshipHub),
            routeSettings);

      case topicDetail:
        final args = routeSettings.arguments is Map<String, dynamic>
            ? routeSettings.arguments as Map<String, dynamic>
            : null;
        if (args == null ||
            args['topic'] == null ||
            args['topic'] is! TextbookTopicModel) {
          return _buildPageRoute(const HomeScreen(), routeSettings);
        }
        return _buildPageRoute(
          TopicDetailScreen(
            topic: args['topic'] as TextbookTopicModel,
            subjectName: args['subjectName'] as String? ?? 'Subject',
            chapterTitle: args['chapterTitle'] as String? ?? 'Chapter',
            sectionTitle: args['sectionTitle'] as String? ?? 'Section',
          ),
          routeSettings,
        );

      case roadmap:
        return _buildPageRoute(const MyRoadmapScreen(), routeSettings);

      case roadmapOnboarding:
        return _buildPageRoute(const RoadmapOnboardingScreen(), routeSettings);

      case personalizedWizard:
        final initialProfile = routeSettings.arguments is PersonalizedProfile
            ? routeSettings.arguments as PersonalizedProfile
            : null;
        return _buildPageRoute(
            PersonalizedWizardScreen(initialProfile: initialProfile),
            routeSettings);

      case savedTopics:
        return _buildPageRoute(const SavedTopicsScreen(), routeSettings);

      case insights:
        return _buildPageRoute(const StudentInsightsScreen(), routeSettings);

      // Phase 5 Career Screens
      case careerDashboard:
        return _buildPageRoute(const CareerDashboardScreen(), routeSettings);

      case careerSkills:
        return _buildPageRoute(const CareerSkillsScreen(), routeSettings);

      case projectPortfolio:
        return _buildPageRoute(const ProjectPortfolioScreen(), routeSettings);

      case resumeReadiness:
        return _buildPageRoute(const ResumeReadinessScreen(), routeSettings);

      case ai:
        final args = routeSettings.arguments;
        Map<String, dynamic>? initialContext;
        String? initialPrompt;
        if (args is Map<String, dynamic>) {
          initialContext = args['context'] as Map<String, dynamic>? ?? args;
          initialPrompt = args['prompt'] as String?;
        } else if (args is String) {
          initialPrompt = args;
        }
        return _buildPageRoute(
          UniDocsAiScreen(
            initialContext: initialContext,
            initialPrompt: initialPrompt,
          ),
          routeSettings,
        );

      default:
        return _buildPageRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for ${routeSettings.name}'),
            ),
          ),
          routeSettings,
        );
    }
  }

  static PageRouteBuilder _buildPageRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.05, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final fadeTween =
            Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
