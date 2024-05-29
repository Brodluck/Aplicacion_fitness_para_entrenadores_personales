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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
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
                        receiverId: participants.firstWhere((p) => p != userId),
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
