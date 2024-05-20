// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ventanas/services/chat_service.dart';
import 'package:ventanas/services/user_service.dart';
import 'package:ventanas/models/user.dart';
import 'chat_screen.dart';

class TrainerMessagesTab extends StatelessWidget {
  final String trainerId;

  const TrainerMessagesTab({super.key, required this.trainerId});

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final userService = UserService();

    Future<void> _createChat(BuildContext context) async {
      final List<User> clients = await userService.getAllUsers();
      final TextEditingController messageController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Create New Chat'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: clients.length,
                    itemBuilder: (context, index) {
                      final client = clients[index];
                      return ListTile(
                        title: Text(client.email),
                        onTap: () async {
                          final String message = messageController.text;
                          await chatService.createChat(trainerId, client.id, message);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
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
        future: chatService.getChatRooms(trainerId),
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
                title: Text('Chat with ${participants.where((p) => p != trainerId).join(', ')}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatRoomId: chatRoom['id'],
                        userId: trainerId,
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
