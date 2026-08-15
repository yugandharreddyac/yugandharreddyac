const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const cors = require('cors');
const axios = require('axios');

if (!admin.apps.length) {
  try {
    admin.initializeApp();
  } catch (e) {
    console.warn('Firebase Admin auto-init skipped:', e.message);
  }
}

const app = express();
app.use(cors({ origin: true }));
app.use(express.json({ limit: '32kb' }));

// --- In-Memory Rate Limiter (Per UID/IP: 20 req/min) ---
const rateLimitMap = new Map();
const RATE_LIMIT_WINDOW_MS = 60 * 1000;
const MAX_REQUESTS_PER_WINDOW = 20;

function checkRateLimit(identifier) {
  const now = Date.now();
  const userRecord = rateLimitMap.get(identifier) || { count: 0, resetTime: now + RATE_LIMIT_WINDOW_MS };

  if (now > userRecord.resetTime) {
    userRecord.count = 1;
    userRecord.resetTime = now + RATE_LIMIT_WINDOW_MS;
    rateLimitMap.set(identifier, userRecord);
    return true;
  }

  if (userRecord.count >= MAX_REQUESTS_PER_WINDOW) {
    return false;
  }

  userRecord.count += 1;
  rateLimitMap.set(identifier, userRecord);
  return true;
}

// Clean up stale rate limit entries periodically
setInterval(() => {
  const now = Date.now();
  for (const [key, record] of rateLimitMap.entries()) {
    if (now > record.resetTime) {
      rateLimitMap.delete(key);
    }
  }
}, 5 * 60 * 1000);

// --- Authentication Middleware ---
async function authenticateRequest(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    // If no auth token provided, check if anonymous mode allowed or reject
    req.user = { uid: 'anon_' + (req.ip || 'client') };
    return next();
  }

  const token = authHeader.split('Bearer ')[1].trim();
  try {
    const decoded = await admin.auth().verifyIdToken(token);
    req.user = decoded;
    return next();
  } catch (err) {
    // Fall back to IP identifier for rate limiting if token invalid
    req.user = { uid: 'invalid_' + (req.ip || 'client') };
    return next();
  }
}

// --- Health Check ---
app.get('/health', (req, res) => {
  const hasSecret = Boolean(process.env.GEMINI_API_KEY);
  res.status(200).json({
    status: 'healthy',
    service: 'UniDocs AI Secure Proxy',
    geminiConfigured: hasSecret,
    timestamp: new Date().toISOString(),
  });
});

// --- AI Generation Endpoint (POST /generate or POST /) ---
app.post(['/', '/generate', '/ai/generate'], authenticateRequest, async (req, res) => {
  const startTime = Date.now();
  const userId = req.user.uid || 'anonymous';

  // 1. Rate Limiting Check
  if (!checkRateLimit(userId)) {
    return res.status(429).json({
      id: `err_${Date.now()}`,
      error: {
        code: 'rate_limit_exceeded',
        message: 'Rate limit exceeded. Maximum 20 requests per minute allowed.',
        isRetryable: true,
      },
    });
  }

  // 2. Request Validation & Size Limits
  const { messages, context, capability, generationConfig } = req.body;

  if (!messages || !Array.isArray(messages) || messages.length === 0) {
    return res.status(400).json({
      id: `err_${Date.now()}`,
      error: {
        code: 'invalid_response',
        message: 'Invalid request: messages array is required and cannot be empty.',
        isRetryable: false,
      },
    });
  }

  // Enforce Max Messages and Prompt Length
  if (messages.length > 50) {
    return res.status(413).json({
      id: `err_${Date.now()}`,
      error: {
        code: 'invalid_response',
        message: 'Payload too large: Conversation history exceeds 50 messages limit.',
        isRetryable: false,
      },
    });
  }

  const latestMessage = messages[messages.length - 1];
  const userPrompt = latestMessage.content || '';
  if (userPrompt.length > 4000) {
    return res.status(413).json({
      id: `err_${Date.now()}`,
      error: {
        code: 'invalid_response',
        message: 'Payload too large: User prompt exceeds 4,000 characters limit.',
        isRetryable: false,
      },
    });
  }

  // 3. Obtain Gemini Secret (Environment or GCP Secret Manager)
  const geminiApiKey = process.env.GEMINI_API_KEY;
  if (!geminiApiKey) {
    return res.status(503).json({
      id: `resp_${Date.now()}`,
      error: {
        code: 'no_provider_configured',
        message: 'Gemini API key is not configured on the backend server.',
        details: 'Set the GEMINI_API_KEY environment variable or Google Cloud Secret.',
        isRetryable: false,
      },
    });
  }

  // 4. Construct Gemini Contents & System Instruction
  let systemText = 'You are UniDocs AI, an expert Computer Science Engineering tutor and learning mentor for B.Tech CSE students. Provide clear, pedagogical, concise explanations with code examples where helpful. Always prioritize verified UniDocs curriculum concepts.';

  if (context && context.systemInstructions) {
    systemText = context.systemInstructions;
  }

  // Append structured student context if present
  if (context && context.student) {
    systemText += `\n\nStudent Profile Context: Stage: ${context.student.academicStage || 'B.Tech CSE'}, Goal: ${(context.student.careerGoals || []).join(', ')}, Primary Language: ${context.student.primaryLanguage || 'Any'}, Weaknesses: ${(context.student.weaknesses || []).join(', ')}. Tailor your depth and recommendations accordingly.`;
  }

  if (context && context.roadmap) {
    systemText += `\n\nPersonalized Roadmap Context: Track: ${context.roadmap.roadmapTitle}, Current Phase: ${context.roadmap.currentPhaseTitle}, Progress: ${context.roadmap.overallProgressPercentage}%, Next Tasks: ${(context.roadmap.nextActionableTasks || []).join(', ')}.`;
  }

  if (context && context.unidocsResources && context.unidocsResources.length > 0) {
    const resourceTitles = context.unidocsResources.map(r => `"${r.title}" (Hub: ${r.hubName})`).join(', ');
    systemText += `\n\nVerified UniDocs Resources Grounding: ${resourceTitles}. Refer to these verified curriculum materials when applicable.`;
  }

  // Map messages to Gemini contents format
  const geminiContents = messages.map(msg => ({
    role: msg.role === 'assistant' ? 'model' : 'user',
    parts: [{ text: msg.content || '' }],
  }));

  const temperature = generationConfig && typeof generationConfig.temperature === 'number' ? generationConfig.temperature : 0.7;
  const maxOutputTokens = generationConfig && typeof generationConfig.maxTokens === 'number' ? generationConfig.maxTokens : 2048;

  const geminiPayload = {
    systemInstruction: {
      parts: [{ text: systemText }],
    },
    contents: geminiContents,
    generationConfig: {
      temperature,
      maxOutputTokens,
      topP: 0.95,
    },
  };

  // 5. Invoke Gemini 1.5 Flash API
  try {
    const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${geminiApiKey}`;
    const geminiResponse = await axios.post(geminiUrl, geminiPayload, {
      timeout: 25000,
      headers: { 'Content-Type': 'application/json' },
    });

    const data = geminiResponse.data;
    const latencyMs = Date.now() - startTime;

    const candidate = data.candidates && data.candidates[0];
    const responseText = candidate && candidate.content && candidate.content.parts && candidate.content.parts[0]
      ? candidate.content.parts[0].text
      : 'No response content returned by AI model.';

    const usageMetadata = data.usageMetadata || {};

    // 6. Return Normalized AiResponse
    return res.status(200).json({
      id: `resp_${Date.now()}`,
      message: {
        id: `msg_${Date.now()}`,
        conversationId: req.body.conversationId || `conv_${Date.now()}`,
        role: 'assistant',
        content: responseText,
        timestamp: new Date().toISOString(),
        resourceReferences: (context && context.unidocsResources) || [],
        suggestedFollowUps: [],
        isError: false,
        metadata: {
          model: 'gemini-1.5-flash',
          finishReason: candidate ? candidate.finishReason : 'STOP',
        },
      },
      usage: {
        promptTokens: usageMetadata.promptTokenCount || 0,
        completionTokens: usageMetadata.candidatesTokenCount || 0,
        totalTokens: usageMetadata.totalTokenCount || 0,
        latencyMs,
      },
      resourceReferences: (context && context.unidocsResources) || [],
      citations: [],
      suggestedFollowUps: [],
    });
  } catch (err) {
    const latencyMs = Date.now() - startTime;
    console.error('Gemini API Invocation Error:', err.response ? err.response.data : err.message);

    let errorCode = 'provider_unavailable';
    let errorMessage = 'Failed to communicate with AI provider.';
    let isRetryable = true;

    if (err.code === 'ECONNABORTED' || err.message.includes('timeout')) {
      errorCode = 'timeout';
      errorMessage = 'AI service request timed out.';
    } else if (err.response && err.response.status === 429) {
      errorCode = 'rate_limit_exceeded';
      errorMessage = 'AI provider rate limit exceeded. Please retry in a few moments.';
    } else if (err.response && err.response.status === 400) {
      errorCode = 'invalid_response';
      errorMessage = 'Invalid request parameters sent to AI model.';
      isRetryable = false;
    }

    return res.status(502).json({
      id: `resp_err_${Date.now()}`,
      error: {
        code: errorCode,
        message: errorMessage,
        details: err.response && err.response.data ? JSON.stringify(err.response.data) : err.message,
        isRetryable,
      },
    });
  }
});

// Standalone web server listener (for Render / Docker / cloud hosts)
const PORT = process.env.PORT || 8080;
if (process.env.NODE_ENV !== 'test' && (!process.env.FUNCTION_TARGET && !process.env.K_SERVICE)) {
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`UniDocs AI Backend service listening on port ${PORT}`);
  });
}

// Export Cloud Functions & Express app
try {
  exports.aiGenerate = functions.https.onRequest(app);
  exports.api = functions.https.onRequest(app);
} catch (_) {}
exports.app = app;
