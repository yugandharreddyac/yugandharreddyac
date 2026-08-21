import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ai_conversation.dart';
import '../models/ai_message.dart';

/// Repository interface for persisting AI conversations and message histories
abstract class AiConversationRepository {
  Future<List<AiConversation>> listConversations(
      {bool includeArchived = false});
  Future<AiConversation?> loadConversation(String conversationId);
  Future<AiConversation> createConversation(
      {String? initialTitle, Map<String, dynamic>? pinnedContext});
  Future<void> saveConversation(AiConversation conversation);
  Future<void> saveMessage(String conversationId, AiMessage message);
  Future<void> updateConversationTitle(String conversationId, String newTitle);
  Future<void> deleteConversation(String conversationId);
  Future<void> clearAllConversations();
}

/// Partitioned local implementation of AiConversationRepository backed by SharedPreferences
class LocalAiConversationRepository implements AiConversationRepository {
  static const String _indexKey = 'unidocs_ai_conversations_index';
  static const String _convPrefix = 'unidocs_ai_conv_';
  static const int _maxConversations = 50;
  static const int _maxMessagesPerConversation = 100;

  final SharedPreferences? _prefsInstance;

  LocalAiConversationRepository([this._prefsInstance]);

  Future<SharedPreferences> _getPrefs() async {
    if (_prefsInstance != null) return _prefsInstance;
    return await SharedPreferences.getInstance();
  }

  @override
  Future<List<AiConversation>> listConversations(
      {bool includeArchived = false}) async {
    try {
      final prefs = await _getPrefs();
      final indexJson = prefs.getString(_indexKey);
      if (indexJson == null || indexJson.isEmpty) return [];

      final list = (json.decode(indexJson) as List<dynamic>?) ?? [];
      final result = <AiConversation>[];

      for (final item in list) {
        if (item is Map<String, dynamic>) {
          final isArchived = item['isArchived'] == true;
          if (!includeArchived && isArchived) continue;
          result.add(AiConversation.fromMap(item));
        }
      }

      // Sort latest first
      result.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return result;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<AiConversation?> loadConversation(String conversationId) async {
    try {
      final prefs = await _getPrefs();
      final convJson = prefs.getString('$_convPrefix$conversationId');
      if (convJson == null || convJson.isEmpty) return null;
      return AiConversation.fromJson(convJson);
    } catch (_) {
      return null;
    }
  }

  static int _idCounter = 0;

  @override
  Future<AiConversation> createConversation({
    String? initialTitle,
    Map<String, dynamic>? pinnedContext,
  }) async {
    final now = DateTime.now();
    _idCounter++;
    final conv = AiConversation(
      id: 'conv_${now.microsecondsSinceEpoch}_$_idCounter',
      title: initialTitle ?? 'New Conversation',
      createdAt: now,
      updatedAt: now,
      pinnedContext: pinnedContext ?? const {},
    );

    await saveConversation(conv);
    return conv;
  }

  @override
  Future<void> saveConversation(AiConversation conversation) async {
    final prefs = await _getPrefs();

    // 1. Cap messages if needed
    var messages = conversation.messages;
    if (messages.length > _maxMessagesPerConversation) {
      messages =
          messages.sublist(messages.length - _maxMessagesPerConversation);
    }

    final updatedConv = conversation.copyWith(
      messages: messages,
      updatedAt: DateTime.now(),
    );

    // 2. Save conversation payload in partitioned key
    await prefs.setString(
        '$_convPrefix${updatedConv.id}', updatedConv.toJson());

    // 3. Update index metadata
    final indexList = await listConversations(includeArchived: true);
    indexList.removeWhere((c) => c.id == updatedConv.id);
    // Insert at front
    indexList.insert(
      0,
      updatedConv.copyWith(
          messages: const []), // Strip full message payload from index to stay lightweight
    );

    if (indexList.length > _maxConversations) {
      final evicted = indexList.sublist(_maxConversations);
      for (final oldConv in evicted) {
        await prefs.remove('$_convPrefix${oldConv.id}');
      }
      indexList.removeRange(_maxConversations, indexList.length);
    }

    final encodedIndex = json.encode(indexList.map((c) => c.toMap()).toList());
    await prefs.setString(_indexKey, encodedIndex);
  }

  @override
  Future<void> saveMessage(String conversationId, AiMessage message) async {
    var conv = await loadConversation(conversationId);
    if (conv == null) {
      final now = DateTime.now();
      conv = AiConversation(
        id: conversationId,
        title: message.content.length > 30
            ? '${message.content.substring(0, 30)}...'
            : message.content,
        createdAt: now,
        updatedAt: now,
      );
    }

    final updatedMessages = List<AiMessage>.from(conv.messages)..add(message);
    await saveConversation(conv.copyWith(messages: updatedMessages));
  }

  @override
  Future<void> updateConversationTitle(
      String conversationId, String newTitle) async {
    final conv = await loadConversation(conversationId);
    if (conv != null) {
      await saveConversation(conv.copyWith(title: newTitle));
    }
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    final prefs = await _getPrefs();
    await prefs.remove('$_convPrefix$conversationId');

    final indexList = await listConversations(includeArchived: true);
    indexList.removeWhere((c) => c.id == conversationId);
    final encodedIndex = json.encode(indexList.map((c) => c.toMap()).toList());
    await prefs.setString(_indexKey, encodedIndex);
  }

  @override
  Future<void> clearAllConversations() async {
    final prefs = await _getPrefs();
    final indexList = await listConversations(includeArchived: true);
    for (final c in indexList) {
      await prefs.remove('$_convPrefix${c.id}');
    }
    await prefs.remove(_indexKey);
  }
}
