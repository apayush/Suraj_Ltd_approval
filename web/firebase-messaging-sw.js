// /web/firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyDqUZJE2VUOKw1jmPZWNehcItM0TZ88EDk",
  authDomain: "suraj-erp-approval.firebaseapp.com",
  projectId: "suraj-erp-approval",
  storageBucket: "suraj-erp-approval.firebasestorage.app",
  messagingSenderId: "539741752470",
  appId: "1:539741752470:web:31763217667577035f06b7",
  measurementId: "G-XKFE67V67X",
  vapidKey: "BPvRP_b53z4qV1BDn2M0GAT402QzZTv2ykGNeKbVjhlXhV-HUd6V3CcG0DF2nCd8hHCv-nEfukkqDedw1hvv-ZI" // Replace it from Firebase Console
});

const messaging = firebase.messaging();
