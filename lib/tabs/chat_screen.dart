// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ventanas/models/user.dart';
import 'package:ventanas/services/chat_service.dart';
import 'package:ventanas/models/message.dart';
import 'package:ventanas/services/json_utils.dart';
import 'package:ventanas/widgets/client_messsage.dart';
import 'package:ventanas/widgets/trainer_message.dart';

class ChatScreen extends StatelessWidget {
  final String chatRoomId;
  final String userId;
  final String receiverId;

  const ChatScreen({super.key, required this.chatRoomId, required this.userId, required this.receiverId});

  @override
  Widget build(BuildContext context) {
      final chatService = Provider.of<ChatService>(context);
    final TextEditingController messageController = TextEditingController();

    void _sendMessage() async {
      final String content = messageController.text;
      if (content.isNotEmpty) {
        final message = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          chatRoomId: chatRoomId,
          senderId: userId,
          receiverId: receiverId,
          content: content,
          timestamp: DateTime.now(),
        );
        await chatService.sendMessage(message);
        messageController.clear();
      }
    }

    return FutureBuilder<User?>(
      future: JsonUtils.getUserById(receiverId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: const Center(child: Text('Error occurred')),
          );
        }
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('No User Found'),
            ),
            body: const Center(child: Text('No user data available')),
          );
        }

        final user = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text('Messages with ${user.firstName} ${user.lastName}'),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder<List<Message>>(
                  stream: chatService.getMessagesStream(chatRoomId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error occurred'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No messages available'));
                    }
                    final messages = snapshot.data!;
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isTrainer = message.senderId == userId;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: isTrainer
                              ? TrainerMessage(message: message)
                              : ClientMessage(message: message),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: const InputDecoration(labelText: 'Enter message'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _sendMessage(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}