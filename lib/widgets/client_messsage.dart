import 'package:flutter/material.dart';
import 'package:ventanas/models/message.dart';

class ClientMessage extends StatelessWidget {
  final Message message;

  const ClientMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
              color: colors.primary, borderRadius: BorderRadius.circular(100)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              message.content,
              style: const TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 20, // specify your desired font size here
                  fontWeight: FontWeight.bold, // makes the text bold
                ),
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
