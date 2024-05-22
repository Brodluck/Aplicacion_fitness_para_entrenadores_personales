// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ventanas/models/exercise.dart';
import 'package:ventanas/models/user.dart';
import 'package:ventanas/services/user_service.dart';

class JsonUtils {
  static Future<String> getFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName.json';
  }

  static Future<void> saveToLocalJson(String fileName, dynamic data) async {
    final filePath = await getFilePath(fileName);
    final file = File(filePath);
    final jsonData = jsonEncode(data);
    await file.writeAsString(jsonData);
  }

  static Future<dynamic> readFromLocalJson(String fileName) async {
    final filePath = await getFilePath(fileName);
    final file = File(filePath);
    if (!await file.exists()) {
      await saveToLocalJson(fileName, {'users': []});
      return {'users': []};
    }
    final jsonData = await file.readAsString();
    return jsonDecode(jsonData);
  }

  static Future<void> uploadJsonToFirebase(String fileName) async {
    final filePath = await getFilePath(fileName);
    final file = File(filePath);
    final storageRef = FirebaseStorage.instance.ref().child('$fileName.json');
    print('Uploading $filePath to Firebase...');
    await storageRef.putFile(file);
    print('Upload complete.');
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

  static Future<List<Exercise>> readExercises({String fileName = "exercises"}) async {
    final data = await readFromLocalJson(fileName);
    if (data is List) {
      return data.map((json) => Exercise.fromJson(json)).toList();
    }
    return [];
  }

  static Future<List<User>> readUsers({String fileName = "users_data"}) async {
    return await UserService().getAllUsers();
  }

  static Future<void> saveUsers(List<User> users, {String fileName = "users_data"}) async {
    final data = {'users': users.map((user) => user.toMap()).toList()};
    await saveToLocalJson(fileName, data);
    await uploadJsonToFirebase(fileName); // Ensure upload to Firebase after saving locally
  }

  static Future<void> updateUser(User updatedUser, {String fileName = "users_data"}) async {
    List<User> users = await readUsers(fileName: fileName);
    for (int i = 0; i < users.length; i++) {
      if (users[i].id == updatedUser.id) {
        users[i] = updatedUser;
        break;
      }
    }
    await saveUsers(users, fileName: fileName);
  }

  static Future<User?> getUserById(String id, {String fileName = "users_data"}) async {
    List<User> users = await readUsers(fileName: fileName);
    print("Users: $users");
    for (var user in users) {
      if (user.id == id) {
        return user;
      }
    }
    return null;
  }
}
