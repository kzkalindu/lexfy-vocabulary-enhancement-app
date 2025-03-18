import admin from 'firebase-admin';
import { getFirestore } from 'firebase-admin/firestore';
import dotenv from 'dotenv';

dotenv.config();

const serviceAccount =  process.env.FIREBASE_SERVICE_ACCOUNT;

if (admin.apps.length === 0) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),  // Proper usage of cert
    }); }
const db = getFirestore();

export default db;