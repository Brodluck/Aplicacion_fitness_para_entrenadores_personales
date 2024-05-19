// import 'package:flutter/material.dart';

// class MessagesTab extends StatelessWidget {
//   const MessagesTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Messages'),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:ventanas/services/chat_service.dart';
import 'package:ventanas/models/message.dart';
import 'package:provider/provider.dart';

class MessagesTab extends StatelessWidget {
  final String chatId; // Pass the chatId as a parameter

  const MessagesTab({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    final ChatService chatService = Provider.of<ChatService>(context);

    return StreamBuilder<List<Message>>(
      stream: chatService.getMessages(chatId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final messages = snapshot.data!;
        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return ListTile(
              title: Text(message.content),
              subtitle: Text(message.timestamp.toString()),
            );
          },
        );
      },
    );
  }
}
