// educational_content.dart
class EducationalContent {
  final String id;
  final String title;
  final String description;
  final String url;

  EducationalContent({required this.id, required this.title, required this.description, required this.url});

  factory EducationalContent.fromMap(Map<String, dynamic> data, String id) {
    return EducationalContent(
      id: id,
      title: data['title'],
      description: data['description'],
      url: data['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'url': url,
    };
  }
}
