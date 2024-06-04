// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:ventanas/models/exercise.dart';
import 'package:ventanas/models/user.dart';
import 'package:ventanas/services/json_utils.dart';

class ExerciseAssignmentPage extends StatefulWidget {
  final String clientId;

  const ExerciseAssignmentPage({Key? key, required this.clientId}) : super(key: key);

  @override
  _ExerciseAssignmentPageState createState() => _ExerciseAssignmentPageState();
}

class _ExerciseAssignmentPageState extends State<ExerciseAssignmentPage> {
  List<Exercise> _exercises = [];
  List<Exercise> _assignedExercises = [];
  List<Exercise> _filteredExercises = [];
  User? _client;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExercises();
    _loadClient();
    _searchController.addListener(_filterExercises);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadExercises() async {
    List<Exercise> exercises = await JsonUtils.readExercises();
    setState(() {
      _exercises = exercises;
      _filteredExercises = exercises;
    });
  }

  Future<void> _loadClient() async {
    User? client = await JsonUtils.getUserById(widget.clientId);
    if (client != null) {
      setState(() {
        _client = client;
        _assignedExercises = client.assignedExercises;
      });
    }
  }

  void _assignExercise(Exercise exercise) {
    setState(() {
      if (!_assignedExercises.any((e) => e.id == exercise.id)) {
        _assignedExercises.add(exercise);
      }
    });
  }

  void _removeAssignedExercise(Exercise exercise) {
    setState(() {
      _assignedExercises.removeWhere((e) => e.id == exercise.id);
    });
  }

  Future<void> _saveAssignedExercises() async {
    print("Saving assigned exercises for client: ${widget.clientId}");
    User? client = await JsonUtils.getUserById(widget.clientId);
    if (client != null) {
      print("Updating client: ${client.firstName} ${client.lastName} with assigned exercises: $_assignedExercises");
      client.assignedExercises = _assignedExercises;
      await JsonUtils.updateUser(client);
      await JsonUtils.synchronizeJson("data");
    } else {
      print("Client not found.");
    }
  }

  void _filterExercises() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredExercises = _exercises.where((exercise) {
        bool matchesName = exercise.name.toLowerCase().contains(query);
        bool matchesForce = exercise.force.toLowerCase().contains(query);
        bool matchesLevel = exercise.level.toLowerCase().contains(query);
        bool matchesMechanic = exercise.mechanic.toLowerCase().contains(query);
        bool matchesEquipment = exercise.equipment.toLowerCase().contains(query);
        bool matchesPrimaryMuscles = exercise.primaryMuscles.any((muscle) => muscle.toLowerCase().contains(query));
        bool matchesCategory = exercise.category.toLowerCase().contains(query);
        return matchesName || matchesForce || matchesLevel || matchesMechanic || matchesEquipment || matchesPrimaryMuscles || matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Exercises to Client ${_client?.firstName ?? ''} ${_client?.lastName ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            iconSize: 45,
            tooltip: "Save",
            onPressed: _saveAssignedExercises,
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Select the exercises to assign:'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredExercises.length,
              itemBuilder: (context, index) {
                Exercise exercise = _filteredExercises[index];
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
                  trailing: IconButton(
                    icon: Icon(
                      _assignedExercises.contains(exercise) ? Icons.remove_circle : Icons.add_circle,
                      color: _assignedExercises.contains(exercise) ? Colors.red : Colors.green,
                    ),
                    onPressed: () {
                      _assignedExercises.contains(exercise) ? _removeAssignedExercise(exercise) : _assignExercise(exercise);
                    },
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseDetailPage(exercise: exercise),
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Assigned exercises:'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _assignedExercises.length,
              itemBuilder: (context, index) {
                Exercise exercise = _assignedExercises[index];
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
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    color: Colors.red,
                    onPressed: () {
                      _removeAssignedExercise(exercise);
                    },
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseDetailPage(exercise: exercise),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
