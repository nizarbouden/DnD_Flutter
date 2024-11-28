import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:3000'; // URL pour l'émulateur Android

  // Méthode de connexion
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      // Afficher la réponse pour le débogage
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201){
        // Succès
        return json.decode(response.body);
      } else {
        // Échec avec une réponse du serveur
        return {
          'error': true,
          'message': json.decode(response.body)['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      // Échec de la connexion au serveur
      return {
        'error': true,
        'message': 'Failed to connect to the server',
      };
    }
  }

  Future<Map<String, dynamic>> signUp(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to sign up');
    }
  }
  Future<Map<String, dynamic>> verifyOtp(String email, String otp, SignupDto signupData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verifyOtp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'otp': otp,
          'signupData': signupData.toJson(), // Contient maintenant `name` et `password`
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to verify OTP: ${response.body}');
      }
    } catch (e) {
      print('Error during OTP verification: $e');
      rethrow;
    }
  }



}
class SignupDto {
  final String name; // Ajout du champ `name`
  final String password;

  SignupDto({
    required this.name,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
    };
  }
}
String generateRandomPlayerName() {
  final random = Random();
  final randomNumber = random.nextInt(1000); // Génère un nombre aléatoire entre 0 et 999
  return 'player$randomNumber';
}
