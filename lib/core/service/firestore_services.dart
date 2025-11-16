// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// class FireStoreService {
//   static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   /// 1. Initialize Firebase
//   static Future<void> initialize() async {
//     await Firebase.initializeApp();
//   }
//
//   /// 2. Get the base URL from Firestore
//   static Future<String?> getBaseUrl() async {
//     try {
//       final doc = FirebaseFirestore.instance.collection('config').doc('settings');
//       final snapshot = await doc.get();
//
//       if (snapshot.exists && snapshot.data() != null) {
//         return snapshot['baseUrl'] as String?;
//       }
//     } catch (e) {
//       print('❌ Error getting base URL: $e');
//     }
//     return null;
//   }
//
//   /// 3. Update the base URL in Firestore
//   static Future<void> updateBaseUrl(String newUrl) async {
//     try {
//       await _firestore.collection('config').doc('settings').set({
//         'baseUrl': newUrl,
//       }, SetOptions(merge: true));
//       print('✅ Base URL updated to: $newUrl');
//     } catch (e) {
//       print('❌ Error updating base URL: $e');
//     }
//   }
// }
