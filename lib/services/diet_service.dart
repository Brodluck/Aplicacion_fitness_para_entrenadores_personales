import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ventanas/models/diet.dart';
import 'package:ventanas/models/user.dart';
import 'package:ventanas/services/json_utils.dart';

class DietService {
  Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile() async {
    final path = await _localPath();
    return File('$path/diets.json');
  }

  Future<List<Diet>> getAllDiets() async {
    try {
      final file = await _localFile();
      if (!await file.exists()) {
        return [];
      }
      final jsonData = await file.readAsString();
      List<dynamic> data = json.decode(jsonData);
      return data.map((item) => Diet.fromJson(item)).toList();
    } catch (e) {
      print('Error reading diets: $e');
      return [];
    }
  }

  Future<void> assignDietToClient(String clientId, Diet diet) async {
    try {
      User? client = await JsonUtils.getUserById(clientId);
      if (client != null) {
        client.assignedDiets = List.from(client.assignedDiets)..add(diet);
        await JsonUtils.updateUser(client);
        print('Diet ${diet.name} assigned to client ${client.firstName} ${client.lastName}');
      } else {
        print('Client not found');
      }
    } catch (e) {
      print('Error assigning diet to client: $e');
    }
  }
}
