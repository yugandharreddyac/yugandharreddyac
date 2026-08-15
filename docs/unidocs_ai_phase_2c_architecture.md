# UniDocs AI — Phase 2C Architecture
## PDF Intelligence, Document Context & Grounded RAG

---

## 1. Overview & Objective

Phase 2C equips **UniDocs AI** with a production-grade document intelligence and retrieval-augmented generation (RAG) subsystem. It allows students to attach PDF lecture notes, syllabus blueprints, previous exam papers, and textbooks, querying them through conversational chat with verifiable page citations and strict anti-hallucination guardrails.

---

## 2. End-to-End Pipeline

```
[User selects PDF via FilePicker / UniDocs Resource]
                         ↓
           [DocumentProcessingProvider]
                         ↓
            [PdfDocumentExtractor]
      ├── 1. Size check (< 20 MB) & Non-empty check
      ├── 2. Magic signature validation (%PDF-)
      ├── 3. Encryption detection (/Encrypt)
      ├── 4. Page estimation (/Type /Page & /Count)
      └── 5. Byte-level stream text recovery (BT..ET, Tj, TJ)
                         ↓
              [DocumentChunker]
      ├── Page-aware chunking (preserves page numbers)
      ├── Paragraph-boundary flow
      ├── Configurable window (200 words ≈ 800–1000 chars)
      ├── Configurable overlap (30 words ≈ 120 chars)
      └── Deterministic chunk ID: {docId}_p{page}_c{index}
                         ↓
          [InMemoryDocumentRepository]
      └── Session-scoped DocumentIndex (metadata + pages + chunks)
                         ↓
           [AiComposer / AiDocumentCard]
      └── Status: ready • X pages (Quick action triggers enabled)
                         ↓
              [User submits query]
                         ↓
          [RagDocumentContextProvider]
      └── KeywordDocumentRetriever.search(query, chunks, limit=8)
            ├── Normalized query tokens & stop-word filtering
            ├── Term frequency (TF) scoring
            ├── Multi-word bigram & exact phrase boosts
            ├── Page-1 & document title boost
            └── Deduplication of overlapping excerpts
                         ↓
              [AiContextComposer]
      └── Injects grounded excerpts + strict citation instructions
                         ↓
                [GeminiProvider]
      └── Secure Cloud Function proxy (no client-side API keys)
                         ↓
                  [AiResponse]
      └── Rendered in AiMessageBubble with DocumentCitation badges
```

---

## 3. Data Models

Located in `lib/data/models/document_models.dart`:

| Model | Purpose |
|---|---|
| `DocumentSourceType` | Distinguishes `localUserFile` from verified `unidocsResource`. |
| `DocumentProcessingStatus` | Lifecycle: `idle` → `validating` → `extracting` → `chunking` → `indexing` → `ready` (or `failed`/`unsupported`). |
| `DocumentMetadata` | Contains `documentId`, `fileName`, `fileSizeBytes`, `pageCount`, `title`, `sourceType`, `createdAt`, `processingStatus`, `processingError`. |
| `DocumentPage` | Holds `pageNumber`, `extractedText`, `characterCount`. |
| `DocumentChunk` | Bounded text segment: `chunkId`, `documentId`, `pageNumber`, `text`, `startOffset`, `endOffset`, `tokenEstimate`, `metadata`. |
| `DocumentIndex` | In-memory session container unifying metadata, extracted pages, and generated chunks. |
| `DocumentSearchResult` | Ranked retrieval match: `chunk`, `relevanceScore`, `matchedTerms`, `pageNumber`. |

### Extended Citation Model
`AiCitation` in `lib/data/models/ai_response.dart` has been extended with:
- `pageNumber` (`int?`): Exact page number where the excerpt originates.
- `documentId` (`String?`): Unique identifier of the source document.
- `AiCitation.fromDocument(...)`: Convenience constructor for document citations.

---

## 4. PDF Extraction Strategy & Honest Limitations

### Extraction Implementation (`PdfDocumentExtractor`)
- Validates file existence, size (< 20 MB), and `%PDF-` signature.
- Identifies encrypted files and returns `unsupported` with a friendly error.
- Recovers digital text by parsing PDF content streams, decoding `BT...ET` text blocks, `Tj` strings, and `TJ` string arrays.
- Normalizes character encodings, whitespace, and line breaks.

### Honest OCR Limitation Notice
> **Important:** Flutter does not natively include an OCR optical character recognition engine. If a student uploads a scanned/image-only PDF without digital text layers, `PdfDocumentExtractor` detects that 0 characters were recovered and returns `DocumentProcessingStatus.unsupported` with the user-facing explanation:
> *"No readable digital text could be extracted. The PDF may be scanned or image-only."*
> The application never pretends OCR exists and never crashes.

---

## 5. Chunking Strategy (`DocumentChunker`)

1. **Page Isolation:** Chunks never span across page boundaries without explicit page number tags.
2. **Paragraph Respect:** Paragraph splits (`\n\n`) are preserved to prevent splitting mid-sentence.
3. **Sliding Window with Overlap:**
   - Target chunk size: **200 words** (~900 characters / ~260 tokens estimate).
   - Overlap: **30 words** (~135 characters / ~40 tokens estimate).
   - Minimum threshold: **15 words** (short trailing fragments are merged into the previous chunk).
4. **Deterministic Output:** Given the same pages, chunk output is 100% deterministic and reproducible.

---

## 6. Storage Decision

### In-Memory Storage (`InMemoryDocumentRepository`)
- **Decision:** Chunk text is stored strictly in-memory during the active session.
- **Rationale:** Storing multi-megabyte raw chunk text in `SharedPreferences` would bloat local key-value storage and introduce significant JSON parsing overhead on app startup.
- **Session Limits:** The repository maintains a maximum of 10 concurrent active document indices, evicting the oldest when exceeded.
- **Future Extensibility:** The `DocumentRepository` abstraction allows seamlessly replacing `InMemoryDocumentRepository` with SQLite/Drift, Isar, or Firestore in future phases without touching the UI or AI provider.

---

## 7. Retrieval Engine (`KeywordDocumentRetriever`)

Deterministic lexical search with multi-signal ranking:
1. **Token Normalization:** Lowercased, stripped of punctuation, and filtered against 70+ common English stop words.
2. **Term Frequency (TF):** Each query term match scores 1.0 base + 0.5 per additional frequency.
3. **Exact Phrase Boost:** Full query match adds **+5.0**; adjacent bigrams add **+2.0**.
4. **Context Boost:** Chunks from Page 1 receive +0.2; document title matches receive +0.3.
5. **Coverage Weighting:** Raw score is scaled by `(0.5 + termCoverage)` to reward chunks matching multiple query keywords.
6. **Deduplication:** Overlapping chunks from the same page are deduplicated.
7. **Configurable Limit:** Defaults to top 8 most relevant chunks.

---

## 8. Anti-Hallucination Guardrails & Context Rules

When documents are attached, `AiContextComposer` prepends grounded excerpts and injects strict guardrail instructions into `AiContext.systemInstructions`:

```
1. Answer using the provided document excerpts above whenever the student asks about the attached document.
2. Explicitly cite the document title and page number (e.g. "[Page X]") for factual claims.
3. If the provided document does not contain enough information to answer the question reliably, explicitly state: "I couldn't find enough information in the selected document to answer that reliably." Do not fabricate missing document content.
```

---

## 9. Security & Privacy Safeguards

- **Zero Local Paths Sent to LLM:** Only extracted text excerpts are included in prompts.
- **Zero API Keys in Flutter:** All AI calls pass through the secure Cloud Function backend proxy (`GeminiProvider`).
- **File Size Cap:** Enforced 20 MB upper limit before extraction.
- **No Automatic Uploads:** Documents remain strictly on the local device in-memory unless explicitly uploaded.
- **Sanitized IDs:** Document IDs are generated using timestamps and sanitized filenames.

---

## 10. Future Vector RAG Migration Path

`DocumentRetriever` is an abstraction designed for progressive enhancement:

```
                  DocumentRetriever (Interface)
                               │
       ┌───────────────────────┼───────────────────────┐
       ▼                       ▼                       ▼
KeywordDocumentRetriever  EmbeddingDocumentRetriever  HybridRetriever
(Phase 2C — Implemented)  (Future Phase 2D)         (Future Phase 2E)
```

No alterations to `RagDocumentContextProvider`, `AiService`, or UI widgets will be required when introducing embeddings or vector databases.
