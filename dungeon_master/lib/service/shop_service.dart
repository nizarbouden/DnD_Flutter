import 'dart:convert';
import 'package:http/http.dart' as http;

class ShopService {
  static const String baseUrl = 'http://10.0.2.2:3000'; // URL pour l'émulateur Android


  Future<List<Map<String, dynamic>>> fetchBasicShop() async {
    final uri = Uri.parse('$baseUrl/shopcg'); // Assurez-vous que l'endpoint est correct

    try {
      final response = await http.get(uri, headers: {'Content-Type': 'application/json'});
      print("cg?.");
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("cg?..");
        // Vérifiez que la réponse est une liste
        final List<dynamic> jsonData = json.decode(response.body);

        // Convertissez chaque élément de la liste en Map<String, dynamic>
        return List<Map<String, dynamic>>.from(jsonData.map((item) => item as Map<String, dynamic>));
      } else {
        print("cg?...");
        throw Exception('Failed to load users: ${response.body}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchPacksShop() async {
    final uri = Uri.parse('$baseUrl/packs'); // Assurez-vous que l'endpoint est correct

    try {
      final response = await http.get(uri, headers: {'Content-Type': 'application/json'});
      print("packs?.");
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("packs?..");
        // Vérifiez que la réponse est une liste
        final List<dynamic> jsonData = json.decode(response.body);

        // Convertissez chaque élément de la liste en Map<String, dynamic>
        return List<Map<String, dynamic>>.from(jsonData.map((item) => item as Map<String, dynamic>));
      } else {
        print("packs?...");
        throw Exception('Failed to load users: ${response.body}');
      }
    } catch (e) {
      return [];
    }
  }




}
