// import 'package:flutter/material.dart';

// class DashboardTab extends StatelessWidget {
//   const DashboardTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Dashboard'),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ventanas/services/firestore_service.dart';
import 'package:ventanas/models/exercise.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return StreamBuilder<List<Exercise>>(
      stream: firestoreService.getExercises(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return const Text('Error occurred');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data available');
        }

        // Use the data from the snapshot
        final exercises = snapshot.data!;
        return ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return ListTile(
              title: Text(exercise.name),
              subtitle: Text(exercise.description),
            );
          },
        );
      },
    );
  }
}
