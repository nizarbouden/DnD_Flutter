import 'dart:convert';
import 'package:http/http.dart' as http;

class IconService {
  static const String baseUrl =
      'http://10.0.2.2:3000'; // Local backend for Android emulator

  Future<List<Map<String, dynamic>>> fetchIcons() async {
    final uri = Uri.parse('$baseUrl/icons/getallicons');

    try {
      final response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> jsonData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(
            jsonData.map((item) => item as Map<String, dynamic>));
      } else {
        throw Exception('Failed to load icons: ${response.body}');
      }
    } catch (e) {
      print('Error fetching icons: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> createIcon({
    required String name,
    required String image,
    required String desc,
  }) async {
    final uri = Uri.parse('$baseUrl/icons');
    final body = json.encode({'name': name, 'image': image, 'desc': desc});

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('Failed to create icon. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating icon: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateIcon({
    required String id,
    required String name,
    required String image,
    required String desc,
  }) async {
    final uri = Uri.parse('$baseUrl/icons/$id');
    final body = json.encode({'name': name, 'image': image, 'desc': desc});

    try {
      final response = await http.patch(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('Failed to update icon. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error updating icon: $e');
      return null;
    }
  }

  Future<bool> deleteIcon(String id) async {
    final uri = Uri.parse('$baseUrl/icons/$id');

    try {
      final response =
          await http.delete(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        // Deleted successfully
        return true;
      } else {
        print('Failed to delete icon. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting icon: $e');
      return false;
    }
  }
}
