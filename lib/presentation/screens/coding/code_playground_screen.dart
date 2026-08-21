import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/code_execution_service.dart';

class CodePlaygroundScreen extends StatefulWidget {
  final SupportedLanguage? initialLanguage;
  final String? initialCode;

  const CodePlaygroundScreen({
    super.key,
    this.initialLanguage,
    this.initialCode,
  });

  @override
  State<CodePlaygroundScreen> createState() => _CodePlaygroundScreenState();
}

class _CodePlaygroundScreenState extends State<CodePlaygroundScreen> {
  final CodeExecutionService _service = CodeExecutionService();
  late SupportedLanguage _selectedLanguage;
  late TextEditingController _codeController;
  final TextEditingController _stdinController = TextEditingController();

  ExecutionResult? _executionResult;
  bool _isExecuting = false;
  bool _showStdin = false;
  List<CodeSnippetModel> _savedSnippets = [];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.initialLanguage ?? SupportedLanguage.python;
    _codeController = TextEditingController(
      text: widget.initialCode ?? _selectedLanguage.defaultTemplate,
    );
    _loadSavedSnippets();
  }

  Future<void> _loadSavedSnippets() async {
    final list = await _service.getSavedSnippets();
    if (mounted) {
      setState(() {
        _savedSnippets = list;
      });
    }
  }

  void _onLanguageChanged(SupportedLanguage lang) {
    setState(() {
      _selectedLanguage = lang;
      _codeController.text = lang.defaultTemplate;
      _executionResult = null;
    });
  }

  void _loadPreset(String presetTitle) {
    final code = CodeExecutionService.presets[_selectedLanguage]?[presetTitle];
    if (code != null) {
      setState(() {
        _codeController.text = code;
        _executionResult = null;
      });
    }
  }

  Future<void> _runCode() async {
    setState(() {
      _isExecuting = true;
    });

    final result = await _service.executeCode(
      language: _selectedLanguage,
      code: _codeController.text,
      stdin: _stdinController.text,
    );

    if (mounted) {
      setState(() {
        _isExecuting = false;
        _executionResult = result;
      });
    }
  }

  void _saveCurrentSnippet() async {
    final titleController =
        TextEditingController(text: '${_selectedLanguage.displayName} Snippet');

    final save = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Save Code Snippet'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Snippet Title',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (save == true && mounted) {
      final snippet = CodeSnippetModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text.trim().isNotEmpty
            ? titleController.text.trim()
            : 'Untitled Snippet',
        language: _selectedLanguage,
        code: _codeController.text,
        stdin: _stdinController.text,
        createdAt: DateTime.now(),
      );

      await _service.saveSnippet(snippet);
      await _loadSavedSnippets();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Code snippet saved to local storage!')),
        );
      }
    }
  }

  void _showSavedSnippetsSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saved Snippets (${_savedSnippets.length})',
                        style: GoogleFonts.inter(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_savedSnippets.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                            'No saved snippets yet. Tap Save Icon to bookmark code!'),
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _savedSnippets.length,
                        itemBuilder: (context, index) {
                          final s = _savedSnippets[index];
                          return ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(25),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.code_rounded,
                                  color: AppColors.primary, size: 20),
                            ),
                            title: Text(s.title,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              '${s.language.displayName} • ${s.createdAt.day}/${s.createdAt.month}/${s.createdAt.year}',
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline_rounded,
                                  color: Colors.redAccent, size: 20),
                              onPressed: () async {
                                await _service.deleteSnippet(s.id);
                                await _loadSavedSnippets();
                                setSheetState(() {});
                                setState(() {});
                              },
                            ),
                            onTap: () {
                              setState(() {
                                _selectedLanguage = s.language;
                                _codeController.text = s.code;
                                _stdinController.text = s.stdin;
                                _executionResult = null;
                              });
                              Navigator.pop(ctx);
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _stdinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle =
        isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    const orangeAccent = AppColors.primary;
    const editorBg = Color(0xFF0F172A);
    const terminalBg = Color(0xFF020617);

    final availablePresets =
        CodeExecutionService.presets[_selectedLanguage]?.keys.toList() ?? [];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Coding Sandbox & Playground',
          style: GoogleFonts.inter(
              fontWeight: FontWeight.bold, fontSize: 18, color: textPrimary),
        ),
        centerTitle: false,
        backgroundColor: cardColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open_rounded),
            tooltip: 'Saved Snippets',
            onPressed: _showSavedSnippetsSheet,
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            tooltip: 'Save Current Code',
            onPressed: _saveCurrentSnippet,
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            tooltip: 'Copy Code',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _codeController.text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Code copied to clipboard!')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Control Bar: Language Selector & Preset Algorithms
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                // Language Dropdown
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<SupportedLanguage>(
                      value: _selectedLanguage,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      items: SupportedLanguage.values.map((lang) {
                        return DropdownMenuItem(
                          value: lang,
                          child: Text(
                            lang.displayName,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: textPrimary),
                          ),
                        );
                      }).toList(),
                      onChanged: (lang) {
                        if (lang != null) _onLanguageChanged(lang);
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Preset Algorithms Dropdown
                if (availablePresets.isNotEmpty)
                  PopupMenuButton<String>(
                    tooltip: 'Load Algorithm Example',
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onSelected: _loadPreset,
                    itemBuilder: (ctx) => availablePresets.map((title) {
                      return PopupMenuItem(
                        value: title,
                        child:
                            Text(title, style: GoogleFonts.inter(fontSize: 13)),
                      );
                    }).toList(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: orangeAccent.withAlpha(isDark ? 35 : 20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_stories_rounded,
                              size: 14, color: orangeAccent),
                          const SizedBox(width: 6),
                          Text(
                            'Examples',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: orangeAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(width: 8),

                // Stdin Toggle Button
                IconButton(
                  icon: Icon(
                    _showStdin
                        ? Icons.input_rounded
                        : Icons.keyboard_alt_outlined,
                    color: _showStdin ? orangeAccent : textSubtitle,
                    size: 20,
                  ),
                  tooltip: 'Custom Stdin Input',
                  onPressed: () => setState(() => _showStdin = !_showStdin),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Custom Stdin Box (Optional)
          if (_showStdin) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Standard Input (stdin):',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: textSubtitle),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _stdinController,
                    maxLines: 2,
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 12, color: textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Enter test inputs here (numbers, strings)...',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Dark Themed Code Editor Container
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: editorBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              children: [
                // Editor Tab Bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(17)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                                color: Color(0xFFF59E0B),
                                shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'main.${_selectedLanguage.extension}',
                            style: GoogleFonts.jetBrainsMono(
                                fontSize: 12, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _codeController.text =
                                _selectedLanguage.defaultTemplate;
                            _executionResult = null;
                          });
                        },
                        icon: const Icon(Icons.restart_alt_rounded,
                            size: 14, color: Colors.grey),
                        label: Text('Reset',
                            style: GoogleFonts.inter(
                                fontSize: 11, color: Colors.grey)),
                      ),
                    ],
                  ),
                ),

                // Editor TextArea
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _codeController,
                      maxLines: null,
                      expands: true,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 13,
                        height: 1.5,
                        color: const Color(0xFFF8FAFC),
                      ),
                      cursorColor: orangeAccent,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Run Code Action Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _isExecuting ? null : _runCode,
              icon: _isExecuting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow_rounded, size: 22),
              label: Text(
                _isExecuting
                    ? 'Compiling & Executing...'
                    : 'Execute & Run Code',
                style: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Output Terminal
          Container(
            decoration: BoxDecoration(
              color: terminalBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Terminal Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F172A),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(17)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.terminal_rounded,
                              size: 16, color: Color(0xFF10B981)),
                          const SizedBox(width: 8),
                          Text(
                            'Output Terminal (stdout)',
                            style: GoogleFonts.jetBrainsMono(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade300),
                          ),
                        ],
                      ),
                      if (_executionResult != null)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${_executionResult!.executionTimeMs}ms',
                                style: GoogleFonts.jetBrainsMono(
                                    fontSize: 10, color: Colors.greenAccent),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${_executionResult!.memoryUsageMb} MB',
                                style: GoogleFonts.jetBrainsMono(
                                    fontSize: 10, color: Colors.blueAccent),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                // Terminal Body
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: _executionResult == null
                      ? Text(
                          'Ready. Click "Execute & Run Code" to compile and run output in sandbox.',
                          style: GoogleFonts.jetBrainsMono(
                              fontSize: 12, color: Colors.grey.shade600),
                        )
                      : SelectableText(
                          _executionResult!.isSuccess
                              ? _executionResult!.stdout
                              : _executionResult!.stderr,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 13,
                            height: 1.45,
                            color: _executionResult!.isSuccess
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFFF87171),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
