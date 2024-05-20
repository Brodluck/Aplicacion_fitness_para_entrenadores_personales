import 'package:ventanas/models/message.dart';
import 'package:ventanas/services/json_utils.dart';

class ChatService {
  static const String _chatsFileName = 'chats';

  Future<List<Map<String, dynamic>>> getChatRooms(String userId) async {
    await JsonUtils.synchronizeJson(_chatsFileName);
    final data = await JsonUtils.readFromLocalJson(_chatsFileName);
    final List<Map<String, dynamic>> chatRooms = [];
    if (data.containsKey('chatRooms')) {
      for (var chatRoom in data['chatRooms']) {
        if (chatRoom['participants'].contains(userId)) {
          chatRooms.add(chatRoom);
        }
      }
    }
    return chatRooms;
  }

  Future<List<Message>> getMessages(String chatRoomId) async {
    await JsonUtils.synchronizeJson(_chatsFileName);
    final data = await JsonUtils.readFromLocalJson(_chatsFileName);
    final List<Message> messages = [];
    if (data.containsKey('messages')) {
      for (var messageData in data['messages']) {
        if (messageData['chatRoomId'] == chatRoomId) {
          messages.add(Message.fromMap(messageData, messageData['id']));
        }
      }
    }
    return messages;
  }

  Future<void> sendMessage(Message message) async {
    await JsonUtils.synchronizeJson(_chatsFileName);
    final data = await JsonUtils.readFromLocalJson(_chatsFileName);
    data['messages'] = (data['messages'] ?? [])..add(message.toMap());
    await JsonUtils.saveToLocalJson(_chatsFileName, data);
  }

  Future<String> createChatRoom(List<String> participants) async {
    await JsonUtils.synchronizeJson(_chatsFileName);
    final data = await JsonUtils.readFromLocalJson(_chatsFileName);
    final String chatRoomId = DateTime.now().millisecondsSinceEpoch.toString(); // Generate unique ID
    final chatRoom = {
      'id': chatRoomId,
      'participants': participants,
    };
    data['chatRooms'] = (data['chatRooms'] ?? [])..add(chatRoom);
    await JsonUtils.saveToLocalJson(_chatsFileName, data);
    return chatRoomId;
  }

  Future<void> createChat(String senderId, String receiverId, String content) async {
    final chatRoomId = await createChatRoom([senderId, receiverId]);
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
      chatRoomId: chatRoomId,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      timestamp: DateTime.now(),
    );
    await sendMessage(message);
  }
}
