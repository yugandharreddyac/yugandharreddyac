# UniDocs AI — Core Architecture & System Design Document (Phase 1 & Phase 2A)

## 1. Executive Overview

**UniDocs AI** is designed as a foundational, general-purpose educational and career intelligence engine inside the **UniDocs (CSSE Study Hub)** Flutter application. Rather than serving as a narrow PDF summarizer or a simple question-answering widget, UniDocs AI is structured to unify:
- General Computer Science concepts and educational explanations.
- Verified UniDocs 4-Year B.Tech curriculum and Beyond Academics hub data.
- Personalized learning roadmaps, current student phases, and daily tasks.
- Future document understanding (syllabus PDFs, lecture notes, textbook chapters) via RAG.
- Multi-provider AI models (Gemini, Claude, OpenAI, Local AI) behind a strict vendor-agnostic abstraction layer.
- **Secure Backend Cloud Function Proxy** guaranteeing zero API keys on client devices.

---

## 2. Architecture Diagram

```
                              ┌────────────────────────┐
                              │  UniDocs UI & Features │
                              │ (Roadmap, Hubs, Notes) │
                              └───────────┬────────────┘
                                          │
                                          ▼
                              ┌────────────────────────┐
                              │   UniDocsAiProvider    │
                              │ (Presentation State)   │
                              └───────────┬────────────┘
                                          │
                                          ▼
                              ┌────────────────────────┐
                              │       AiService        │
                              │ (Orchestration Layer)  │
                              └───┬────────────────┬───┘
                                  │                │
            ┌─────────────────────┴──────┐         │
            ▼                            ▼         ▼
┌────────────────────────┐  ┌──────────────────────────────────┐
│ AiConversationRepo     │  │        AiContextComposer         │
│ (Partitioned Storage)  │  │   (Context & Anti-Hallucination) │
└────────────────────────┘  └──────────────────┬───────────────┘
                                               │
             ┌───────────────────┬─────────────┴───────┬───────────────────┐
             ▼                   ▼                     ▼                   ▼
    ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
    │ Student Context │ │ Roadmap Context │ │ UniDocs Resource│ │ Document Context│
    │ (Profile/Goals) │ │ (Phase & Tasks) │ │ (Verified Hubs) │ │ (Future RAG)    │
    └─────────────────┘ └─────────────────┘ └─────────────────┘ └─────────────────┘
                                               │
                                               ▼
                              ┌────────────────────────┐
                              │       AiRequest        │
                              └───────────┬────────────┘
                                          │
                                          ▼
                              ┌────────────────────────┐
                              │  AiProvider Interface  │
                              └───────────┬────────────┘
                                          │
            ┌────────────────────┬────────┴────────────┬────────────────────┐
            ▼                    ▼                     ▼                    ▼
   ┌─────────────────┐  ┌─────────────────┐  ┌──────────────────┐  ┌────────────────┐
   │ NoOpAiProvider  │  │ GeminiProvider  │  │   OpenAI Proxy   │  │  Claude / Local│
   │ (Phase 1 Base)  │  │ (Phase 2A Real) │  │ (Future Phase 2B)│  │(Future Phase 2B)│
   └─────────────────┘  └────────┬────────┘  └──────────────────┘  └────────────────┘
                                 │
                                 ▼ (HTTPS + Bearer Auth Token)
                    ┌────────────────────────┐
                    │ Firebase Cloud Function│
                    │  (aiGenerate Endpoint) │
                    └────────────┬───────────┘
                                 │
                    ┌────────────┴───────────┐
                    ▼                        ▼
        ┌───────────────────────┐  ┌────────────────────────┐
        │  GCP Secret Manager   │  │   Gemini 1.5 Flash API │
        │   (GEMINI_API_KEY)    │  │ (Google Cloud Endpoint)│
        └───────────────────────┘  └────────────────────────┘
```

---

## 3. Provider Abstraction & Vendor-Agnostic Design

UniDocs enforces strict separation between domain logic and external AI vendors:
1. **Interface Contract (`AiProvider`)**:
   - Declares `generateResponse(AiRequest request)`, `streamResponse(AiRequest request)`, `checkHealth()`, and `supportedCapabilities`.
   - Domain layers and UI never import vendor SDKs or specific client libraries directly.
2. **Phase 1 Baseline (`NoOpAiProvider`)**:
   - Acts as the default safe fallback when no external backend is connected.
   - Returns structured `AiErrorCode.noProviderConfigured` without throwing exceptions or crashing the application.
3. **Phase 2A Real Provider (`GeminiProvider`)**:
   - Implements `AiProvider` communicating exclusively with the secure Cloud Function proxy via `Dio`.
   - Injects Firebase Auth ID Token automatically if user is authenticated.
   - Handles network timeouts (10s connect, 30s receive), 401 Auth errors, 429 Rate limits, and server error normalizations.
4. **Pluggability & Replacement Strategy**:
   - Switching providers (e.g. from Gemini to Claude or OpenAI) requires zero changes to UI, state providers, or conversation repositories.
   - Provider replacement is handled simply by configuring or injecting a new `AiProvider` implementation into `AiService`.

---

## 4. Context Composition & Multi-Source Precedence

UniDocs AI enforces an explicit 5-tier context precedence model:

| Priority Rank | Context Tier | Description & Behavior |
| :---: | :--- | :--- |
| **Tier 1** | **Explicit User Query** | The direct user prompt defines the core objective and task format. |
| **Tier 2** | **UniDocs Verified Resources** | Grounded curriculum topics, syllabus nodes, and hub references from `NonAcademicData` take precedence for technical learning content. |
| **Tier 3** | **Personalized Student Profile & Roadmap** | Active roadmap phase, completed skills, identified weaknesses, and daily learning minutes guide the pedagogy, pacing, and tone. |
| **Tier 4** | **Attached Document / PDF Context** | Extracted text and verified page snippets guide document-specific Q&A without leaking irrelevant external data. |
| **Tier 5** | **General Model Knowledge** | Foundational world and programming knowledge used for broad conceptual explanations without fabricating UniDocs-specific identifiers. |

---

## 5. Security Architecture & Zero Client-Side Secrets

1. **Zero Hardcoded Secrets**:
   - No Gemini API keys or service account credentials exist in Flutter source code, dart-define flags, assets, or git.
2. **Authenticated Proxy (`functions/index.js`)**:
   - Validates client's Firebase Auth ID token (`Authorization: Bearer <token>`) using Firebase Admin SDK.
   - Accesses `GEMINI_API_KEY` strictly on the server through Google Cloud Secret Manager (`process.env.GEMINI_API_KEY`).
3. **Abuse Protection & Rate Limiting**:
   - Enforces per-user / per-IP rate limits (max 20 requests per minute).
   - Enforces payload size limits:
     - Max 4,000 characters per user prompt.
     - Max 50 conversation messages in history.
     - Max 32KB total request payload.
4. **Sanitized Logging**:
   - Operational logs record only latency, token counts, request IDs, and error categories without logging private conversation transcripts or credentials.

---

## 6. Anti-Hallucination & UniDocs Resource Grounding

To guarantee zero hallucinated routes, IDs, or fake PDF links:
1. **Resource References (`AiResourceReference`)**:
   - Structured metadata containing `id`, `title`, `hubName`, `route`, and verified `routeArguments`.
2. **Catalog Validation**:
   - All suggested hub topics are resolved against `NonAcademicData.findTopicById(id)` or official academic catalogs.
3. **Guardrail Directives**:
   - System prompts explicitly instruct the model to never invent route names or resource keys not present in the structured context.

---

## 7. Conversation Persistence & Storage Partitioning

Implemented in `LocalAiConversationRepository`:
- **Partitioned Storage Keys**:
  - `unidocs_ai_conversations_index`: Stores lightweight metadata (IDs, titles, timestamps, token counts) for fast sidebar/history listing.
  - `unidocs_ai_conv_{id}`: Stores full message payloads on demand.
- **Memory & Storage Caps**:
  - Max 50 conversations indexed.
  - Max 100 messages per conversation (oldest truncated when limit exceeded).
- **Future Migration Ready**:
  - The repository interface allows effortless drop-in migration to SQLite (`sqflite`), Hive, or Cloud Firestore in Phase 2+.

---

## 8. Error Handling Matrix

| Error Code (`AiErrorCode`) | Trigger Condition | Application Handling |
| :--- | :--- | :--- |
| `noProviderConfigured` | Backend URL empty or not configured | Graceful UI message; zero crashes |
| `authenticationFailed` | Expired or invalid Firebase ID token (401/403) | Prompts user to sign in or re-authenticates |
| `rateLimitExceeded` | User quota or server rate limit exceeded (429) | Exponential backoff guidance message |
| `invalidResponse` | Prompt > 4,000 chars or payload > 32KB (413) | Clear size limit guidance to user |
| `timeout` | Model latency > 30s | Non-blocking retryable error card |
| `networkUnavailable` | Device offline | Offline cache access; retry prompt |
| `providerUnavailable` | Gemini API or Cloud Function down (502/503) | Graceful fallback error banner |

---

## 9. Future Roadmap (Phase 2B+)

- **Phase 2B**: Conversational Chat UI with rich Markdown, code block syntax highlighting, copy buttons, and interactive topic navigation chips.
- **Phase 3**: Client-side / Cloud PDF text extraction and chunking for syllabus and notes Q&A.
- **Phase 4**: Vector embeddings and semantic RAG retriever across UniDocs academic repository.
