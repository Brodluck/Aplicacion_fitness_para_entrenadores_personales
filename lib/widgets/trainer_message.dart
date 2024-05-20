import 'package:flutter/material.dart';
import 'package:ventanas/models/message.dart';

class TrainerMessage extends StatelessWidget {
  final Message message;

  const TrainerMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: colors.secondary, borderRadius: BorderRadius.circular(20)),
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
