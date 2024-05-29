// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ventanas/models/diet.dart';
import 'package:ventanas/models/exercise.dart';
import 'package:ventanas/models/user.dart';
import 'package:ventanas/models/message.dart';

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
    print('Uploading $filePath to Firebase...');
    
    final uploadTask = storageRef.putFile(file);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      switch (snapshot.state) {
        case TaskState.running:
          print('Upload is running');
          break;
        case TaskState.paused:
          print('Upload is paused');
          break;
        case TaskState.success:
          print('Upload completed successfully');
          break;
        case TaskState.canceled:
          print('Upload canceled');
          break;
        case TaskState.error:
          print('Upload error');
          break;
      }
    });

    try {
      await uploadTask;
      print('Upload complete.');
    } catch (e) {
      print('Upload failed: $e');
    }
  }

  static Future<void> downloadJsonFromFirebase(String fileName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('$fileName.json');
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.json');
      await storageRef.writeToFile(file);
      print('File $fileName downloaded from cloud storage.');
    } catch (e) {
      if (e is FirebaseException && e.code == 'object-not-found') {
        print('Error: No object exists at the desired reference.');
      } else {
        print('Error downloading file: $e');
      }
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

  static Future<void> mergeData(String fileName, dynamic localData, dynamic cloudData) async {
    if (fileName == 'data') {
      // Merge users data
      var localUsers = localData['users'] as List;
      var cloudUsers = cloudData['users'] as List;

      var mergedUsers = { for (var user in cloudUsers) user['id']: user };
      for (var user in localUsers) {
        mergedUsers[user['id']] = user;
      }

      var mergedData = {'users': mergedUsers.values.toList()};
      await saveToLocalJson(fileName, mergedData);
    } else if (fileName == 'chats') {
      // Merge chat data
      var localChatRooms = localData['chatRooms'] as List;
      var cloudChatRooms = cloudData['chatRooms'] as List;

      var mergedChatRooms = { for (var room in cloudChatRooms) room['id']: room };
      for (var room in localChatRooms) {
        mergedChatRooms[room['id']] = room;
      }

      var localMessages = localData['messages'] as List;
      var cloudMessages = cloudData['messages'] as List;

      var mergedMessages = { for (var message in cloudMessages) message['id']: message };
      for (var message in localMessages) {
        mergedMessages[message['id']] = message;
      }

      var mergedData = {
        'chatRooms': mergedChatRooms.values.toList(),
        'messages': mergedMessages.values.toList(),
      };
      await saveToLocalJson(fileName, mergedData);
    }
  }

  static Future<List<Exercise>> readExercises({String fileName = "exercises"}) async {
    final data = await readFromLocalJson(fileName);
    if (data is List) {
      return data.map((json) => Exercise.fromJson(json)).toList();
    }
    return [];
  }

  static Future<List<User>> readUsers({String fileName = "data"}) async {
    final data = await readFromLocalJson(fileName);
    if (data is List) {
      return data.map((json) => User.fromMap(json)).toList();
    } else if (data is Map<String, dynamic> && data.containsKey('users')) {
      return (data['users'] as List).map((userMap) => User.fromMap(userMap)).toList();
    }
    return [];
  }

  static Future<void> saveUsers(List<User> users, {String fileName = "data"}) async {
    final data = {'users': users.map((user) => user.toMap()).toList()};
    await saveToLocalJson(fileName, data);
    await uploadJsonToFirebase(fileName);
  }

  static Future<void> updateUser(User updatedUser, {String fileName = "data"}) async {
    List<User> users = await readUsers(fileName: fileName);
    for (int i = 0; i < users.length; i++) {
      if (users[i].id == updatedUser.id) {
        users[i] = updatedUser;
        break;
      }
    }
    await saveUsers(users, fileName: fileName);
  }

  static Future<User?> getUserById(String id, {String fileName = "data"}) async {
    List<User> users = await readUsers(fileName: fileName);
    for (var user in users) {
      if (user.id == id) {
        return user;
      }
    }
    return null;
  }

  static Future<List<Message>> readMessages({String fileName = "chats"}) async {
    final data = await readFromLocalJson(fileName);
    if (data is Map<String, dynamic> && data.containsKey('messages')) {
      return (data['messages'] as List).map((json) => Message.fromMap(json, json['id'])).toList();
    }
    return [];
  }

  static Future<void> saveMessages(List<Message> messages, {String fileName = "chats"}) async {
    final data = {'messages': messages.map((message) => message.toMap()).toList()};
    await saveToLocalJson(fileName, data);
    await uploadJsonToFirebase(fileName);
  }

  static Future<void> updateMessage(Message updatedMessage, {String fileName = "chats"}) async {
    List<Message> messages = await readMessages(fileName: fileName);
    for (int i = 0; i < messages.length; i++) {
      if (messages[i].id == updatedMessage.id) {
        messages[i] = updatedMessage;
        break;
      }
    }
    await saveMessages(messages, fileName: fileName);
  }

static Future<List<Diet>> readDiets({String fileName = "diets"}) async {
    final data = await readFromLocalJson(fileName);
    if (data is List) {
      return data.map((json) => Diet.fromJson(json)).toList();
    }
    return [];
  }

  static Future<void> saveDiets(List<Diet> diets, {String fileName = "diets"}) async {
    final data = diets.map((diet) => diet.toJson()).toList();
    await saveToLocalJson(fileName, data);
    await uploadJsonToFirebase(fileName);
  }

  static Future<void> updateUserDiet(User updatedUser, {String fileName = "data"}) async {
    List<User> users = await readUsers(fileName: fileName);
    for (int i = 0; i < users.length; i++) {
      if (users[i].id == updatedUser.id) {
        users[i] = updatedUser;
        break;
      }
    }
    await saveUsers(users, fileName: fileName);
  }

  static Future<User?> getTrainer() async {
    List<User> users = await readUsers();
    return users.firstWhere((user) => user.userType == 'trainer');
  }

  static Future<List<User>> getClients() async {
    List<User> users = await readUsers();
    return users.where((user) => user.userType == 'client').toList();
  }

static Future<Map<String, dynamic>> readChatData(String fileName) async {
    final filePath = await getFilePath(fileName);
    final file = File(filePath);
    if (!await file.exists()) {
      await saveToLocalJson(fileName, {'chatRooms': [], 'messages': []});
      return {'chatRooms': [], 'messages': []};
    }
    final jsonData = await file.readAsString();
    final data = jsonDecode(jsonData);
    if (data is Map<String, dynamic> && !(data.containsKey('chatRooms') && data.containsKey('messages'))) {
      return {'chatRooms': [], 'messages': []};
    }
    return data;
  }

  static Future<void> saveChatData(String fileName, Map<String, dynamic> data) async {
    final filePath = await getFilePath(fileName);
    final file = File(filePath);
    final jsonData = jsonEncode(data);
    await file.writeAsString(jsonData);
    await uploadJsonToFirebase(fileName);
  }

}
