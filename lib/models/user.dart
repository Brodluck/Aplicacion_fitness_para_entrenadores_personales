import 'dart:convert';
import 'package:pointycastle/digests/sha3.dart';
import 'package:ventanas/models/diet.dart';
import 'dart:typed_data';
import 'exercise.dart';

// Utility class for hashing passwords
class PasswordUtils {
  static String hashPassword(String password) {
    final digest = SHA3Digest(256);
    final hashedBytes = digest.process(Uint8List.fromList(utf8.encode(password)));
    return base64Encode(hashedBytes);
  }
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  String email;
  String password;
  String phoneNumber;
  String photoUrl;
  double weight;
  double height;
  double armCircumference;
  double legCircumference;
  double waistCircumference;
  double backWidth;
  double chestWidth;
  double bodyFatPercentage;
  final String userType;
  List<Exercise> assignedExercises;
  List<Diet> assignedDiets;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.weight,
    required this.height,
    this.photoUrl = '',
    this.armCircumference = 0.0,
    this.legCircumference = 0.0,
    this.waistCircumference = 0.0,
    this.backWidth = 0.0,
    this.chestWidth = 0.0,
    this.bodyFatPercentage = 0.0,
    required this.userType,
    this.assignedExercises = const [],
    this.assignedDiets = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'weight': weight,
      'height': height,
      'armCircumference': armCircumference,
      'legCircumference': legCircumference,
      'waistCircumference': waistCircumference,
      'backWidth': backWidth,
      'chestWidth': chestWidth,
      'bodyFatPercentage': bodyFatPercentage,
      'password': password,
      'userType': userType,
      'assignedExercises': assignedExercises.map((e) => e.toJson()).toList(),
      'assignedDiets': assignedDiets.map((d) => d.toJson()).toList(),
    };
  }

  User getUserByID(String id) {
    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      photoUrl: photoUrl,
      weight: weight,
      height: height,
      armCircumference: armCircumference,
      legCircumference: legCircumference,
      waistCircumference: waistCircumference,
      backWidth: backWidth,
      chestWidth: chestWidth,
      bodyFatPercentage: bodyFatPercentage,
      password: password,
      userType: userType,
      assignedExercises: assignedExercises,
      assignedDiets: assignedDiets,
    );
  }


  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      weight: (map['weight'] is String)
          ? double.tryParse(map['weight']) ?? 0.0
          : (map['weight'] ?? 0).toDouble(),
      height: (map['height'] is String)
          ? double.tryParse(map['height']) ?? 0.0
          : (map['height'] ?? 0).toDouble(),
      armCircumference: (map['armCircumference'] is String)
          ? double.tryParse(map['armCircumference']) ?? 0.0
          : (map['armCircumference'] ?? 0).toDouble(),
      legCircumference: (map['legCircumference'] is String)
          ? double.tryParse(map['legCircumference']) ?? 0.0
          : (map['legCircumference'] ?? 0).toDouble(),
      waistCircumference: (map['waistCircumference'] is String)
          ? double.tryParse(map['waistCircumference']) ?? 0.0
          : (map['waistCircumference'] ?? 0).toDouble(),
      backWidth: (map['backWidth'] is String)
          ? double.tryParse(map['backWidth']) ?? 0.0
          : (map['backWidth'] ?? 0).toDouble(),
      chestWidth: (map['chestWidth'] is String)
          ? double.tryParse(map['chestWidth']) ?? 0.0
          : (map['chestWidth'] ?? 0).toDouble(),
      bodyFatPercentage: (map['bodyFatPercentage'] is String)
          ? double.tryParse(map['bodyFatPercentage']) ?? 0.0
          : (map['bodyFatPercentage'] ?? 0).toDouble(),
      password: map['password'] ?? '',
      userType: map['userType'] ?? '',
      assignedExercises: (map['assignedExercises'] as List<dynamic>?)
              ?.map((e) => Exercise.fromJson(e))
              .toList() ??
          [],
      assignedDiets: (map['assignedDiets'] as List<dynamic>?)
              ?.map((d) => Diet.fromJson(d))
              .toList() ??
          [],
    );
  }
}

class Trainer {
  String id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String photoUrl;
  String password;
  String userType = 'trainer';

  Trainer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.photoUrl,
    required this.password,
    required this.userType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'userType': 'trainer',
    };
  }

  factory Trainer.fromMap(Map<String, dynamic> map) {
    return Trainer(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      userType: map['userType'] ?? '',
    );
  }
}
