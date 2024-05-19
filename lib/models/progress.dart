// progress.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Progress {
  final String id;
  final String userId;
  final DateTime date;
  final double weight;
  final double bodyFat;

  Progress({required this.id, required this.userId, required this.date, required this.weight, required this.bodyFat});

  factory Progress.fromMap(Map<String, dynamic> data, String id) {
    return Progress(
      id: id,
      userId: data['userId'],
      date: (data['date'] as Timestamp).toDate(),
      weight: data['weight'],
      bodyFat: data['bodyFat'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'weight': weight,
      'bodyFat': bodyFat,
    };
  }
}
