// chat_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ventanas/models/message.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Message>> getMessages(String chatId) {
    return _db.collection('chats/$chatId/messages').orderBy('timestamp').snapshots().map((snapshot) => snapshot.docs.map((doc) => Message.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> sendMessage(String chatId, Message message) {
    return _db.collection('chats/$chatId/messages').add(message.toMap());
  }
}
