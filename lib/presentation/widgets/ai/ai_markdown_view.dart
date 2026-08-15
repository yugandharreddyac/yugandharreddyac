import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

/// High-performance custom Markdown and syntax-highlighted code block renderer for UniDocs AI
class AiMarkdownView extends StatelessWidget {
  final String content;
  final TextStyle? baseStyle;
  final bool isDark;

  const AiMarkdownView({
    super.key,
    required this.content,
    this.baseStyle,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = isDark || theme.brightness == Brightness.dark;

    final defaultText = baseStyle ??
        GoogleFonts.inter(
          fontSize: 14.5,
          height: 1.55,
          color: isDarkMode ? Colors.white.withOpacity(0.92) : const Color(0xFF1E293B),
        );

    final blocks = _parseMarkdownBlocks(content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map((block) => _buildBlock(context, block, defaultText, isDarkMode)).toList(),
    );
  }

  Widget _buildBlock(
    BuildContext context,
    _MarkdownBlock block,
    TextStyle baseTextStyle,
    bool isDarkMode,
  ) {
    switch (block.type) {
      case _BlockType.code:
        return _buildCodeBlock(context, block.content, block.language, isDarkMode);

      case _BlockType.h1:
        return Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 6),
          child: Text(
            block.content,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
              height: 1.3,
            ),
          ),
        );

      case _BlockType.h2:
        return Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 5),
          child: Text(
            block.content,
            style: GoogleFonts.outfit(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white.withOpacity(0.95) : const Color(0xFF1E293B),
              height: 1.3,
            ),
          ),
        );

      case _BlockType.h3:
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: Text(
            block.content,
            style: GoogleFonts.outfit(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white.withOpacity(0.9) : const Color(0xFF334155),
              height: 1.3,
            ),
          ),
        );

      case _BlockType.bullet:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6, right: 8, left: 4),
                child: Container(
                  width: 5.5,
                  height: 5.5,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Expanded(
                child: _buildRichInlineText(block.content, baseTextStyle, isDarkMode),
              ),
            ],
          ),
        );

      case _BlockType.numbered:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  '${block.number}.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Expanded(
                child: _buildRichInlineText(block.content, baseTextStyle, isDarkMode),
              ),
            ],
          ),
        );

      case _BlockType.quote:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            border: const Border(
              left: BorderSide(color: AppColors.primary, width: 3.5),
            ),
          ),
          child: _buildRichInlineText(block.content, baseTextStyle.copyWith(fontStyle: FontStyle.italic), isDarkMode),
        );

      case _BlockType.table:
        return _buildTable(context, block.tableRows, isDarkMode);

      case _BlockType.paragraph:
      default:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: _buildRichInlineText(block.content, baseTextStyle, isDarkMode),
        );
    }
  }

  Widget _buildCodeBlock(BuildContext context, String code, String? language, bool isDarkMode) {
    final langDisplay = (language != null && language.trim().isNotEmpty) ? language.trim().toUpperCase() : 'CODE';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF181825), // Sleek terminal dark
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF313244),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E2E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(9),
                topRight: Radius.circular(9),
              ),
              border: Border(
                bottom: BorderSide(color: Color(0xFF313244), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF38BA8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF9E2AF),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFA6E3A1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      langDisplay,
                      style: GoogleFonts.firaCode(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFCDD6F4),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Code copied to clipboard!'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    child: Row(
                      children: [
                        const Icon(Icons.copy_rounded, size: 13, color: Color(0xFFBAC2DE)),
                        const SizedBox(width: 4),
                        Text(
                          'Copy',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFFBAC2DE),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Code Content
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              code,
              style: GoogleFonts.firaCode(
                fontSize: 13,
                height: 1.5,
                color: const Color(0xFFCDD6F4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<List<String>> rows, bool isDarkMode) {
    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStatePropertyAll(
              isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            ),
            dataRowColor: WidgetStatePropertyAll(
              isDarkMode ? const Color(0xFF0F172A) : Colors.white,
            ),
            headingTextStyle: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
            ),
            dataTextStyle: GoogleFonts.inter(
              fontSize: 13,
              color: isDarkMode ? Colors.white.withOpacity(0.9) : const Color(0xFF334155),
            ),
            columns: rows.first
                .map((col) => DataColumn(label: Text(col.trim())))
                .toList(),
            rows: rows.skip(1).map((row) {
              return DataRow(
                cells: row.map((cell) => DataCell(Text(cell.trim()))).toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildRichInlineText(String text, TextStyle baseStyle, bool isDarkMode) {
    final spans = _parseInlineSpans(text, baseStyle, isDarkMode);
    return SelectableText.rich(
      TextSpan(children: spans),
    );
  }

  List<InlineSpan> _parseInlineSpans(String text, TextStyle baseStyle, bool isDarkMode) {
    final spans = <InlineSpan>[];
    final inlineRegex = RegExp(r'(\*\*[^*]+\*\*|\*[^*]+\*|`[^`]+`)');
    int lastMatchEnd = 0;

    for (final match in inlineRegex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: baseStyle,
        ));
      }

      final matchedStr = match.group(0)!;
      if (matchedStr.startsWith('**') && matchedStr.endsWith('**')) {
        spans.add(TextSpan(
          text: matchedStr.substring(2, matchedStr.length - 2),
          style: baseStyle.copyWith(fontWeight: FontWeight.w700),
        ));
      } else if (matchedStr.startsWith('*') && matchedStr.endsWith('*')) {
        spans.add(TextSpan(
          text: matchedStr.substring(1, matchedStr.length - 1),
          style: baseStyle.copyWith(fontStyle: FontStyle.italic),
        ));
      } else if (matchedStr.startsWith('`') && matchedStr.endsWith('`')) {
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 0.8,
              ),
            ),
            child: Text(
              matchedStr.substring(1, matchedStr.length - 1),
              style: GoogleFonts.firaCode(
                fontSize: baseStyle.fontSize != null ? baseStyle.fontSize! * 0.9 : 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ));
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: baseStyle,
      ));
    }

    return spans;
  }

  List<_MarkdownBlock> _parseMarkdownBlocks(String raw) {
    final blocks = <_MarkdownBlock>[];
    final lines = raw.split('\n');

    bool inCodeBlock = false;
    String? codeLang;
    final codeBuffer = StringBuffer();

    List<List<String>>? tableBuffer;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();

      // Check code block fences
      if (trimmed.startsWith('```')) {
        if (inCodeBlock) {
          // Close code block
          blocks.add(_MarkdownBlock(
            type: _BlockType.code,
            content: codeBuffer.toString().trimRight(),
            language: codeLang,
          ));
          codeBuffer.clear();
          inCodeBlock = false;
          codeLang = null;
        } else {
          // Open code block
          inCodeBlock = true;
          codeLang = trimmed.substring(3).trim();
        }
        continue;
      }

      if (inCodeBlock) {
        codeBuffer.writeln(line);
        continue;
      }

      // Check Tables
      if (trimmed.startsWith('|') && trimmed.endsWith('|')) {
        if (trimmed.contains('---')) {
          // Divider line, skip
          continue;
        }
        final cols = trimmed
            .substring(1, trimmed.length - 1)
            .split('|')
            .map((c) => c.trim())
            .toList();
        if (tableBuffer == null) {
          tableBuffer = [cols];
        } else {
          tableBuffer.add(cols);
        }
        continue;
      } else if (tableBuffer != null) {
        blocks.add(_MarkdownBlock(
          type: _BlockType.table,
          content: '',
          tableRows: tableBuffer,
        ));
        tableBuffer = null;
      }

      if (trimmed.isEmpty) {
        continue;
      }

      // Headers
      if (trimmed.startsWith('### ')) {
        blocks.add(_MarkdownBlock(type: _BlockType.h3, content: trimmed.substring(4)));
      } else if (trimmed.startsWith('## ')) {
        blocks.add(_MarkdownBlock(type: _BlockType.h2, content: trimmed.substring(3)));
      } else if (trimmed.startsWith('# ')) {
        blocks.add(_MarkdownBlock(type: _BlockType.h1, content: trimmed.substring(2)));
      } else if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
        blocks.add(_MarkdownBlock(type: _BlockType.bullet, content: trimmed.substring(2)));
      } else if (RegExp(r'^\d+\.\s').hasMatch(trimmed)) {
        final match = RegExp(r'^(\d+)\.\s(.*)$').firstMatch(trimmed);
        if (match != null) {
          blocks.add(_MarkdownBlock(
            type: _BlockType.numbered,
            content: match.group(2) ?? '',
            number: int.tryParse(match.group(1) ?? '1'),
          ));
        } else {
          blocks.add(_MarkdownBlock(type: _BlockType.paragraph, content: trimmed));
        }
      } else if (trimmed.startsWith('> ')) {
        blocks.add(_MarkdownBlock(type: _BlockType.quote, content: trimmed.substring(2)));
      } else {
        blocks.add(_MarkdownBlock(type: _BlockType.paragraph, content: line));
      }
    }

    if (inCodeBlock) {
      blocks.add(_MarkdownBlock(
        type: _BlockType.code,
        content: codeBuffer.toString().trimRight(),
        language: codeLang,
      ));
    }

    if (tableBuffer != null) {
      blocks.add(_MarkdownBlock(
        type: _BlockType.table,
        content: '',
        tableRows: tableBuffer,
      ));
    }

    return blocks;
  }
}

enum _BlockType { paragraph, h1, h2, h3, bullet, numbered, quote, code, table }

class _MarkdownBlock {
  final _BlockType type;
  final String content;
  final String? language;
  final int? number;
  final List<List<String>> tableRows;

  _MarkdownBlock({
    required this.type,
    required this.content,
    this.language,
    this.number,
    this.tableRows = const [],
  });
}
