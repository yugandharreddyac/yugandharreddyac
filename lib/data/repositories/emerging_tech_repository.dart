import '../datasources/firebase_datasource.dart';
import '../models/beyond_academics_model.dart';

class EmergingTechRepository {
  final FirebaseDataSource firebaseDataSource;

  EmergingTechRepository({required this.firebaseDataSource});

  Future<List<EmergingTechDetailModel>> getEmergingTechs() async {
    try {
      final data = await firebaseDataSource.getEmergingTechs();
      if (data.isNotEmpty) {
        return data.map((json) => EmergingTechDetailModel.fromJson(json)).toList();
      }
    } catch (_) {}

    return _getFallbackData();
  }

  Future<List<EmergingTechDetailModel>> getEmergingTechDetails() async {
    return _getFallbackData();
  }

  List<EmergingTechDetailModel> _getFallbackData() {
    return const [
      EmergingTechDetailModel(
        id: 'genai',
        title: 'Generative AI & LLMs',
        category: 'Artificial Intelligence',
        icon: 'psychology_rounded',
        overview: 'Transformers, Large Language Models, RAG, and AI agents.',
        whyItMatters: 'Revolutionizing software development and automation.',
        prerequisites: ['Python Programming', 'Linear Algebra', 'Deep Learning Basics'],
        coreConcepts: ['Self-Attention', 'RAG', 'Vector DBs'],
        futureDirection: 'Autonomous Multi-Agent AI Workflows',
      ),
      EmergingTechDetailModel(
        id: 'cloud_devops',
        title: 'Cloud Native & DevOps',
        category: 'Infrastructure & Cloud',
        icon: 'cloud_rounded',
        overview: 'Docker containerization, Kubernetes orchestration, and CI/CD pipelines.',
        whyItMatters: 'Standard infrastructure stack for modern microservices.',
        prerequisites: ['Linux Commands', 'Networking Basics', 'Shell Scripting'],
        coreConcepts: ['Containers', 'Kubernetes Pods', 'CI/CD Pipelines'],
        futureDirection: 'GitOps & Platform Engineering',
      ),
    ];
  }
}
