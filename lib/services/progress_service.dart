// // progress_service.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ventanas/models/progress.dart';

// class ProgressService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   Stream<List<Progress>> getProgress(String userId) {
//     return _db.collection('progress').where('userId', isEqualTo: userId).orderBy('date').snapshots().map((snapshot) => snapshot.docs.map((doc) => Progress.fromMap(doc.data(), doc.id)).toList());
//   }

//   Future<void> addProgress(Progress progress) {
//     return _db.collection('progress').add(progress.toMap());
//   }
// }


// ignore_for_file: avoid_print

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:csv/csv.dart';
import '../models/progress.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ProgressService {
  Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile() async {
    final path = await _localPath();
    return File('$path/progress.csv');
  }

  Future<void> _downloadFileFromCloud() async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('progress.csv');
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/progress.csv');
      await storageRef.writeToFile(file);
      print('File downloaded from cloud storage.');
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  Future<List<Progress>> getAllProgress() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool connected = connectivityResult != ConnectivityResult.none;

    if (connected) {
      print('Connected to the internet. Downloading file from cloud storage.');
      await _downloadFileFromCloud();
    } else {
      print('No internet connection. Using local CSV file.');
    }

    final file = await _localFile();
    if (!await file.exists()) {
      return [];
    }

    final csvString = await file.readAsString();
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);

    List<String> headers = ['id', 'userId', 'date', 'weight', 'bodyFat'];
    List<Progress> progresses = rowsAsListOfValues.map((row) {
      Map<String, dynamic> progressMap = Map<String, dynamic>.fromIterables(headers, row);
      return Progress.fromMap(progressMap, progressMap['id']);
    }).toList();

    return progresses;
  }

  Future<void> createProgress(Progress progress) async {
    final file = await _localFile();
    final csvRow = '${progress.id},${progress.userId},${progress.date.toIso8601String()},${progress.weight},${progress.bodyFat}\n';
    await file.writeAsString(csvRow, mode: FileMode.append);
    await _uploadFileToCloud();
  }

  Future<void> deleteProgress(String id) async {
    final file = await _localFile();
    if (!await file.exists()) return;

    final csvString = await file.readAsString();
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);

    rowsAsListOfValues.removeWhere((row) => row[0] == id);

    String newCsv = const ListToCsvConverter().convert(rowsAsListOfValues);
    await file.writeAsString(newCsv);
    await _uploadFileToCloud();
  }

  Future<void> _uploadFileToCloud() async {
    try {
      final file = await _localFile();
      final storageRef = FirebaseStorage.instance.ref().child('progress.csv');
      await storageRef.putFile(file);
      print('File uploaded to cloud storage.');
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
}
