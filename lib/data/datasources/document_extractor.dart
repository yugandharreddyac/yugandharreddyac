import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import '../models/document_models.dart';

/// Contract for document text extraction and metadata inspection
abstract class DocumentExtractor {
  static const int maxFileSizeBytes = 20 * 1024 * 1024; // 20 MB limit
  static const int maxPages = 300;

  /// Inspects and extracts metadata for the specified document
  Future<DocumentMetadata> extractMetadata(String filePath, String fileName,
      {DocumentSourceType sourceType = DocumentSourceType.localUserFile});

  /// Extracts readable pages with text content from the document
  Future<List<DocumentPage>> extractPages(
      String filePath, DocumentMetadata metadata);
}

/// Concrete PDF document extractor with byte-level text recovery and security validations
class PdfDocumentExtractor implements DocumentExtractor {
  const PdfDocumentExtractor();

  @override
  Future<DocumentMetadata> extractMetadata(
    String filePath,
    String fileName, {
    DocumentSourceType sourceType = DocumentSourceType.localUserFile,
  }) async {
    final now = DateTime.now();
    final docId =
        'doc_${now.millisecondsSinceEpoch}_${fileName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}';

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return DocumentMetadata(
          documentId: docId,
          fileName: fileName,
          sourceType: sourceType,
          createdAt: now,
          processingStatus: DocumentProcessingStatus.failed,
          processingError:
              'The selected file could not be found at path: $filePath',
        );
      }

      final fileSize = await file.length();
      if (fileSize == 0) {
        return DocumentMetadata(
          documentId: docId,
          fileName: fileName,
          fileSizeBytes: 0,
          sourceType: sourceType,
          createdAt: now,
          processingStatus: DocumentProcessingStatus.failed,
          processingError: 'The selected PDF file is empty (0 bytes).',
        );
      }

      if (fileSize > DocumentExtractor.maxFileSizeBytes) {
        final sizeMb = (fileSize / (1024 * 1024)).toStringAsFixed(1);
        return DocumentMetadata(
          documentId: docId,
          fileName: fileName,
          fileSizeBytes: fileSize,
          sourceType: sourceType,
          createdAt: now,
          processingStatus: DocumentProcessingStatus.failed,
          processingError:
              'File size ($sizeMb MB) exceeds the 20 MB maximum limit for document analysis.',
        );
      }

      // Read header to validate PDF magic signature %PDF-
      final raf = await file.open(mode: FileMode.read);
      try {
        final headerBytes = await raf.read(1024);
        final headerStr = String.fromCharCodes(headerBytes);

        if (!headerStr.contains('%PDF-')) {
          return DocumentMetadata(
            documentId: docId,
            fileName: fileName,
            fileSizeBytes: fileSize,
            sourceType: sourceType,
            createdAt: now,
            processingStatus: DocumentProcessingStatus.unsupported,
            processingError:
                'The file does not appear to be a valid PDF document (missing PDF signature).',
          );
        }

        // Check if encrypted
        if (headerStr.contains('/Encrypt') ||
            headerStr.contains('/Encrypt 0 R')) {
          return DocumentMetadata(
            documentId: docId,
            fileName: fileName,
            fileSizeBytes: fileSize,
            sourceType: sourceType,
            createdAt: now,
            processingStatus: DocumentProcessingStatus.unsupported,
            processingError:
                'Password-protected or encrypted PDFs are not supported.',
          );
        }
      } finally {
        await raf.close();
      }

      // Count pages approximately by scanning /Type /Page (excluding /Pages)
      final allBytes = await file.readAsBytes();
      final pageCount = _estimatePageCount(allBytes);

      return DocumentMetadata(
        documentId: docId,
        fileName: fileName,
        fileSizeBytes: fileSize,
        pageCount: pageCount,
        title: _cleanDocumentTitle(fileName),
        sourceType: sourceType,
        createdAt: now,
        processingStatus: DocumentProcessingStatus.validating,
      );
    } catch (e) {
      return DocumentMetadata(
        documentId: docId,
        fileName: fileName,
        sourceType: sourceType,
        createdAt: now,
        processingStatus: DocumentProcessingStatus.failed,
        processingError: 'Failed to inspect document: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<DocumentPage>> extractPages(
      String filePath, DocumentMetadata metadata) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return [];

      final bytes = await file.readAsBytes();
      final pages = _extractTextPagesFromBytes(bytes, metadata.pageCount);

      if (pages.isEmpty || pages.every((p) => p.isEmpty)) {
        return const [
          DocumentPage(
            pageNumber: 1,
            extractedText: '',
          )
        ];
      }

      return pages;
    } catch (_) {
      return [];
    }
  }

  int _estimatePageCount(Uint8List bytes) {
    try {
      final raw = latin1.decode(bytes, allowInvalid: true);

      // Look for /Count in /Pages dictionary
      final countMatch =
          RegExp(r'/Type\s*/Pages.*?/Count\s+(\d+)', dotAll: true)
              .firstMatch(raw);
      if (countMatch != null) {
        final count = int.tryParse(countMatch.group(1) ?? '1');
        if (count != null && count > 0)
          return count.clamp(1, DocumentExtractor.maxPages);
      }

      // Fallback: count /Type /Page occurrences (avoiding /Pages)
      final pageMatches = RegExp(r'/Type\s*/Page\b').allMatches(raw);
      if (pageMatches.isNotEmpty) {
        return pageMatches.length.clamp(1, DocumentExtractor.maxPages);
      }
    } catch (_) {}
    return 1;
  }

  List<DocumentPage> _extractTextPagesFromBytes(
      Uint8List bytes, int expectedPages) {
    final raw = latin1.decode(bytes, allowInvalid: true);

    // Split text by page delimiters if possible
    final pageSegments = _splitIntoPageSegments(raw, expectedPages);
    final results = <DocumentPage>[];

    for (int i = 0; i < pageSegments.length; i++) {
      final text = _extractTextFromSegment(pageSegments[i]);
      results.add(
        DocumentPage(
          pageNumber: i + 1,
          extractedText: text.trim(),
        ),
      );
    }

    return results;
  }

  List<String> _splitIntoPageSegments(String raw, int expectedPages) {
    // Look for stream markers or /Type /Page markers
    final pageSplits = raw.split(RegExp(r'/Type\s*/Page\b'));
    if (pageSplits.length > 1) {
      // First split is header before first page object
      return pageSplits.sublist(1);
    }

    // Fallback: split streams
    final streamSplits = raw.split('stream');
    if (streamSplits.length > 1) {
      return streamSplits.sublist(1);
    }

    return [raw];
  }

  String _extractTextFromSegment(String segment) {
    final buffer = StringBuffer();

    // 1. Match BT (Begin Text) ... ET (End Text) blocks
    final btMatches =
        RegExp(r'BT\s*(.*?)\s*ET', dotAll: true).allMatches(segment);
    for (final bt in btMatches) {
      final block = bt.group(1) ?? '';
      _extractTextFromOperators(block, buffer);
    }

    // 2. Fallback: If no BT..ET blocks found, extract literal strings directly
    if (buffer.isEmpty) {
      final stringMatches = RegExp(r'\(([^)]+)\)').allMatches(segment);
      for (final m in stringMatches) {
        final str = m.group(1);
        if (str != null && _isReadableText(str)) {
          buffer.write('$str ');
        }
      }
    }

    return _sanitizeExtractedText(buffer.toString());
  }

  void _extractTextFromOperators(String block, StringBuffer buffer) {
    // Look for Tj, TJ, ', " operators
    // e.g. (Hello World) Tj or [(Hello) 10 (World)] TJ
    final tjMatches = RegExp(r'\((.*?)\)\s*(?:Tj|\x27|\x22)').allMatches(block);
    for (final m in tjMatches) {
      final str = m.group(1);
      if (str != null && str.isNotEmpty) {
        buffer.write('${_unescapePdfString(str)} ');
      }
    }

    // Look for array TJ operators: [(Part1) 120 (Part2)] TJ
    final arrayTjMatches =
        RegExp(r'\[(.*?)\]\s*TJ', dotAll: true).allMatches(block);
    for (final m in arrayTjMatches) {
      final arrayContent = m.group(1) ?? '';
      final innerStrings = RegExp(r'\((.*?)\)').allMatches(arrayContent);
      for (final s in innerStrings) {
        final part = s.group(1);
        if (part != null && part.isNotEmpty) {
          buffer.write('${_unescapePdfString(part)} ');
        }
      }
      buffer.writeln();
    }
  }

  String _unescapePdfString(String str) {
    return str
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\r', '\r')
        .replaceAll(r'\t', '\t')
        .replaceAll(r'\(', '(')
        .replaceAll(r'\)', ')')
        .replaceAll(r'\\', r'\');
  }

  bool _isReadableText(String s) {
    if (s.length < 2) return false;
    // Check if at least 70% characters are ASCII letters, numbers, punctuation or whitespace
    int readable = 0;
    for (int i = 0; i < s.length; i++) {
      final code = s.codeUnitAt(i);
      if ((code >= 32 && code <= 126) ||
          code == 10 ||
          code == 13 ||
          code == 9) {
        readable++;
      }
    }
    return (readable / s.length) >= 0.7;
  }

  String _sanitizeExtractedText(String text) {
    return text
        .replaceAll(RegExp(r'[ \t]+'), ' ')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  String _cleanDocumentTitle(String fileName) {
    var title = fileName;
    if (title.toLowerCase().endsWith('.pdf')) {
      title = title.substring(0, title.length - 4);
    }
    return title.replaceAll('_', ' ').replaceAll('-', ' ').trim();
  }
}
