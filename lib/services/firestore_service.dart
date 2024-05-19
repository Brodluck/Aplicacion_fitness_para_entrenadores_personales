// firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ventanas/models/exercise.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Exercise>> getExercises() {
    return _db.collection('exercises').snapshots().map((snapshot) => snapshot.docs.map((doc) => Exercise.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addExercise(Exercise exercise) {
    return _db.collection('exercises').add(exercise.toMap());
  }

  Future<void> addUserInfo(String userId, Map<String, dynamic> userInfo) {
    return _db.collection('users').doc(userId).set(userInfo, SetOptions(merge: true));
  }
  
}
