/**
 * CSSE Study Hub (UniDocs) - Admin Custom Claim Setter Script
 * 
 * Usage:
 * 1. Download your Firebase Service Account Key JSON from Firebase Console:
 *    Project Settings -> Service Accounts -> Generate New Private Key
 * 2. Save it as `service-account.json` in this scripts directory.
 * 3. Run: `node scripts/set_admin_claim.js <USER_UID>`
 */

const admin = require('firebase-admin');
const path = require('path');

const serviceAccountPath = path.join(__dirname, 'service-account.json');

try {
  const serviceAccount = require(serviceAccountPath);
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
} catch (e) {
  console.error("❌ Error: 'service-account.json' not found in scripts directory.");
  console.error("Please download it from Firebase Console -> Service Accounts.");
  process.exit(1);
}

const targetUid = process.argv[2];

if (!targetUid) {
  console.log("⚠️  Usage: node scripts/set_admin_claim.js <USER_UID>");
  process.exit(1);
}

async function grantAdmin(uid) {
  try {
    await admin.auth().setCustomUserClaims(uid, { admin: true });
    
    // Also update Firestore user document role for consistency
    const db = admin.firestore();
    await db.collection('users').doc(uid).set({
      role: 'admin',
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    }, { merge: true });

    console.log(`✅ Successfully granted Admin Custom Claim to User UID: ${uid}`);
    console.log(`🔒 Security Rules will now grant instant Admin access without document lookup overhead.`);
    process.exit(0);
  } catch (error) {
    console.error("❌ Failed to set admin custom claim:", error);
    process.exit(1);
  }
}

grantAdmin(targetUid);
