import 'package:flutter/material.dart';
import 'package:ventanas/models/exercise.dart';
import 'package:ventanas/models/user.dart';
import 'package:ventanas/services/json_utils.dart';

class TrainingTab extends StatelessWidget {
  final String clientId;

  const TrainingTab({super.key, required this.clientId});

  Future<List<Exercise>> _loadClientExercises() async {
    List<Exercise> allExercises = await JsonUtils.readExercises();

    User? client = await JsonUtils.getUserById(clientId);
    if (client == null) {
      return [];
    }

    List<Exercise> clientExercises = allExercises
        .where((exercise) => client.assignedExercises.any((assigned) => assigned.id == exercise.id))
        .toList();

    return clientExercises;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
      future: _loadClientExercises(),
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
                leading: exercise.images.isNotEmpty
                    ? Image.asset(
                        'assets/${exercise.images.first}',
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      )
                    : null,
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

class ExerciseDetailPage extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailPage({super.key, required this.exercise});

  @override
  _ExerciseDetailPageState createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  int _currentIndex = 0;

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.exercise.images.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;

    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (exercise.images.isNotEmpty)
                GestureDetector(
                  onTap: _nextImage,
                  child: Image.asset(
                    'assets/${exercise.images[_currentIndex]}',
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Image not found');
                    },
                  ),
                )
              else
                const Text('No images available'),
              const SizedBox(height: 10),
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
            ],
          ),
        ),
      ),
    );
  }
}
