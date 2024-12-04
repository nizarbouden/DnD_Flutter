import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  Future<bool> validatePasswordChange(String userId, String oldPassword, String newPassword) async {
    final url = Uri.parse('http://10.0.2.2:3000/auth/validatePasswordChange/');


    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 201) {
        return true; // Validation réussie
      } else {
        throw Exception('Validation failed: ${response.body}');
      }
    } catch (e) {
      print('Erreur API : $e');
      rethrow;
    }
  }


  // Méthode pour envoyer la requête de réinitialisation du mot de passe
  Future<Map<String, dynamic>> resetPasswordRequestOTP(String email) async {
    // Définir l'endpoint de la requête
    const endpoint = '/auth/resetPasswordRequestOTP';

    // Créer le corps de la requête avec l'email
    final body = {
      'email': email,
    };

    // Appeler la méthode générique _sendRequest
    return await _sendRequest('POST', endpoint, body);
  }


  Future<bool> checkEmailAvailability(String email) async {
    print('Appel de checkEmailAvailability');  // Vérifie si la méthode est appelée
    try {
      final response = await _sendRequest('POST', '/auth/checkEmail', {'email': email});

      // Afficher la réponse brute pour vérifier la structure
      print('Réponse brute : $response');

      if (response is Map<String, dynamic>) {
        if (response.containsKey('isAvailable')) {
          return response['isAvailable'];
        } else {
          throw Exception('Invalid response format: Missing isAvailable key');
        }
      } else {
        throw Exception('Invalid response format: Response is not a Map');
      }
    } catch (e) {
      print('Erreur : $e');
      rethrow;
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


  // Méthode pour récupérer un utilisateur par email
  Future<Map<String, dynamic>> getUserByEmail(String email) async {
    final response = await _sendRequest(
        'GET',
        '/auth/getuserbyemail/$email'
    );
    if (response['error'] != null) {
      return {'error': true, 'message': 'Failed to retrieve user'};
    }
    return {'user': response};
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
      '/auth/verifyOtpChangeMail',
      {
        'email': email,
        'otp': otp,
        'userId': userId,
      },
    );
    return response;
  }


// Vérification OTP pour le login
  Future<Map<String, dynamic>> verifyOtpLogin(
      String email, String otp, Map<String, dynamic> signupData) async {
    try {
      final response = await _sendRequest(
        'POST',
        '/auth/verifyOtp',
        {
          'email': email,
          'otp': otp,
          'signupData': signupData,
        },
      );
      return response;
    } catch (e) {
      print('Error during OTP verification: $e');
      rethrow;
    }
  }

  // Nouvelle méthode pour envoyer l'OTP de vérification d'email
  Future<Map<String, dynamic>> sendOtpForEmailVerification(String email) async {
    final response = await _sendRequest(
      'POST',
      '/auth/changeMailOtp', // Endpoint pour envoyer un OTP pour la vérification de l'email
      {'email': email},
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
