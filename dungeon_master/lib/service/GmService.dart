import 'dart:convert';
import 'package:http/http.dart' as http;

class GmService {
  static const String baseUrl = 'http://10.0.2.2:3000'; // Update if needed

  Future<List<Map<String, dynamic>>> fetchGms() async {
    final uri = Uri.parse('$baseUrl/gamemodes/getallgms');
    try {
      final response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> jsonData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(
            jsonData.map((item) => item as Map<String, dynamic>));
      } else {
        throw Exception('Failed to load game modes: ${response.body}');
      }
    } catch (e) {
      print('Error fetching game modes: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> createGm({
    required String name,
    required String image,
    required String desc,
    required String prompt,
  }) async {
    final uri = Uri.parse('$baseUrl/gamemodes');
    final body = json
        .encode({'name': name, 'image': image, 'desc': desc, 'prompt': prompt});

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('Failed to create gamemode. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating gamemode: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateGm({
    required String id,
    required String name,
    required String image,
    required String desc,
    required String prompt,
  }) async {
    final uri = Uri.parse('$baseUrl/gamemodes/$id');
    final body = json
        .encode({'name': name, 'image': image, 'desc': desc, 'prompt': prompt});

    try {
      final response = await http.patch(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('Failed to update gamemode. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error updating gamemode: $e');
      return null;
    }
  }

  Future<bool> deleteGm(String id) async {
    final uri = Uri.parse('$baseUrl/gamemodes/$id');

    try {
      final response =
          await http.delete(uri, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        // Deleted successfully
        return true;
      } else {
        print('Failed to delete gamemode. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting gamemode: $e');
      return false;
    }
  }
}
