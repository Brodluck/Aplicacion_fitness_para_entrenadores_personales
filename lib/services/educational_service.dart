// educational_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ventanas/models/educational_content.dart';

class EducationalService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<EducationalContent>> getEducationalContent() {
    return _db.collection('educational_content').snapshots().map((snapshot) => snapshot.docs.map((doc) => EducationalContent.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addEducationalContent(EducationalContent content) {
    return _db.collection('educational_content').add(content.toMap());
  }
}
