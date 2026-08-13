# PHASE 12 — PRODUCTION PUBLIC RELEASE CANDIDATE GUIDE

This guide details the complete production deployment, release candidate verification, PDF catalog update workflow, and public launch procedures for CSSED (UniDocs).

---

## 1. Production Release Workflow

### Step 1: Pre-Upload PDF Quality Audit
Before uploading any new PDF resource to Cloudflare R2:
- [ ] Confirm file is in PDF format (`.pdf`) and uncorrupted.
- [ ] Verify file size is optimized (< 25 MB per PDF).
- [ ] Perform Copyright Tier Classification (`created_by_cssed`, `open_licensed`, `public_domain`, `officially_provided`, `external_copyrighted`).
- [ ] Ensure commercial copyrighted books use official external website links (`copyrightTier: 'external_copyrighted'`).

### Step 2: R2 Storage Key Path Generation
Use `R2StorageHelper` naming conventions:
```
academic/year_{Y}/sem_{S}/{subject_code}/{unit_id}/{document_type}/{filename}.pdf
```

Example for 1st-year C Programming Unit 1 Notes:
```
academic/year_1/sem_1_1/c_prog/unit_1/notes/unit_1_c_syntax.pdf
```

### Step 3: Cloudflare R2 Upload & Header Verification
1. Upload object via Cloudflare R2 Dashboard or AWS S3 CLI (`aws s3 cp file.pdf s3://csse-academic-resources/...`).
2. Verify HTTP Response Headers:
   - `Content-Type`: `application/pdf`
   - `Cache-Control`: `public, max-age=31536000, immutable`
   - `Access-Control-Allow-Origin`: `*`

### Step 4: Updating `academic_resource_catalog.dart`
Add the resource entry to `lib/data/datasources/academic_resource_catalog.dart`. Specify:
- `id` (must be unique)
- `title` & `description`
- `subjectId`, `yearId`, `semesterId`, `chapterId`
- `storageUrl` (`https://cdn.csse-study-hub.org/academic/...`)
- `whatIsThis` & `whyUseIt` beginner callout guidance
- `estimatedStudyTime` & `difficultyLevel`
- `availabilityStatus: 'available'`

---

## 2. Automated Regression & Analyzer Checks

Run the complete test suite and static analyzer before tagging a release candidate:

```bash
# 1. Static Analyzer
flutter analyze

# 2. Production Content Test Suite
flutter test test/phase12_production_content_test.dart

# 3. Complete Test Suite (112+ Tests)
flutter test
```

---

## 3. Production Release APK / AAB Build Commands

```bash
# Build Android Release APK
flutter build apk --release

# Build Android App Bundle (for Google Play Store submission)
flutter build appbundle --release
```

---

## 4. Emergency CDN Purge & Rollback Procedure
If a remote PDF file becomes corrupted or requires immediate revision:
1. Re-upload corrected PDF to R2 bucket.
2. In Cloudflare Dashboard $\rightarrow$ **Caching** $\rightarrow$ **Custom Purge**, enter the full HTTPS URL.
3. If an emergency rollback is required, change resource `availabilityStatus` in `academic_resource_catalog.dart` to `'coming_soon'` or `'unavailable'` and push a quick hotfix.
