import 'package:flutter/material.dart';
import 'package:ventanas/services/progress_service.dart';
import 'package:ventanas/models/progress.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  final String userId; // Pass the userId as a parameter

  const ProfileTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final ProgressService progressService = Provider.of<ProgressService>(context);

    return FutureBuilder<List<Progress>>(
      future: progressService.getAllProgress(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final progressList = snapshot.data!.where((progress) => progress.userId == userId).toList();
        return ListView.builder(
          itemCount: progressList.length,
          itemBuilder: (context, index) {
            final progress = progressList[index];
            return ListTile(
              title: Text('Weight: ${progress.weight} kg'),
              subtitle: Text('Body Fat: ${progress.bodyFat}%'),
              trailing: Text(progress.date.toString()),
            );
          },
        );
      },
    );
  }
}
