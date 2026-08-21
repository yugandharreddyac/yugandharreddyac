import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/resource_model.dart';
import '../../data/models/subject_model.dart';

class ShareHelper {
  /// Native sharing trigger for a Resource
  static Future<void> shareResource(
      BuildContext context, ResourceModel resource) async {
    final String text =
        '📘 *${resource.title}*\n\nSubject: ${resource.subjectName}\nCategory: ${resource.resourceType}\n\nAccess this study material on CSSE Study Hub!';

    await _launchShareIntent(context, text, title: 'Share ${resource.title}');
  }

  /// Native sharing trigger for a Subject
  static Future<void> shareSubject(
      BuildContext context, SubjectModel subject) async {
    final String text =
        '📚 *${subject.name} (${subject.code})*\n\nCredits: ${subject.creditHours}\n${subject.description}\n\nExplore study notes, question papers & books on CSSE Study Hub!';

    await _launchShareIntent(context, text, title: 'Share ${subject.name}');
  }

  /// Native sharing trigger for CSSE Study Hub app
  static Future<void> shareApp(BuildContext context) async {
    const String text =
        '🚀 Download CSSE Study Hub! Access Computer Science & Software Engineering syllabus, study notes, and past question papers offline.';

    await _launchShareIntent(context, text, title: 'Share CSSE Study Hub');
  }

  static Future<void> _launchShareIntent(
    BuildContext context,
    String content, {
    required String title,
  }) async {
    final String encodedText = Uri.encodeComponent(content);
    final Uri uri = Uri.parse(
        'mailto:?subject=${Uri.encodeComponent(title)}&body=$encodedText');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          _showShareFallbackModal(context, content, title);
        }
      }
    } catch (_) {
      if (context.mounted) {
        _showShareFallbackModal(context, content, title);
      }
    }
  }

  static void _showShareFallbackModal(
      BuildContext context, String content, String title) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            SelectableText(
              content,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.check_rounded),
                label: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
