// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ventanas/services/chat_service.dart';
import 'package:ventanas/models/message.dart';

class ChatScreen extends StatelessWidget {
  final String chatRoomId;
  final String userId;

  const ChatScreen({super.key, required this.chatRoomId, required this.userId});

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final TextEditingController messageController = TextEditingController();

    void _sendMessage() async {
      final String content = messageController.text;
      if (content.isNotEmpty) {
        final message = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
          chatRoomId: chatRoomId,
          senderId: userId,
          receiverId: '', // Receiver ID can be omitted here or handled appropriately
          content: content,
          timestamp: DateTime.now(),
        );
        await chatService.sendMessage(message);
        messageController.clear();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<Message>>(
              future: chatService.getMessages(chatRoomId),
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
                    return ListTile(
                      title: Text(message.content),
                      subtitle: Text('From: ${message.senderId}'),
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
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
