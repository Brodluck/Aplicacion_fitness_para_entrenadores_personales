// ignore_for_file: avoid_print
// json_utils.dart
import 'dart:io';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ventanas/models/exercise.dart';

class JsonUtils {
  static Future<String> getFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName.json';
  }

  static Future<void> saveToLocalJson(String fileName, Map<String, dynamic> data) async {
    final filePath = await getFilePath(fileName);
    final file = File(filePath);
    final jsonData = jsonEncode(data);
    await file.writeAsString(jsonData);
    await uploadJsonToFirebase(fileName);  // Upload to Firebase Storage whenever the local file is updated
  }

  static Future<Map<String, dynamic>> readFromLocalJson(String fileName) async {
    final filePath = await getFilePath(fileName);
    final file = File(filePath);
    if (!await file.exists()) {
      await saveToLocalJson(fileName, {});
      return {};
    }
    final jsonData = await file.readAsString();
    return jsonDecode(jsonData);
  }

  static Future<void> uploadJsonToFirebase(String fileName) async {
    final filePath = await getFilePath(fileName);
    final file = File(filePath);
    final storageRef = FirebaseStorage.instance.ref().child('$fileName.json');
    await storageRef.putFile(file);
  }

  static Future<void> downloadJsonFromFirebase(String fileName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('$fileName.json');
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.json');
      await storageRef.writeToFile(file);
      print('File downloaded from cloud storage.');
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  static Future<void> synchronizeJson(String fileName) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool connected = connectivityResult != ConnectivityResult.none;

    if (connected) {
      print('Connected to the internet. Synchronizing JSON file with cloud storage.');
      await downloadJsonFromFirebase(fileName);
    } else {
      print('No internet connection. Using local JSON file.');
    }
  }

  // New method to read exercises
  static Future<List<Exercise>> readExercises({String fileName = "exercises"}) async {
    final data = await readFromLocalJson(fileName);
    if (data.isNotEmpty) {
      final List exercisesJson = data['exercises'] ?? [];
      return exercisesJson.map((json) => Exercise.fromJson(json)).toList();
    }
    return [];
  }
}

