import 'dart:convert';
import 'package:http/http.dart' as http;

class EquipService {
  static const String baseUrl = 'http://10.0.2.2:3000'; // URL pour l'émulateur Android


  Future<List<Map<String, dynamic>>> fetchEqps() async {
    final uri = Uri.parse('$baseUrl/equipments/getalleqs'); // Assurez-vous que l'endpoint est correct

    try {
      final response = await http.get(uri, headers: {'Content-Type': 'application/json'});
      print("eq?.");
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("eq?..");
        // Vérifiez que la réponse est une liste
        final List<dynamic> jsonData = json.decode(response.body);

        // Convertissez chaque élément de la liste en Map<String, dynamic>
        return List<Map<String, dynamic>>.from(jsonData.map((item) => item as Map<String, dynamic>));
      } else {
        print("eq?...");
        throw Exception('Failed to load users: ${response.body}');
      }
    } catch (e) {
      return [];
    }
  }




}
