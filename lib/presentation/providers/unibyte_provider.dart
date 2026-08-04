import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/models/unibyte_model.dart';

class UniByteProvider extends ChangeNotifier {
  int _currentIndex = 0;

  final List<UniByteModel> _byteList = const [
    UniByteModel(
      id: 'byte_1',
      learn: 'Binary Search',
      practice: '2 LeetCode Problems',
      interview: 'What is a Stack?',
      shortcut: 'Ctrl + Shift + P',
      technology: 'Kubernetes',
      estimatedMinutes: 5,
      isFeatured: true,
    ),
    UniByteModel(
      id: 'byte_2',
      learn: 'REST API vs GraphQL',
      practice: '3 SQL Practice Queries',
      interview: 'Explain ACID Properties in DBMS',
      shortcut: 'Alt + Shift + F',
      technology: 'Docker Containers',
      estimatedMinutes: 5,
      isFeatured: true,
    ),
    UniByteModel(
      id: 'byte_3',
      learn: 'Dijkstra Shortest Path',
      practice: 'Striver SDE Array Sheet',
      interview: 'What is Process vs Thread?',
      shortcut: 'Ctrl + D (Select Next)',
      technology: 'Flutter Web & Desktop',
      estimatedMinutes: 5,
      isFeatured: true,
    ),
    UniByteModel(
      id: 'byte_4',
      learn: 'TCP vs UDP Protocols',
      practice: 'Binary Tree Level Traversal',
      interview: 'Explain OOPS Encapsulation',
      shortcut: 'Shift + F6 (Refactor)',
      technology: 'Firebase Cloud Functions',
      estimatedMinutes: 5,
      isFeatured: true,
    ),
  ];

  UniByteModel get currentUniByte => _byteList[_currentIndex];

  void refreshUniByte() {
    if (_byteList.length <= 1) return;
    int nextIndex;
    final random = Random();
    do {
      nextIndex = random.nextInt(_byteList.length);
    } while (nextIndex == _currentIndex);

    _currentIndex = nextIndex;
    notifyListeners();
  }
}
