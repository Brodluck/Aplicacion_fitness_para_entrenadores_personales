// exercise.dart
class Exercise {
  final String id;
  final String name;
  final String description;
  final String videoUrl;

  Exercise({required this.id, required this.name, required this.description, required this.videoUrl});

  factory Exercise.fromMap(Map<String, dynamic> data, String id) {
    return Exercise(
      id: id,
      name: data['name'],
      description: data['description'],
      videoUrl: data['videoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'videoUrl': videoUrl,
    };
  }
}
