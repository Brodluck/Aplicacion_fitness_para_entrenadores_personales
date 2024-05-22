// exercise.dart
// ignore_for_file: avoid_print

import 'package:ventanas/services/json_utils.dart';

class Exercise {
  final String name;
  final String force;
  final String level;
  final String mechanic;
  final String equipment;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final List<String> instructions;
  final String category;
  final List<String> images;
  final String id;

  Exercise({
    required this.name,
    required this.force,
    required this.level,
    required this.mechanic,
    required this.equipment,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.instructions,
    required this.category,
    required this.images,
    required this.id,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] ?? '',
      force: json['force'] ?? '', // Maneja nulos
      level: json['level'] ?? '',
      mechanic: json['mechanic'] ?? '', // Maneja nulos
      equipment: json['equipment'] ?? '', // Maneja nulos
      primaryMuscles: List<String>.from(json['primaryMuscles'] ?? []),
      secondaryMuscles: List<String>.from(json['secondaryMuscles'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      category: json['category'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'force': force,
      'level': level,
      'mechanic': mechanic,
      'equipment': equipment,
      'primaryMuscles': primaryMuscles,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
      'category': category,
      'images': images,
      'id': id,
    };
  }
}

Future<List<Exercise>> loadExercises() async {
  List<Exercise> exercises = [];
  try {
    exercises = await JsonUtils.readExercises(); // Asegúrate de que este método esté correctamente definido y que retorne una lista de ejercicios.
  } catch (e) {
    print('Error loading exercises: $e');
  }
  return exercises;
}