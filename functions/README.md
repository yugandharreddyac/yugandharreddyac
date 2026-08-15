# UniDocs AI — Cloud Functions Backend Proxy

This directory contains the secure backend proxy for **UniDocs AI**. It serves as an authenticated intermediary between the Flutter application and AI model APIs (such as Google Gemini 1.5 Flash), ensuring **zero API keys are exposed to client devices**.

---

## 1. Security Architecture

- **Client Authentication**: Verifies incoming `Authorization: Bearer <Firebase_ID_Token>` using Firebase Admin SDK.
- **Secret Protection**: The `GEMINI_API_KEY` is loaded from Google Cloud Secret Manager or environment secrets on the server.
- **Abuse Prevention & Rate Limiting**: Enforces a limit of 20 requests per minute per user identity/IP.
- **Request Size Guardrails**: Max 4,000 characters per prompt, max 50 conversation messages, max 32KB payload.

---

## 2. Configuration & Deployment

### Setting Secret in Google Cloud Secret Manager
```bash
firebase functions:secrets:set GEMINI_API_KEY
```

### Local Testing with Firebase Emulator
```bash
cd functions
npm install
npm run serve
```

### Production Deployment
```bash
firebase deploy --only functions:aiGenerate
```
