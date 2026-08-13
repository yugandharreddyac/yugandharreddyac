# PHASE 11 — PRODUCTION CLOUDFLARE R2 DEPLOYMENT & OPERATION GUIDE

This guide details the exact manual steps required to set up Cloudflare R2 object storage, map a custom CDN domain, configure HTTP headers and CORS policies, upload academic PDFs, and connect production HTTPS resource URLs to CSSED.

---

## 1. Cloudflare R2 Bucket Setup
1. Log in to the [Cloudflare Dashboard](https://dash.cloudflare.com/).
2. Navigate to **R2 Object Storage** in the sidebar menu.
3. Click **Create Bucket**.
4. Enter bucket name: `csse-academic-resources`.
5. Select Location: **Automatic** (or preferred primary region).
6. Click **Create Bucket**.

---

## 2. Custom CDN Domain Mapping
1. In the `csse-academic-resources` bucket settings page, select **Settings**.
2. Under **Custom Domains**, click **Connect Domain**.
3. Enter custom domain: `cdn.csse-study-hub.org` (or subdomain under your registered Cloudflare zone).
4. Click **Continue** and confirm DNS CNAME record creation.
5. Cloudflare automatically issues an SSL/TLS certificate for HTTPS delivery.

---

## 3. HTTP Headers & CORS Configuration
Under bucket **Settings** $\rightarrow$ **CORS Policy**, add the following JSON configuration:

```json
[
  {
    "AllowedOrigins": [
      "https://csse-study-hub.org",
      "http://localhost:*"
    ],
    "AllowedMethods": [
      "GET",
      "HEAD"
    ],
    "AllowedHeaders": [
      "Range",
      "Content-Type",
      "Authorization"
    ],
    "ExposeHeaders": [
      "Content-Length",
      "Content-Range",
      "Accept-Ranges"
    ],
    "MaxAgeSeconds": 3600
  }
]
```

### Response Headers Rule (Cloudflare Rules)
- `Content-Type`: `application/pdf`
- `Cache-Control`: `public, max-age=31536000, immutable`
- `Access-Control-Allow-Origin`: `*`

---

## 4. Production Object Path Naming Convention

Upload PDFs following this exact folder and path hierarchy:

```
academic/
  year_1/
    sem_1_1/
      c_prog/
        unit_1/
          notes/
            unit_1_c_syntax.pdf
          pyq/
            c_prog_pyq_bank.pdf
  year_2/
    sem_2_1/
      ds/
        unit_2/
          notes/
            unit2_linked_lists.pdf
      os/
        all_units/
          textbook/
            os_concepts_galvin.pdf
  year_3/
    sem_3_1/
      cn/
        unit_3/
          lab/
            cn_lab_manual.pdf
```

---

## 5. Adding New Resources to `academic_resource_catalog.dart`

Once a PDF is uploaded to R2, add the corresponding resource object to `lib/data/datasources/academic_resource_catalog.dart`:

```dart
ResourceModel(
  id: 'pdf_cs1104_unit1_notes',
  title: 'Unit 1: C Syntax & Control Flow Notes',
  description: 'Introductory notes on C programming syntax.',
  subjectId: 'subj_1_1_4',
  subjectName: 'Computer Programming Using C',
  yearId: 'year_1',
  semesterId: 'sem_1_1',
  resourceType: 'Lecture Notes',
  sectionType: 'Quick Revision',
  chapterId: 'unit_1',
  storagePath: 'academic/year_1/sem_1_1/c_prog/unit_1/notes/unit_1_c_syntax.pdf',
  storageUrl: 'https://cdn.csse-study-hub.org/academic/year_1/sem_1_1/c_prog/unit_1/notes/unit_1_c_syntax.pdf',
  fileSizeBytes: 2457600,
  pageCount: 32,
  difficultyLevel: 'Beginner',
  sourceProvider: 'JNTUH Academic Council',
  whatIsThis: 'Introductory notes covering C syntax and loops.',
  whyUseIt: 'Start here! Essential reading for 1st-year C lab sessions.',
  estimatedStudyTime: '20 mins',
  availabilityStatus: 'available',
  copyrightTier: 'officially_provided',
)
```

---

## 6. Copyright Safety Checklist
Before uploading any PDF to Cloudflare R2:
- [ ] **Created by CSSED**: Allowed for R2 hosting.
- [ ] **Open Licensed (OER)**: Allowed if redistribution license conditions are met.
- [ ] **Public Domain**: Allowed after verifying public-domain status.
- [ ] **Officially Provided (University Papers/Syllabus)**: Allowed for public educational access.
- [ ] **External Copyrighted Textbooks**: **DO NOT UPLOAD TO R2**. Use `copyrightTier: 'external_copyrighted'` and link official external site URL (`https://...`).

---

## 7. Rollback & Emergency Strategy
If a CDN object becomes corrupt or unavailable:
1. Re-upload clean PDF file to R2 bucket under the same path.
2. Purge Cloudflare CDN Cache for that specific URL via Cloudflare Dashboard $\rightarrow$ **Caching** $\rightarrow$ **Custom Purge** $\rightarrow$ URL.
3. Mobile app will automatically fetch the updated file on next request.
