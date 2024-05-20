import 'package:flutter/material.dart';
import 'package:ventanas/models/exercise.dart';

class TrainingTab extends StatelessWidget {
  const TrainingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
      future: loadExercises(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading exercises'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No exercises found'));
        } else {
          final exercises = snapshot.data!;
          return ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return ListTile(
                leading: Image.asset('assets/images/${exercise.images.first}'),
                title: Text(exercise.name),
                subtitle: Text(exercise.category),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseDetailPage(exercise: exercise),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

class ExerciseDetailPage extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailPage({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${exercise.category}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Instructions:'),
            ...exercise.instructions.map((instruction) => Text('- $instruction')),
            const SizedBox(height: 10),
            Text('Primary Muscles: ${exercise.primaryMuscles.join(', ')}'),
            const SizedBox(height: 10),
            Text('Secondary Muscles: ${exercise.secondaryMuscles.join(', ')}'),
            const SizedBox(height: 10),
            Text('Level: ${exercise.level}'),
            const SizedBox(height: 10),
            Text('Equipment: ${exercise.equipment}'),
            const SizedBox(height: 10),
            Text('Mechanic: ${exercise.mechanic}'),
            const SizedBox(height: 10),
            Text('Force: ${exercise.force}'),
            const SizedBox(height: 10),
            const Text('Images:'),
            ...exercise.images.map((image) => Image.asset('assets/images/$image')),
          ],
        ),
      ),
    );
  }
}
