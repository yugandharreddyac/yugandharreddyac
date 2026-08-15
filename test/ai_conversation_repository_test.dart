import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csse_study_hub/data/models/ai_conversation.dart';
import 'package:csse_study_hub/data/models/ai_message.dart';
import 'package:csse_study_hub/data/repositories/ai_conversation_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late LocalAiConversationRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repo = LocalAiConversationRepository(prefs);
  });

  group('LocalAiConversationRepository Tests', () {
    test('Create conversation and list conversations', () async {
      final initialList = await repo.listConversations();
      expect(initialList, isEmpty);

      final conv1 = await repo.createConversation(initialTitle: 'First Chat');
      expect(conv1.id, isNotEmpty);
      expect(conv1.title, equals('First Chat'));

      final conv2 = await repo.createConversation(initialTitle: 'Second Chat');

      final listAfter = await repo.listConversations();
      expect(listAfter.length, equals(2));
      expect(listAfter.first.id, equals(conv2.id)); // Most recently updated is first
    });

    test('Save and load messages inside conversation', () async {
      final conv = await repo.createConversation(initialTitle: 'DSA Prep');

      final msg1 = AiMessage(
        id: 'msg_1',
        conversationId: conv.id,
        role: AiMessageRole.user,
        content: 'How to reverse a linked list?',
        timestamp: DateTime.now(),
      );

      final msg2 = AiMessage(
        id: 'msg_2',
        conversationId: conv.id,
        role: AiMessageRole.assistant,
        content: 'Use three pointers: prev, current, next.',
        timestamp: DateTime.now(),
      );

      await repo.saveMessage(conv.id, msg1);
      await repo.saveMessage(conv.id, msg2);

      final loaded = await repo.loadConversation(conv.id);
      expect(loaded, isNotNull);
      expect(loaded!.messages.length, equals(2));
      expect(loaded.messages[0].content, equals('How to reverse a linked list?'));
      expect(loaded.messages[1].content, equals('Use three pointers: prev, current, next.'));
    });

    test('Update title and delete conversation', () async {
      final conv = await repo.createConversation(initialTitle: 'Old Title');
      await repo.updateConversationTitle(conv.id, 'New Renamed Title');

      final updated = await repo.loadConversation(conv.id);
      expect(updated?.title, equals('New Renamed Title'));

      await repo.deleteConversation(conv.id);
      final deleted = await repo.loadConversation(conv.id);
      expect(deleted, isNull);

      final list = await repo.listConversations();
      expect(list, isEmpty);
    });

    test('Clear all conversations', () async {
      await repo.createConversation(initialTitle: 'Chat A');
      await repo.createConversation(initialTitle: 'Chat B');
      expect((await repo.listConversations()).length, equals(2));

      await repo.clearAllConversations();
      expect((await repo.listConversations()), isEmpty);
    });

    test('Message capping at 100 messages per conversation', () async {
      final conv = await repo.createConversation(initialTitle: 'Long Thread');
      final messages = List.generate(
        120,
        (i) => AiMessage(
          id: 'msg_$i',
          conversationId: conv.id,
          role: i % 2 == 0 ? AiMessageRole.user : AiMessageRole.assistant,
          content: 'Message content #$i',
          timestamp: DateTime.now(),
        ),
      );

      final oversizedConv = conv.copyWith(messages: messages);
      await repo.saveConversation(oversizedConv);

      final loaded = await repo.loadConversation(conv.id);
      expect(loaded?.messages.length, equals(100));
      expect(loaded?.messages.last.content, equals('Message content #119'));
    });
  });
}
