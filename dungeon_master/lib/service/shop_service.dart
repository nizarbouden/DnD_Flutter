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

  Future<Map<String, dynamic>> updateCoinsGemsShop(
      String id, Map<String, dynamic> updatedPackData) async {
    try {
      // Define the allowed fields based on your DTO
      final allowedFields = [
        'images', // String
        'type', // Number
        'amount', // Number
        'price', // Number
      ];

      // Filter the updatedPackData to only include allowed fields
      final filteredData = Map<String, dynamic>.fromEntries(
        updatedPackData.entries.where((entry) => allowedFields.contains(entry.key)),
      );

      // Create the URL for the PATCH request
      final Uri url = Uri.parse('$baseUrl/shopcg/$id');

      // Send the PATCH request to the backend
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(filteredData), // Send filtered data in the body
      );

      // If the response status code is 200 or 201, return the updated pack
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to update pack');
      }
    } catch (error) {
      print('Error updating pack: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updatePack(
      String id, Map<String, dynamic> updatedPackData) async {
    try {
      // Define the allowed fields based on your DTO
      final allowedFields = [
        'images', // String
        'packType', // Number
        'price', // Number
        'priceType', // Number
        'quantity', // Number
        'available', // Boolean
      ];

      // Filter the updatedPackData to only include allowed fields
      final filteredData = Map<String, dynamic>.fromEntries(
        updatedPackData.entries.where((entry) => allowedFields.contains(entry.key)),
      );

      // Create the URL for the PATCH request
      final Uri url = Uri.parse('$baseUrl/packs/$id');

      // Send the PATCH request to the backend
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(filteredData), // Send filtered data in the body
      );

      // If the response status code is 200 or 201, return the updated pack
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to update pack');
      }
    } catch (error) {
      print('Error updating pack: $error');
      rethrow;
    }
  }

  Future<void> deletePack(String packId) async {
    try {
      // Prepare the URL for the DELETE request
      final Uri url = Uri.parse('$baseUrl/packs/$packId');
      print(url);
      // Send the DELETE request to delete the user
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      // Handle the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('User deleted successfully');
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (error) {
      print('Error deleting user: $error');
      rethrow;
    }
  }

  Future<void> deleteCoinsGems(String coinsgemsId) async {
    try {
      // Prepare the URL for the DELETE request
      final Uri url = Uri.parse('$baseUrl/shopcg/$coinsgemsId');
      print(url);
      // Send the DELETE request to delete the user
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      // Handle the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('User deleted successfully');
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (error) {
      print('Error deleting user: $error');
      rethrow;
    }
  }
  Future<Map<String, dynamic>> addPack(Map<String, dynamic> newPack) async {
    try {
      final Uri url = Uri.parse('$baseUrl/packs');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newPack),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;  // Return the full pack data with the ID
      } else {
        throw Exception('Failed to add pack');
      }
    } catch (error) {
      print('Error adding pack: $error');
      rethrow;
    }
  }
  Future<Map<String, dynamic>> addCoinShop(Map<String, dynamic> newPack) async {
    try {
      final Uri url = Uri.parse('$baseUrl/shopcg');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newPack),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;  // Return the full pack data with the ID
      } else {
        throw Exception('Failed to add pack');
      }
    } catch (error) {
      print('Error adding pack: $error');
      rethrow;
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


  Future<List<Map<String, dynamic>>> fetchCoinsGemsShop() async {
    final uri = Uri.parse('$baseUrl/shopcg'); // Assurez-vous que l'endpoint est correct

    try {
      final response = await http.get(uri, headers: {'Content-Type': 'application/json'});
      print("gemsc?.");
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("gemsc?..");
        // Vérifiez que la réponse est une liste
        final List<dynamic> jsonData = json.decode(response.body);

        // Convertissez chaque élément de la liste en Map<String, dynamic>
        return List<Map<String, dynamic>>.from(jsonData.map((item) => item as Map<String, dynamic>));
      } else {
        print("gemsc?...");
        throw Exception('Failed to load users: ${response.body}');
      }
    } catch (e) {
      return [];
    }
  }


}
