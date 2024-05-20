import 'dart:async';
import 'package:ventanas/models/message.dart';
import 'package:ventanas/services/json_utils.dart';

class ChatService {
  static const String _chatsFileName = 'chats';
  final StreamController<List<Message>> _messageController = StreamController<List<Message>>.broadcast();

  Stream<List<Message>> getMessagesStream(String chatRoomId) {
    // Debugging statement
    print('getMessagesStream called for chatRoomId: $chatRoomId');
    _fetchAndAddMessages(chatRoomId); // Ensure initial fetch
    return _messageController.stream;
  }

  Future<void> _fetchAndAddMessages(String chatRoomId) async {
    final messages = await getMessages(chatRoomId);
    _messageController.add(messages);
  }

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
    // Debugging statement
    print('Fetched ${messages.length} messages for chatRoomId: $chatRoomId');
    return messages;
  }

  Future<void> sendMessage(Message message) async {
    await JsonUtils.synchronizeJson(_chatsFileName);
    final data = await JsonUtils.readFromLocalJson(_chatsFileName);
    data['messages'] = (data['messages'] ?? [])..add(message.toMap());
    await JsonUtils.saveToLocalJson(_chatsFileName, data);

    // Get updated messages and add to the stream
    _fetchAndAddMessages(message.chatRoomId);
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

  void dispose() {
    _messageController.close();
  }
}
