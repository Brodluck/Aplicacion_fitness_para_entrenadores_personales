import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodService {
  static const String _apiKey = 'YOUR_EDAMAM_API_KEY';
  static const String _appId = 'YOUR_EDAMAM_APP_ID';

  Future<List<dynamic>> searchFoods(String query) async {
    final url = Uri.parse(
        'https://api.edamam.com/api/food-database/v2/parser?ingr=$query&app_id=$_appId&app_key=$_apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['hints'];
    } else {
      throw Exception('Failed to load food data');
    }
  }
}
