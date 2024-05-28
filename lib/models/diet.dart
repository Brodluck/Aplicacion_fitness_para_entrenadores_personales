class Diet {
  final String id;
  final String name;
  final String description;
  final List<String> meals;
  final List<String> foods;

  Diet({
    required this.id,
    required this.name,
    required this.description,
    required this.meals,
    required this.foods,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'meals': meals,
    };
  }
  
  factory Diet.fromJson(Map<String, dynamic> json) {
    return Diet(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      meals: List<String>.from(json['meals'] ?? []),
      foods: List<String>.from(json['foods'] ?? []), // Deserialize this property
    );
  }
}
