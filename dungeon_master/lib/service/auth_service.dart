import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:3000'; // URL pour l'émulateur Android


  // Méthode générique pour envoyer des requêtes HTTP
  Future<Map<String, dynamic>> _sendRequest(String method, String endpoint, [Map<String, dynamic>? body]) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final headers = {'Content-Type': 'application/json'};
      final encodedBody = body != null ? json.encode(body) : null;

      final response = await (method == 'POST'
          ? http.post(uri, headers: headers, body: encodedBody)
          : method == 'PUT'
          ? http.put(uri, headers: headers, body: encodedBody)
          : http.get(uri, headers: headers)
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Request failed with status: ${response.statusCode}, response: ${response.body}');
      }
    } catch (e) {
      return {'error': true, 'message': 'Request failed: $e'};
    }
  }

  // Méthode de connexion
  Future<Map<String, dynamic>> login(String email, String password) async {
  final response = await _sendRequest(
  'POST',
  '/auth/login',
  {'email': email, 'password': password}
  );
  return response;
  }

  // Inscription
  Future<Map<String, dynamic>> signUp(String email, String password) async {
  final response = await _sendRequest(
  'POST',
  '/auth/signup',
  {'email': email, 'password': password}
  );
  return response;
  }

  // Vérification OTP
  Future<Map<String, dynamic>> verifyOtp(String email, String otp, SignupDto signupData) async {
  final response = await _sendRequest(
  'POST',
  '/auth/verifyOtp',
  {'email': email, 'otp': otp, 'signupData': signupData.toJson()}
  );
  return response;
  }

  // Mise à jour du nom d'utilisateur
  Future<Map<String, dynamic>> updateUserName(String userId, String newName) async {
  final response = await _sendRequest(
  'PUT',
  '/auth/$userId/updateName',
  {'name': newName}
  );
  return response;

  }

  // Méthode pour mettre à jour le mot de passe
  Future<Map<String, dynamic>> updatePassword(String userId, String oldPassword, String newPassword) async {
    final response = await _sendRequest(
      'PUT',
      '/auth/$userId/updatePassword',
      {
        'password': newPassword,  // Utilise "password" comme clé si c'est ce qui est attendu
      },
    );
    return response;
  }


  Future<Map<String, dynamic>> verifyOtpForChangeEmail(String email, String otp, String userId) async {
    final response = await _sendRequest(
      'POST',
      '/verifyOtpChangeMail',
      {
        'email': email,
        'otp': otp,
        'userId': userId,
      },
    );
    return response;
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
