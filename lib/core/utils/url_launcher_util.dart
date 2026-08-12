import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtil {
  UrlLauncherUtil._();

  /// Safely opens an external URL using url_launcher with proper error handling and fallback UI.
  static Future<void> openUrl(BuildContext context, String? rawUrl) async {
    if (rawUrl == null || rawUrl.trim().isEmpty) {
      _showErrorSnackBar(context, 'Resource link is not available.');
      return;
    }

    final trimmedUrl = rawUrl.trim();
    final Uri? parsedUri = Uri.tryParse(trimmedUrl);

    if (parsedUri == null || !parsedUri.hasScheme) {
      // Try adding https:// scheme if missing
      final formattedUri = Uri.tryParse('https://$trimmedUrl');
      if (formattedUri != null && formattedUri.hasScheme) {
        await _launchUri(context, formattedUri);
        return;
      }
      _showErrorSnackBar(context, 'Unable to open this resource. Please try again.');
      return;
    }

    await _launchUri(context, parsedUri);
  }

  static Future<void> _launchUri(BuildContext context, Uri uri) async {
    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        _showErrorSnackBar(context, 'Unable to open this resource. Please try again.');
      }
    } catch (e) {
      debugPrint('[UrlLauncherUtil] Error launching URL $uri: $e');
      if (context.mounted) {
        _showErrorSnackBar(context, 'Unable to open this resource. Please try again.');
      }
    }
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFDC2626), // Soft Red
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
