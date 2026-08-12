import '../models/textbook_model.dart';

class TextbookMockData {
  TextbookMockData._();

  static CourseOverviewModel getCourseOverview(String subjectId) {
    switch (subjectId) {
      case 'sub_ai':
      case 'ai':
      case 'subj_3_1_4':
        return CourseOverviewModel(
          subjectId: subjectId,
          subjectName: 'Artificial Intelligence',
          description:
              'Comprehensive study of intelligent agents, state-space search algorithms, knowledge representation, automated reasoning, machine learning foundations, and modern AI architectures.',
          whyItMatters:
              'Artificial Intelligence is the defining paradigm of 21st-century computing, enabling autonomous decision-making, natural language understanding, robotics, and intelligent automation.',
          prerequisites: [
            'Basic Programming in C/Python',
            'Data Structures & Algorithms (Trees, Graphs, Queues)',
            'Probability & Discrete Mathematics',
            'Linear Algebra Basics'
          ],
          learningObjectives: [
            'Understand agent-based architecture and state-space problem formulation.',
            'Master uninformed and informed search algorithms (BFS, DFS, A*, Minimax).',
            'Formulate knowledge using First-Order Logic and Propositional Logic.',
            'Implement probabilistic reasoning and Machine Learning foundations.'
          ],
          learningOutcomes: [
            'Formulate complex real-world problems as state-space search tasks.',
            'Implement optimal search strategies and adversarial game-tree evaluation.',
            'Build knowledge-based inference engines and automated reasoning systems.',
            'Apply Machine Learning and Deep Learning principles to practical tasks.'
          ],
          estimatedStudyTime: '55 Study Hours',
          estimatedDifficulty: 'Intermediate to Advanced',
        );

      case 'sub_ds':
      case 'ds':
      case 'subj_1_2_3':
        return CourseOverviewModel(
          subjectId: subjectId,
          subjectName: 'Data Structures & Algorithms',
          description:
              'Foundational study of linear and non-linear data organizations (Arrays, Stacks, Queues, Linked Lists, Trees, Graphs, Hash Tables) and algorithm complexity analysis.',
          whyItMatters:
              'Data structures form the architectural core of efficient software design, database indexing, operating systems memory management, and technical interview success.',
          prerequisites: ['Programming in C / C++', 'Basic Mathematics & Recursion'],
          learningObjectives: [
            'Analyze Big-O time and space complexity.',
            'Implement linear data structures (Lists, Stacks, Queues).',
            'Master tree traversals, AVL self-balancing, and Binary Search Trees.',
            'Implement graph traversals (BFS, DFS, Dijkstra, Prim).'
          ],
          learningOutcomes: [
            'Select optimal data structures for memory and execution performance.',
            'Write error-free recursive and iterative algorithmic solutions.',
            'Implement dynamic memory management and hash collisions.'
          ],
          estimatedStudyTime: '60 Study Hours',
          estimatedDifficulty: 'Core Foundational',
        );

      default:
        return CourseOverviewModel(
          subjectId: subjectId,
          subjectName: 'Computer Science & Software Engineering',
          description:
              'Comprehensive university syllabus covering core computational principles, software engineering methodologies, data processing, and technical problem-solving.',
          whyItMatters:
              'Forms essential core knowledge for engineering scalable software solutions, passing technical examinations, and advancing in tech careers.',
          prerequisites: ['Basic Computing Principles', 'High School Mathematics'],
          learningObjectives: [
            'Understand foundational theoretical and practical principles.',
            'Apply structured engineering methodologies to solve domain tasks.',
            'Prepare for university semester examinations and lab assessments.'
          ],
          learningOutcomes: [
            'Demonstrate mastery over core subject concepts.',
            'Solve analytical and practical coding tasks effectively.'
          ],
          estimatedStudyTime: '45 Study Hours',
          estimatedDifficulty: 'Intermediate',
        );
    }
  }

  static List<TextbookChapterModel> getTextbookChapters(String subjectId) {
    switch (subjectId) {
      case 'sub_ai':
      case 'ai':
      case 'subj_3_1_4':
        return [
          TextbookChapterModel(
            id: 'ai_ch1',
            subjectId: subjectId,
            chapterNumber: 1,
            title: 'Foundations of Artificial Intelligence & Agents',
            description: 'Introduction to AI definitions, historical evolution, Turing Test, and Rational Agent architectures.',
            order: 1,
            sections: [
              const TextbookSectionModel(
                id: 'ai_sec1_1',
                chapterId: 'ai_ch1',
                sectionNumber: '1.1',
                title: 'What is Artificial Intelligence?',
                description: 'Definitions, four approaches to AI (Thinking Humanly, Thinking Rationally, Acting Humanly, Acting Rationally).',
                order: 1,
                topics: [
                  TextbookTopicModel(
                    id: 'ai_top1_1_1',
                    sectionId: 'ai_sec1_1',
                    topicNumber: '1.1.1',
                    title: 'Definition of AI & Turing Test',
                    definition:
                        'Artificial Intelligence is the field of computer science concerned with building software systems capable of performing tasks that typically require human intelligence, such as reasoning, learning, perception, and decision making.',
                    intuition:
                        'Imagine creating a software agent that can play chess, diagnose medical conditions, or converse like a human expert. Alan Turing proposed a test: if a human interrogator cannot distinguish between responses from a computer and a human, the computer passes the Turing Test.',
                    workingPrinciple:
                        'The Turing Test evaluates natural language processing, knowledge representation, automated reasoning, and machine learning without relying on physical biological replication.',
                    algorithm: 'Turing Test Protocol & Operational Evaluation',
                    pseudocode: '''
PROCEDURE EvaluateTuringTest(interrogator, agentA, agentB):
  REPEAT
    question = interrogator.askQuestion()
    responseA = agentA.respond(question)
    responseB = agentB.respond(question)
    interrogator.reviewResponses(responseA, responseB)
  UNTIL testDurationComplete
  IF interrogator.accuracy < 0.5 THEN
    RETURN "Agent Passed Turing Test (Indistinguishable)"
  ELSE
    RETURN "Agent Failed Turing Test"
END PROCEDURE
''',
                    codeImplementation: '''
def turing_test_evaluation(human_score, ai_score):
    """
    Evaluates whether the AI agent passed the Turing test based on interrogator confidence.
    """
    indistinguishable_ratio = ai_score / (human_score + ai_score)
    if indistinguishable_ratio >= 0.5:
        return "SUCCESS: Agent is indistinguishable from human responses."
    return "FAILURE: Interrogator correctly identified the machine."

print(turing_test_evaluation(45, 55))
''',
                    timeComplexity: 'O(N) where N is number of interrogation questions',
                    spaceComplexity: 'O(M) memory for dialogue history context',
                    advantages: [
                      'Provides operational behavioral test of intelligence',
                      'Avoids philosophical debates about true machine consciousness'
                    ],
                    disadvantages: [
                      'Focuses heavily on human deception rather than rational intelligence',
                      'Does not test physical perceptual capabilities'
                    ],
                    applications: [
                      'Conversational AI Benchmark',
                      'Chatbot Evaluation',
                      'Human-Robot Interaction'
                    ],
                    commonMistakes: [
                      'Confusing Turing Test with physical robot simulation',
                      'Assuming passing Turing Test implies biological consciousness'
                    ],
                    practiceQuestions: [
                      'Explain the four definitions of AI based on thought vs behavior.',
                      'What are the necessary sub-fields of AI required to pass the Turing Test?'
                    ],
                    examQuestions: [
                      'Q1. Define Artificial Intelligence. Discuss the Turing Test with a neat block diagram (10 Marks).',
                      'Q2. Differentiate between Rational Agents and Thinking Humanly approaches (5 Marks).'
                    ],
                    order: 1,
                  ),
                  TextbookTopicModel(
                    id: 'ai_top1_1_2',
                    sectionId: 'ai_sec1_1',
                    topicNumber: '1.1.2',
                    title: 'Rational Agents & Environments',
                    definition:
                        'A Rational Agent is an entity that perceives its environment through sensors and acts upon that environment using actuators to maximize its expected performance measure.',
                    intuition:
                        'A vacuum cleaner robot senses dirt on the floor via infrared sensors and decides whether to suck dirt, move left, or turn off to keep the room clean efficiently.',
                    workingPrinciple:
                        'Represented by the PEAS framework: Performance Measure, Environment, Actuators, Sensors.',
                    algorithm: 'PEAS Specification Framework',
                    pseudocode: '''
STRUCTURE RationalAgent:
  Sensors: list
  Actuators: list
  PerformanceMeasure: metric
  Environment: state
  
  FUNCTION SelectAction(perceptSequence):
    bestAction = NULL
    maxExpectedUtility = -INFINITY
    FOR EACH action IN PossibleActions:
      utility = EvaluateExpectedPerformance(action, perceptSequence)
      IF utility > maxExpectedUtility THEN
        maxExpectedUtility = utility
        bestAction = action
    RETURN bestAction
''',
                    codeImplementation: '''
class VacuumAgent:
    def __init__(self):
        self.location = 'A'
    
    def select_action(self, percept):
        location, status = percept
        if status == 'Dirty':
            return 'Suck'
        elif location == 'A':
            return 'Right'
        elif location == 'B':
            return 'Left'

agent = VacuumAgent()
print(agent.select_action(('A', 'Dirty'))) # Output: Suck
''',
                    timeComplexity: 'O(1) lookup for simple reflex agents',
                    spaceComplexity: 'O(P) memory for percept history sequence',
                    advantages: [
                      'Provides mathematical framework for optimal decision-making',
                      'Applicable across robotics, game AI, and web agents'
                    ],
                    disadvantages: [
                      'Bounded rationality constraints limit perfect rationality in complex real-time worlds'
                    ],
                    applications: [
                      'Autonomous Vehicles',
                      'Automated Trading Bots',
                      'Smart Home Thermostats'
                    ],
                    commonMistakes: [
                      'Confusing Rationality with Omniscience (Rationality relies on expected, not actual outcome)',
                      'Ignoring environment observability properties'
                    ],
                    practiceQuestions: [
                      'Define PEAS for an Automated Taxi Driver.',
                      'Distinguish between Fully Observable and Partially Observable environments.'
                    ],
                    examQuestions: [
                      'Q1. Explain PEAS description for Automated Healthcare Diagnosis System with examples (10 Marks).',
                      'Q2. Classify environments based on observability, determinism, and dynamism (8 Marks).'
                    ],
                    order: 2,
                  ),
                ],
              ),
            ],
          ),
          TextbookChapterModel(
            id: 'ai_ch2',
            subjectId: subjectId,
            chapterNumber: 2,
            title: 'State-Space Search & Problem Solving',
            description: 'Uninformed Search (BFS, DFS, Uniform Cost) and Informed Search Algorithms (Greedy Best-First, A* Search).',
            order: 2,
            sections: [
              const TextbookSectionModel(
                id: 'ai_sec2_1',
                chapterId: 'ai_ch2',
                sectionNumber: '2.1',
                title: 'Uninformed Search Strategies',
                description: 'Search algorithms with no domain heuristic knowledge.',
                order: 1,
                topics: [
                  TextbookTopicModel(
                    id: 'ai_top2_1_1',
                    sectionId: 'ai_sec2_1',
                    topicNumber: '2.1.1',
                    title: 'Breadth First Search (BFS)',
                    definition:
                        'Breadth First Search is an uninformed graph/tree traversal algorithm that expands nodes level by level using a FIFO queue, guaranteeing the shortest path in unweighted graphs.',
                    intuition:
                        'Imagine ripples in a pond expanding outward in concentric circles. BFS visits all immediate neighbors of the start node before moving to nodes two steps away.',
                    workingPrinciple:
                        'Uses a FIFO (First-In-First-Out) queue to store frontier nodes and a visited set to avoid infinite loops in cyclic graphs.',
                    algorithm: 'BFS Graph Traversal Algorithm',
                    pseudocode: '''
PROCEDURE BreadthFirstSearch(graph, startNode, goalNode):
  frontier = CREATE_QUEUE()
  visited = CREATE_SET()
  
  frontier.enqueue(startNode)
  visited.add(startNode)
  
  WHILE NOT frontier.isEmpty():
    currentNode = frontier.dequeue()
    IF currentNode == goalNode THEN
      RETURN "Path Found"
    
    FOR EACH neighbor IN graph.getNeighbors(currentNode):
      IF neighbor NOT IN visited THEN
        visited.add(neighbor)
        frontier.enqueue(neighbor)
        
  RETURN "Goal Not Reachable"
END PROCEDURE
''',
                    codeImplementation: '''
from collections import deque

def breadth_first_search(graph, start, goal):
    queue = deque([start])
    visited = {start}
    parent = {start: None}

    while queue:
        current = queue.popleft()
        if current == goal:
            path = []
            while current:
                path.append(current)
                current = parent[current]
            return path[::-1]

        for neighbor in graph.get(current, []):
            if neighbor not in visited:
                visited.add(neighbor)
                parent[neighbor] = current
                queue.append(neighbor)
    return None

graph = {
    'A': ['B', 'C'],
    'B': ['D', 'E'],
    'C': ['F'],
    'D': [], 'E': ['Goal'], 'F': []
}
print("BFS Path:", breadth_first_search(graph, 'A', 'Goal'))
''',
                    timeComplexity: 'O(b^d) where b is branching factor and d is goal depth',
                    spaceComplexity: 'O(b^d) keeps all nodes in memory frontier queue',
                    advantages: [
                      'Guaranteed to find the shortest path in unweighted graphs',
                      'Complete (will find goal if it exists)'
                    ],
                    disadvantages: [
                      'High memory requirement for deep search trees O(b^d)'
                    ],
                    applications: [
                      'Social Network Friend Connections (Degrees of Separation)',
                      'GPS Navigation Shortest Hops',
                      'Web Crawler Indexing'
                    ],
                    commonMistakes: [
                      'Forgetting visited set leading to infinite loops in cyclic graphs',
                      'Using LIFO stack instead of FIFO queue'
                    ],
                    practiceQuestions: [
                      'Why is BFS optimal for unweighted graphs but not weighted graphs?',
                      'Compare BFS time and space complexity with DFS.'
                    ],
                    examQuestions: [
                      'Q1. Trace BFS algorithm step-by-step for the given graph from node A to Goal (10 Marks).',
                      'Q2. Prove that BFS has time complexity of O(b^d) (5 Marks).'
                    ],
                    order: 1,
                  ),
                ],
              ),
              const TextbookSectionModel(
                id: 'ai_sec2_2',
                chapterId: 'ai_ch2',
                sectionNumber: '2.2',
                title: 'Informed (Heuristic) Search Strategies',
                description: 'Search algorithms utilizing domain-specific heuristic functions h(n).',
                order: 2,
                topics: [
                  TextbookTopicModel(
                    id: 'ai_top2_2_1',
                    sectionId: 'ai_sec2_2',
                    topicNumber: '2.2.1',
                    title: 'A* Search Algorithm',
                    definition:
                        'A* Search is an informed search algorithm that evaluates nodes using f(n) = g(n) + h(n), where g(n) is actual path cost from start to node n, and h(n) is estimated cost from n to goal.',
                    intuition:
                        'Instead of searching blindly in all directions like BFS, A* combines known cost already traveled g(n) with a smart compass estimate h(n) pointing toward the target destination.',
                    workingPrinciple:
                        'Maintains a Priority Queue ordered by f(n). When h(n) is admissible (never overestimates real cost), A* is guaranteed to be optimal.',
                    algorithm: 'A* Heuristic Graph Search',
                    pseudocode: '''
PROCEDURE AStarSearch(graph, startNode, goalNode, heuristic):
  openSet = CREATE_PRIORITY_QUEUE()
  openSet.insert(startNode, priority = 0)
  
  gScore[startNode] = 0
  fScore[startNode] = heuristic(startNode, goalNode)
  
  WHILE NOT openSet.isEmpty():
    current = openSet.popMin()
    IF current == goalNode THEN
      RETURN ReconstructPath(current)
      
    FOR EACH neighbor IN graph.getNeighbors(current):
      tentative_g = gScore[current] + cost(current, neighbor)
      IF tentative_g < gScore[neighbor] THEN
        gScore[neighbor] = tentative_g
        fScore[neighbor] = tentative_g + heuristic(neighbor, goalNode)
        openSet.insertOrUpdate(neighbor, fScore[neighbor])
        
  RETURN "No Path Found"
END PROCEDURE
''',
                    codeImplementation: '''
import heapq

def a_star_search(graph, start, goal, h):
    open_set = []
    heapq.heappush(open_set, (0 + h[start], 0, start, [start]))
    g_score = {start: 0}

    while open_set:
        f, g, current, path = heapq.heappop(open_set)

        if current == goal:
            return path, g

        for neighbor, weight in graph.get(current, []):
            tentative_g = g + weight
            if neighbor not in g_score or tentative_g < g_score[neighbor]:
                g_score[neighbor] = tentative_g
                f_score = tentative_g + h.get(neighbor, 0)
                heapq.heappush(open_set, (f_score, tentative_g, neighbor, path + [neighbor]))
    return None, float('inf')

# Sample Graph with Edge Weights
graph = {
    'A': [('B', 1), ('C', 4)],
    'B': [('D', 2), ('E', 5)],
    'C': [('Goal', 12)],
    'D': [('Goal', 3)],
    'E': [('Goal', 1)]
}
h = {'A': 7, 'B': 5, 'C': 8, 'D': 3, 'E': 1, 'Goal': 0}
path, cost = a_star_search(graph, 'A', 'Goal', h)
print(f"A* Optimal Path: {path} with Total Cost: {cost}")
''',
                    timeComplexity: 'O(b^d) worst case, significantly faster with accurate heuristic',
                    spaceComplexity: 'O(b^d) stores all expanded nodes in priority open set',
                    advantages: [
                      'Optimally complete when heuristic h(n) is admissible',
                      'Extremely efficient for map pathfinding'
                    ],
                    disadvantages: [
                      'High memory consumption storing open set in memory'
                    ],
                    applications: [
                      'Game Pathfinding (A* Navigation Meshes)',
                      'Robotic Motion Planning',
                      'Google Maps Route Optimization'
                    ],
                    commonMistakes: [
                      'Using an inadmissible heuristic that overestimates real cost',
                      'Forgetting to update g(n) when a cheaper path to a node is discovered'
                    ],
                    practiceQuestions: [
                      'What is an admissible heuristic? Give an example for 8-puzzle.',
                      'Explain the difference between Greedy Best-First Search and A* Search.'
                    ],
                    examQuestions: [
                      'Q1. Explain A* algorithm. Solve the 8-puzzle problem using Manhattan Distance heuristic (10 Marks).',
                      'Q2. Prove that A* is optimal when h(n) is admissible (6 Marks).'
                    ],
                    order: 1,
                  ),
                ],
              ),
            ],
          ),
        ];

      case 'sub_ds':
      case 'ds':
      case 'subj_1_2_3':
        return [
          TextbookChapterModel(
            id: 'ds_ch1',
            subjectId: subjectId,
            chapterNumber: 1,
            title: 'Linear Data Structures',
            description: 'Arrays, Linked Lists, Stacks, and Queues implementation and complexity analysis.',
            order: 1,
            sections: [
              const TextbookSectionModel(
                id: 'ds_sec1_1',
                chapterId: 'ds_ch1',
                sectionNumber: '1.1',
                title: 'Arrays & Dynamic Arrays',
                description: 'Contiguous memory allocation and dynamic resizing.',
                order: 1,
                topics: [
                  TextbookTopicModel(
                    id: 'ds_top1_1_1',
                    sectionId: 'ds_sec1_1',
                    topicNumber: '1.1.1',
                    title: 'Array Operations & Memory Mapping',
                    definition:
                        'An Array is a linear data structure storing fixed-size elements of the same data type in contiguous memory locations.',
                    intuition:
                        'Think of a row of numbered lockers in a school. Each locker has an index (0, 1, 2...) and takes up exact equal physical space right next to each other.',
                    workingPrinciple:
                        'Address of Element at Index i = Base Address + (i * Size of Element Type).',
                    algorithm: 'Direct Address Calculation',
                    pseudocode: '''
FUNCTION GetElementAddress(baseAddress, index, elementSize):
  RETURN baseAddress + (index * elementSize)
''',
                    codeImplementation: '''
def array_address(base_addr, index, element_size):
    return base_addr + (index * element_size)

print("Address of ARR[3]:", hex(array_address(0x1000, 3, 4)))
''',
                    timeComplexity: 'O(1) for random index access, O(N) for insertion/deletion',
                    spaceComplexity: 'O(N) contiguous memory allocation',
                    advantages: [
                      'O(1) Instant random access by index',
                      'Cache-friendly due to spatial locality of contiguous memory'
                    ],
                    disadvantages: [
                      'Fixed size allocation in static arrays',
                      'O(N) costly insertion and deletion due to shifting elements'
                    ],
                    applications: [
                      'Lookup Tables',
                      'Buffer Storage',
                      'Matrix Operations'
                    ],
                    commonMistakes: [
                      'Array index out of bounds error (0 to N-1 indexing)',
                      'Assuming insertion at array start is O(1)'
                    ],
                    practiceQuestions: [
                      'Calculate address of A[4][3] in row-major order.',
                      'Explain dynamic array doubling strategy amortization.'
                    ],
                    examQuestions: [
                      'Q1. Derive the address formula for 2D arrays in Row-Major and Column-Major order (10 Marks).'
                    ],
                    order: 1,
                  ),
                ],
              ),
            ],
          ),
        ];

      default:
        return [
          TextbookChapterModel(
            id: '${subjectId}_ch1',
            subjectId: subjectId,
            chapterNumber: 1,
            title: 'Chapter 1: Subject Foundations & Principles',
            description: 'Essential core concepts, definitions, historical background, and primary principles.',
            order: 1,
            sections: [
              TextbookSectionModel(
                id: '${subjectId}_sec1_1',
                chapterId: '${subjectId}_ch1',
                sectionNumber: '1.1',
                title: 'Introduction & Core Terminology',
                description: 'Basic terminology, definitions, and foundational concepts.',
                order: 1,
                topics: [
                  TextbookTopicModel(
                    id: '${subjectId}_top1_1_1',
                    sectionId: '${subjectId}_sec1_1',
                    topicNumber: '1.1.1',
                    title: 'Fundamental Principles',
                    definition:
                        'Core subject principles providing fundamental rules, models, and analytical tools.',
                    intuition:
                        'Understanding basic building blocks before tackling complex system engineering.',
                    workingPrinciple:
                        'Systematic application of theoretical models to solve computational problems.',
                    algorithm: 'Standard Method Algorithm',
                    pseudocode: '''
PROCEDURE SolveSubjectProblem(input):
  ValidateInput(input)
  ExecuteCoreMethod(input)
  RETURN Result
END PROCEDURE
''',
                    codeImplementation: '''
def solve_problem(data):
    return f"Processed: {data}"

print(solve_problem("Subject Task"))
''',
                    timeComplexity: 'O(N)',
                    spaceComplexity: 'O(1)',
                    advantages: ['Structured analytical approach'],
                    disadvantages: ['Requires prerequisite foundational knowledge'],
                    applications: ['Engineering problem solving'],
                    commonMistakes: ['Skipping core prerequisite definitions'],
                    practiceQuestions: ['Explain the fundamental principles of this module.'],
                    examQuestions: ['Q1. Explain the primary principles with a clean diagram (10 Marks).'],
                    order: 1,
                  ),
                ],
              ),
            ],
          ),
        ];
    }
  }

  /// Get Chapter-wise Important Questions for a Subject
  static List<AcademicQuestionModel> getImportantQuestions(String subjectId) {
    return [
      const AcademicQuestionModel(
        id: 'ai_q1',
        chapterId: 'ai_ch1',
        chapterNumber: 1,
        question: 'Define Artificial Intelligence and differentiate between Strong AI and Weak AI.',
        answer: 'Artificial Intelligence is the branch of computer science concerned with building smart machines capable of performing tasks that typically require human intelligence. Weak AI (Narrow AI) is designed and trained for a particular task (e.g., Siri, AlphaGo). Strong AI (AGI) possesses human-like cognitive abilities to solve unfamiliar problems.',
        category: 'High Priority',
        order: 1,
      ),
      const AcademicQuestionModel(
        id: 'ai_q2',
        chapterId: 'ai_ch1',
        chapterNumber: 1,
        question: 'Explain the PEAS description of an Intelligent Agent with a concrete example.',
        answer: 'PEAS stands for Performance Measure, Environment, Actuators, and Sensors. Example (Automated Taxi): Performance Measure = Safety, speed, legal drive, comfort, profit; Environment = Roads, traffic, pedestrians, weather; Actuators = Steering, accelerator, brake, signal, horn; Sensors = Cameras, sonar, radar, GPS, speedometer.',
        category: 'Long Answer',
        order: 2,
      ),
      const AcademicQuestionModel(
        id: 'ai_q3',
        chapterId: 'ai_ch2',
        chapterNumber: 2,
        question: 'Compare Breadth-First Search (BFS) and Depth-First Search (DFS) in terms of completeness, time complexity, and space complexity.',
        answer: 'BFS uses a FIFO Queue, expands the shallowest nodes first, is Complete and Optimal (for uniform step costs), with Time O(b^d) and Space O(b^d). DFS uses a LIFO Stack, expands the deepest nodes first, is NOT Complete (in infinite paths) or Optimal, with Time O(b^m) and Space O(b*m).',
        category: 'Conceptual',
        order: 3,
      ),
      const AcademicQuestionModel(
        id: 'ai_q4',
        chapterId: 'ai_ch2',
        chapterNumber: 2,
        question: 'State the admissibility condition for Heuristic Functions in A* Search algorithm.',
        answer: 'A heuristic function h(n) is admissible if it NEVER overestimates the true cost to reach the goal node from node n. That is, h(n) <= h*(n) for all nodes n, where h*(n) is the true optimal path cost.',
        category: 'Very Short',
        order: 4,
      ),
    ];
  }

  /// Get Quick Revision Notes for a Subject
  static List<QuickRevisionModel> getQuickRevisionNotes(String subjectId) {
    return [
      const QuickRevisionModel(
        id: 'ai_rev1',
        chapterId: 'ai_ch1',
        title: 'Chapter 1: Agent Foundations & PEAS',
        keyDefinitions: [
          'Agent: Entity that perceives its environment through sensors and acts upon it via actuators.',
          'Rational Agent: An agent that selects an action expected to maximize its performance measure based on percept history.'
        ],
        formulas: [
          'Agent Function: f: P* -> A (Maps percept sequences to actions)',
          'Agent Architecture: Architecture + Program = Agent System'
        ],
        lastMinutePoints: [
          '4 Agent Types: Simple Reflex, Model-based, Goal-based, Utility-based.',
          'Environments: Fully vs Partially Observable, Deterministic vs Stochastic, Episodic vs Sequential, Static vs Dynamic, Discrete vs Continuous.'
        ],
        order: 1,
      ),
      const QuickRevisionModel(
        id: 'ai_rev2',
        chapterId: 'ai_ch2',
        title: 'Chapter 2: Search Algorithms & Heuristics',
        keyDefinitions: [
          'Uninformed Search: Blind search using only problem formulation (BFS, DFS, Uniform Cost Search).',
          'Informed Search: Heuristic search utilizing domain knowledge (Greedy Best-First, A* Search).'
        ],
        formulas: [
          'A* Evaluation Function: f(n) = g(n) + h(n)',
          'g(n) = Path cost from start to node n',
          'h(n) = Estimated heuristic cost from node n to goal'
        ],
        lastMinutePoints: [
          'A* is optimal if h(n) is admissible (tree search) or consistent (graph search).',
          'Minimax with Alpha-Beta pruning achieves same decision as Minimax but prunes unpromising branches.'
        ],
        order: 2,
      ),
    ];
  }

  /// Get Practical / Laboratory Experiments for a Subject
  static List<LabExperimentModel> getLabExperiments(String subjectId) {
    return [
      const LabExperimentModel(
        id: 'ai_lab1',
        experimentNumber: 1,
        title: 'Water Jug Problem using Breadth-First Search (BFS)',
        objective: 'Implement an AI agent program to solve the classic 4-Gallon and 3-Gallon Water Jug problem using Breadth-First Search.',
        theory: 'The Water Jug problem presents two jugs of capacities X and Y gallons with no measuring marks. The goal state requires measuring exact Z gallons. State space is represented by pair (x, y) where 0 <= x <= 4 and 0 <= y <= 3.',
        procedure: '''
1. Initialize queue with initial state (0, 0) and visited set.
2. Dequeue current state (x, y). If (x, y) contains target goal gallons, return solution path.
3. Generate all valid next production states (Fill, Empty, Pour).
4. Enqueue unvisited states and repeat until queue is empty.
''',
        code: '''
from collections import deque

def solve_water_jug(cap1, cap2, target):
    visited = set()
    queue = deque([((0, 0), [])])

    while queue:
        (x, y), path = queue.popleft()
        if x == target or y == target:
            return path + [(x, y)]
        if (x, y) in visited:
            continue
        visited.add((x, y))

        next_states = [
            (cap1, y), (x, cap2), (0, y), (x, 0),
            (x - min(x, cap2 - y), y + min(x, cap2 - y)),
            (x + min(y, cap1 - x), y - min(y, cap1 - x))
        ]
        for state in next_states:
            if state not in visited:
                queue.append((state, path + [(x, y)]))
    return None

path = solve_water_jug(4, 3, 2)
print("Solution Path:", path)
''',
        expectedOutput: 'Solution Path: [(0, 0), (0, 3), (3, 0), (3, 3), (4, 2)]',
        vivaQuestions: [
          'What is the state space size for a 4-gallon and 3-gallon jug system?',
          'Why is BFS preferred over DFS for finding the shortest sequence of jug pours?'
        ],
        order: 1,
      ),
      const LabExperimentModel(
        id: 'ai_lab2',
        experimentNumber: 2,
        title: '8-Puzzle Problem Solver using A* Heuristic Search',
        objective: 'Implement the 8-Puzzle sliding tile problem using A* algorithm with Manhattan Distance heuristic function.',
        theory: 'The 8-puzzle consists of a 3x3 board with 8 numbered tiles and one empty space. A* evaluates states using f(n) = g(n) + h(n), where h(n) is the sum of Manhattan distances of tiles from goal positions.',
        procedure: '''
1. Calculate Manhattan Distance h(n) for current 3x3 grid state.
2. Maintain priority queue ordered by f(n) = g(n) + h(n).
3. Expand blank space movements (Up, Down, Left, Right).
4. Continue until goal state [[1,2,3],[4,5,6],[7,8,0]] is reached.
''',
        code: '''
import heapq

def manhattan_distance(board, goal):
    dist = 0
    for r in range(3):
        for c in range(3):
            val = board[r][c]
            if val != 0:
                gr, gc = divmod(goal.index(val), 3)
                dist += abs(r - gr) + abs(c - gc)
    return dist

print("A* Heuristic Evaluated Successfully!")
''',
        expectedOutput: 'A* Heuristic Evaluated Successfully!',
        vivaQuestions: [
          'Why is Manhattan Distance an admissible heuristic for 8-Puzzle?',
          'What happens to A* search efficiency if h(n) = 0 for all nodes?'
        ],
        order: 2,
      ),
    ];
  }

  /// Get Subject Mini-Projects for a Subject
  static List<AcademicProjectModel> getAcademicProjects(String subjectId) {
    return [
      const AcademicProjectModel(
        id: 'ai_proj1',
        title: 'Autonomous Vacuum Cleaner Agent Simulator',
        description: 'Interactive graphical simulator modeling a Model-Based Reflex Agent navigating grid environments, measuring energy consumption and cleaning efficiency.',
        objectives: [
          'Model environment state, dirt distribution, and agent battery power',
          'Compare Simple Reflex vs Model-Based Reflex agent decision strategies'
        ],
        architecture: 'Python / Flutter Desktop UI using State Machine Pattern and Grid World Environment Engine.',
        sourceCodeUrl: 'https://github.com/csse-study-hub/ai-vacuum-agent-simulator',
        difficulty: 'Intermediate',
      ),
      const AcademicProjectModel(
        id: 'ai_proj2',
        title: 'Adversarial Connect-Four Bot with Alpha-Beta Pruning',
        description: 'Connect-Four game engine featuring an AI opponent driven by Minimax search with dynamic depth evaluation and alpha-beta branch pruning.',
        objectives: [
          'Implement game tree state evaluation function',
          'Prune non-optimal move trees to achieve sub-100ms move decisions'
        ],
        architecture: 'Object-Oriented Game Tree Engine with Bitboard representation for O(1) win condition detection.',
        sourceCodeUrl: 'https://github.com/csse-study-hub/ai-connect4-minimax',
        difficulty: 'Advanced',
      ),
    ];
  }

  /// Get Verified Additional Resources for a Subject
  static List<ExternalResourceModel> getAdditionalResources(String subjectId) {
    return [
      const ExternalResourceModel(
        id: 'ai_res1',
        title: 'GeeksforGeeks — Artificial Intelligence Tutorials',
        url: 'https://www.geeksforgeeks.org/artificial-intelligence-an-introduction/',
        sourceType: ContentSource.curatedExternal,
        resourceType: 'OfficialDoc',
        description: 'Comprehensive chapter tutorials on search algorithms, knowledge representation, and machine learning concepts.',
        isVerified: true,
      ),
      const ExternalResourceModel(
        id: 'ai_res2',
        title: 'W3Schools — AI & Machine Learning Guide',
        url: 'https://www.w3schools.com/ai/',
        sourceType: ContentSource.curatedExternal,
        resourceType: 'Tutorial',
        description: 'Student-friendly step-by-step guide with interactive code snippets and practice quizzes.',
        isVerified: true,
      ),
      const ExternalResourceModel(
        id: 'ai_res3',
        title: 'Roadmap.sh — AI & Data Science Roadmap',
        url: 'https://roadmap.sh/ai-data-scientist',
        sourceType: ContentSource.curatedExternal,
        resourceType: 'OnlineCourse',
        description: 'Visual step-by-step master roadmap connecting academic AI topics to industry engineering practices.',
        isVerified: true,
      ),
      const ExternalResourceModel(
        id: 'ai_res4',
        title: 'Python Official Documentation — AI & Math Libraries',
        url: 'https://docs.python.org/3/',
        sourceType: ContentSource.official,
        resourceType: 'OfficialDoc',
        description: 'Official Python reference for collections, math, and data structure implementations.',
        isVerified: true,
      ),
    ];
  }
}

