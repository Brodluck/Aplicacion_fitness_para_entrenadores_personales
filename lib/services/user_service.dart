// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/user.dart';

// class UserService {
//   final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

//   Future<void> addUser(User user) {
//     return userCollection.doc(user.id).set(user.toMap());
//   }

//   Future<void> deleteUser(String id) {
//     return userCollection.doc(id).delete();
//   }

//   Future<User?> getUser(String id) async {
//     DocumentSnapshot doc = await userCollection.doc(id).get();
//     if (doc.exists) {
//       return User.fromMap(doc.data() as Map<String, dynamic>);
//     }
//     return null;
//   }

//   Future<List<User>> getAllUsers() async {
//     QuerySnapshot querySnapshot = await userCollection.get();
//     return querySnapshot.docs.map((doc) => User.fromMap(doc.data() as Map<String, dynamic>)).toList();
//   }
// }

// import 'dart:convert';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';
// import 'package:csv/csv.dart';
// import '../models/user.dart';

// class UserService {
//   Future<String> _localPath() async {
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }

//   Future<File> _localFile() async {
//     final path = await _localPath();
//     return File('$path/users.csv');
//   }

//   Future<List<User>> getAllUsers() async {
//     final file = await _localFile();
//     if (!await file.exists()) {
//       return [];
//     }

//     final csvString = await file.readAsString();
//     List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);

//     List<String> headers = [
//       'id', 'firstName', 'lastName', 'email', 'phoneNumber', 'photoUrl', 'password'
//     ];

//     List<User> users = rowsAsListOfValues.map((row) {
//       Map<String, String> userMap = Map<String, String>.fromIterables(headers, row.map((e) => e.toString()));
//       return User.fromMap(userMap);
//     }).toList();

//     return users;
//   }

//   Future<void> createUser(User user) async {
//     final file = await _localFile();
//     final csvRow = '${user.id},${user.firstName},${user.lastName},${user.email},${user.phoneNumber},${user.photoUrl},${user.password}\n';
//     await file.writeAsString(csvRow, mode: FileMode.append);
//   }

//   Future<void> deleteUser(String id) async {
//     final file = await _localFile();
//     if (!await file.exists()) return;

//     final csvString = await file.readAsString();
//     List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);

//     List<String> headers = [
//       'id', 'firstName', 'lastName', 'email', 'phoneNumber', 'photoUrl', 'password'
//     ];

//     rowsAsListOfValues.removeWhere((row) => row[0] == id);

//     String newCsv = const ListToCsvConverter().convert(rowsAsListOfValues);
//     await file.writeAsString(newCsv);
//   }
// }

// ignore_for_file: avoid_print

// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:csv/csv.dart';
// import '../models/user.dart';

// class UserService {
//   Future<String> _localPath() async {
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }

//   Future<File> _localFile() async {
//     final path = await _localPath();
//     return File('$path/users.csv');
//   }

//   Future<void> _downloadFileFromCloud() async {
//     try {
//       final storageRef = FirebaseStorage.instance.ref().child('users.csv');
//       final directory = await getApplicationDocumentsDirectory();
//       final file = File('${directory.path}/users.csv');
//       await storageRef.writeToFile(file);
//       print('File downloaded from cloud storage.');
//     } catch (e) {
//       print('Error downloading file: $e');
//     }
//   }

//   Future<List<User>> getAllUsers() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     bool connected = connectivityResult != ConnectivityResult.none;

//     if (connected) {
//       print('Connected to the internet. Downloading file from cloud storage.');
//       await _downloadFileFromCloud();
//     } else {
//       print('No internet connection. Using local CSV file.');
//     }

//     final file = await _localFile();
//     if (!await file.exists()) {
//       return [];
//     }

//     final csvString = await file.readAsString();
//     List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);

//     List<String> headers = [
//       'id', 'firstName', 'lastName', 'email', 'phoneNumber', 'photoUrl', 'password'
//     ];

//     List<User> users = rowsAsListOfValues.map((row) {
//       Map<String, String> userMap = Map<String, String>.fromIterables(headers, row.map((e) => e.toString()));
//       return User.fromMap(userMap);
//     }).toList();

//     return users;
//   }

//   Future<void> createUser(User user) async {
//     final file = await _localFile();
//     final csvRow = '${user.id},${user.firstName},${user.lastName},${user.email},${user.phoneNumber},${user.photoUrl},${user.password}\n';
//     await file.writeAsString(csvRow, mode: FileMode.append);
//     await _uploadFileToCloud();
//   }

//   Future<void> deleteUser(String id) async {
//     final file = await _localFile();
//     if (!await file.exists()) return;

//     final csvString = await file.readAsString();
//     List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);

//     rowsAsListOfValues.removeWhere((row) => row[0] == id);

//     String newCsv = const ListToCsvConverter().convert(rowsAsListOfValues);
//     await file.writeAsString(newCsv);
//     await _uploadFileToCloud();
//   }

//   Future<void> _uploadFileToCloud() async {
//     try {
//       final file = await _localFile();
//       final storageRef = FirebaseStorage.instance.ref().child('users.csv');
//       await storageRef.putFile(file);
//       print('File uploaded to cloud storage.');
//     } catch (e) {
//       print('Error uploading file: $e');
//     }
//   }
// }

//user_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/user.dart';
import 'json_utils.dart';

class UserService {
  Future<void> _downloadFileFromCloud() async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('data.json');
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/data.json');
      await storageRef.writeToFile(file);
      print('File downloaded from cloud storage.');
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  Future<List<User>> getAllUsers() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool connected = connectivityResult != ConnectivityResult.none;

    if (connected) {
      print('Connected to the internet. Downloading file from cloud storage.');
      await _downloadFileFromCloud();
    } else {
      print('No internet connection. Using local JSON file.');
    }

    try {
      Map<String, dynamic> data = await JsonUtils.readFromLocalJson();
      if (data.containsKey('users')) {
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
    await JsonUtils.saveToLocalJson(data);
    await JsonUtils.uploadJsonToFirebase();
  }

  Future<void> deleteUser(String id) async {
    List<User> users = await getAllUsers();
    users.removeWhere((user) => user.id == id);
    Map<String, dynamic> data = {'users': users.map((user) => user.toMap()).toList()};
    await JsonUtils.saveToLocalJson(data);
    await JsonUtils.uploadJsonToFirebase();
  }
}
