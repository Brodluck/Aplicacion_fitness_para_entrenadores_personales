// ignore_for_file: avoid_print

import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/user.dart';
import 'json_utils.dart';

class UserService {
  static const String _dataFileName = 'users_data';
  static const String _chatsFileName = 'chats';
  static const String _exercisesFileName = 'exercises';

  Future<void> _downloadFilesFromCloud() async {
    try {
      await JsonUtils.downloadJsonFromFirebase(_dataFileName);
      print('File "users_data" downloaded from cloud storage.');
      await JsonUtils.downloadJsonFromFirebase(_chatsFileName);
      print('File "chats" downloaded from cloud storage.');
      await JsonUtils.downloadJsonFromFirebase(_exercisesFileName);
      print('File "exercises" downloaded from cloud storage.');
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  Future<List<User>> getAllUsers() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool connected = connectivityResult != ConnectivityResult.none;

    if (connected) {
      print('Connected to the internet. Downloading file from cloud storage.');
      await _downloadFilesFromCloud();
    } else {
      print('No internet connection. Using local JSON file.');
    }

    try {
      var data = await JsonUtils.readFromLocalJson(_dataFileName);
      if (data is List) {
        return data.map((userMap) => User.fromMap(userMap)).toList();
      } else if (data is Map<String, dynamic> && data.containsKey('users')) {
        return (data['users'] as List).map((userMap) => User.fromMap(userMap)).toList();
      }
    } catch (e) {
      print('Error reading JSON file: $e');
    }

    return [];
  }

  Future<void> createUser(User user) async {
    List<User> users = await getAllUsers();
    users.add(user);
    Map<String, dynamic> data = {'users': users.map((user) => user.toMap()).toList()};
    await JsonUtils.saveToLocalJson(_dataFileName, data);
    await JsonUtils.uploadJsonToFirebase(_dataFileName);
  }

  Future<void> deleteUser(String id) async {
    List<User> users = await getAllUsers();
    users.removeWhere((user) => user.id == id);
    Map<String, dynamic> data = {'users': users.map((user) => user.toMap()).toList()};
    await JsonUtils.saveToLocalJson(_dataFileName, data);
    await JsonUtils.uploadJsonToFirebase(_dataFileName);
  }
}
