// import 'dart:io';
// import 'package:csv/csv.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path_provider/path_provider.dart';

// class CSVUtils {
//   static Future<String> getFilePath() async {
//     final directory = await getApplicationDocumentsDirectory();
//     return '${directory.path}/data.csv';
//   }

//   static Future<void> saveToLocalCSV(List<List<dynamic>> data) async {
//     final filePath = await getFilePath();
//     final file = File(filePath);
//     final csvData = const ListToCsvConverter().convert(data);
//     await file.writeAsString(csvData);
//   }

//   static Future<List<List<dynamic>>> readFromLocalCSV() async {
//     final filePath = await getFilePath();
//     final file = File(filePath);
//     final csvData = await file.readAsString();
//     return const CsvToListConverter().convert(csvData);
//   }

//   static Future<void> uploadCSVToFirebase() async {
//     final filePath = await getFilePath();
//     final file = File(filePath);
//     final storageRef = FirebaseStorage.instance.ref().child('data.csv');
//     await storageRef.putFile(file);
//   }
// }

// ignore_for_file: avoid_print

// json_utils.dart
import 'dart:io';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class JsonUtils {
  static Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/data.json';
  }

  static Future<void> saveToLocalJson(Map<String, dynamic> data) async {
    final filePath = await getFilePath();
    final file = File(filePath);
    final jsonData = jsonEncode(data);
    await file.writeAsString(jsonData);
    await uploadJsonToFirebase();  // Upload to Firebase Storage whenever the local file is updated
  }

  static Future<Map<String, dynamic>> readFromLocalJson() async {
    final filePath = await getFilePath();
    final file = File(filePath);
    if (!await file.exists()) {
      await saveToLocalJson({'users': []});
      return {'users': []};
    }
    final jsonData = await file.readAsString();
    return jsonDecode(jsonData);
  }

  static Future<void> uploadJsonToFirebase() async {
    final filePath = await getFilePath();
    final file = File(filePath);
    final storageRef = FirebaseStorage.instance.ref().child('data.json');
    await storageRef.putFile(file);
  }

  static Future<void> downloadJsonFromFirebase() async {
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

  static Future<void> synchronizeJson() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool connected = connectivityResult != ConnectivityResult.none;

    if (connected) {
      print('Connected to the internet. Synchronizing JSON file with cloud storage.');
      await downloadJsonFromFirebase();
    } else {
      print('No internet connection. Using local JSON file.');
    }
  }
}
