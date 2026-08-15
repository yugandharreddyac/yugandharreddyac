import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/ai_attachment.dart';
import '../../providers/document_processing_provider.dart';

/// Responsive, keyboard-safe input composer for UniDocs AI
class AiComposer extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool isLoading;
  final List<AiAttachment> pendingAttachments;
  final ValueChanged<AiAttachment>? onAttachmentAdded;
  final ValueChanged<AiAttachment>? onAttachmentRemoved;

  const AiComposer({
    super.key,
    required this.onSend,
    this.isLoading = false,
    this.pendingAttachments = const [],
    this.onAttachmentAdded,
    this.onAttachmentRemoved,
  });

  @override
  State<AiComposer> createState() => _AiComposerState();
}

class _AiComposerState extends State<AiComposer> {
  late final TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();
  int _charCount = 0;
  static const int _maxChars = 4000;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _charCount = _textController.text.length;
    });
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty && widget.pendingAttachments.isEmpty) return;
    if (widget.isLoading) return;

    widget.onSend(text.isNotEmpty ? text : 'Explain the attached document.');
    _textController.clear();
  }

  Future<void> _handlePickAttachment() async {
    DocumentProcessingProvider? docProc;
    try {
      docProc = context.read<DocumentProcessingProvider>();
    } catch (_) {}

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt', 'dart', 'py', 'java', 'cpp', 'json', 'md'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final pickedFile = result.files.first;
        final extension = pickedFile.extension?.toLowerCase() ?? '';
        final isPdf = extension == 'pdf';

        AiAttachment attachment;
        if (isPdf && pickedFile.path != null && pickedFile.path!.isNotEmpty && docProc != null) {
          final processed = await docProc.processFile(pickedFile.path!, pickedFile.name);
          attachment = processed ?? _buildDefaultAttachment(pickedFile, isPdf);
        } else {
          attachment = _buildDefaultAttachment(pickedFile, isPdf);
        }

        if (widget.onAttachmentAdded != null) {
          widget.onAttachmentAdded!(attachment);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open file picker: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  AiAttachment _buildDefaultAttachment(PlatformFile pickedFile, bool isPdf) {
    return AiAttachment(
      id: 'att_${DateTime.now().millisecondsSinceEpoch}',
      filename: pickedFile.name,
      sourceType: AiAttachmentSourceType.localFile,
      mimeType: isPdf ? 'application/pdf' : 'text/plain',
      sizeBytes: pickedFile.size,
      localIdentifier: pickedFile.path,
      status: AiAttachmentStatus.processed,
      extractedTextSnippet: isPdf
          ? 'PDF Document attached for syllabus and lecture notes analysis.'
          : 'Text document attached.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final canSend = (_textController.text.trim().isNotEmpty || widget.pendingAttachments.isNotEmpty) && !widget.isLoading;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Attachments Preview Bar
            if (widget.pendingAttachments.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: widget.pendingAttachments.map((att) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            att.mimeType.contains('pdf') ? Icons.picture_as_pdf_rounded : Icons.description_rounded,
                            size: 14,
                            color: att.mimeType.contains('pdf') ? Colors.redAccent : AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 160),
                            child: Text(
                              att.fileName,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white : const Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () {
                              if (widget.onAttachmentRemoved != null) {
                                widget.onAttachmentRemoved!(att);
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(Icons.close_rounded, size: 14, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            // Input Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Attachment Button
                IconButton(
                  icon: const Icon(Icons.attach_file_rounded),
                  tooltip: 'Attach PDF or Code file',
                  color: isDark ? Colors.white70 : const Color(0xFF64748B),
                  onPressed: widget.isLoading ? null : _handlePickAttachment,
                ),
                const SizedBox(width: 4),

                // Text Input Area
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextField(
                          controller: _textController,
                          focusNode: _focusNode,
                          minLines: 1,
                          maxLines: 5,
                          maxLength: _maxChars,
                          buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                          style: GoogleFonts.inter(
                            fontSize: 14.5,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Ask anything about CS, topics, roadmap, or placement...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 13.5,
                              color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onSubmitted: (_) {
                            _handleSend();
                          },
                        ),
                        if (_charCount > 3000)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '$_charCount / $_maxChars',
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                color: _charCount > 3800 ? Colors.redAccent : Colors.orangeAccent,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // Send Button
                Container(
                  decoration: BoxDecoration(
                    color: canSend ? AppColors.primary : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: widget.isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.arrow_upward_rounded),
                    color: Colors.white,
                    tooltip: 'Send message',
                    onPressed: canSend ? _handleSend : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
