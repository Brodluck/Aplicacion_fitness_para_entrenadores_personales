// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ventanas/services/chat_service.dart';
import 'chat_screen.dart';

class MessagesTab extends StatelessWidget {
  final String userId;

  const MessagesTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);

    void _createChat(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final TextEditingController trainerIdController = TextEditingController();
          final TextEditingController messageController = TextEditingController();
          return AlertDialog(
            title: const Text('Create New Chat'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: trainerIdController,
                  decoration: const InputDecoration(labelText: 'Trainer ID'),
                ),
                TextField(
                  controller: messageController,
                  decoration: const InputDecoration(labelText: 'Message'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Send'),
                onPressed: () async {
                  final String trainerId = trainerIdController.text;
                  final String message = messageController.text;
                  await chatService.createChat(userId, trainerId, message);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _createChat(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: chatService.getChatRooms(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No chats available'));
          }

          final chatRooms = snapshot.data!;
          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index];
              final participants = chatRoom['participants'];
              return ListTile(
                title: Text('Chat with ${participants.where((p) => p != userId).join(', ')}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatRoomId: chatRoom['id'],
                        userId: userId,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
