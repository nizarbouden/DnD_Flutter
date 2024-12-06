import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:3000'; // URL pour l'émulateur Android


  // Méthode générique pour envoyer des requêtes HTTP
  Future<Map<String, dynamic>> _sendRequest(String method, String endpoint,
      [Map<String, dynamic>? body]) async {
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
        throw Exception('Request failed with status: ${response
            .statusCode}, response: ${response.body}');
      }
    } catch (e) {
      return {'error': true, 'message': 'Request failed: $e'};
    }
  }


// Méthode pour récupérer toutes les icônes des joueurs
  Future<List<Map<String, dynamic>>> fetchPlayerIcons() async {
    final uri = Uri.parse('$baseUrl/playericons'); // L'URL de votre API pour les icônes
    try {
      final response = await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200|| response.statusCode == 201) {
        // Retourne une liste d'icônes en s'assurant que c'est une liste de Map<String, dynamic>
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load player icons');
      }
    } catch (e) {
      print('Error fetching player icons: $e');
      return []; // Retourne une liste vide en cas d'erreur
    }
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final uri = Uri.parse('$baseUrl/auth/findAll'); // Assurez-vous que l'endpoint est correct

    try {
      final response = await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Vérifiez que la réponse est une liste
        final List<dynamic> jsonData = json.decode(response.body);

        // Convertissez chaque élément de la liste en Map<String, dynamic>
        return List<Map<String, dynamic>>.from(jsonData.map((item) => item as Map<String, dynamic>));
      } else {
        throw Exception('Failed to load users: ${response.body}');
      }
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> updateAvatar(String userId, String newAvatarUrl) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/auth/$userId/updateImage'),
        body: json.encode({
          'image': newAvatarUrl,  // Utilisation du champ 'image' comme une chaîne de caractères
        }),
        headers: {
          'Content-Type': 'application/json',  // Indiquer que la requête est en JSON
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'message': 'Avatar updated successfully'};
      } else {
        return {
          'error': 'Failed to update avatar',
          'details': response.body,  // Ajoutez des détails dans la réponse d'erreur
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

// Méthode pour récupérer les icônes par propriétaire
  Future<List<Map<String, dynamic>>> fetchIconsByOwner(String ownerId) async {
    final uri = Uri.parse('$baseUrl/playericons/owner/$ownerId'); // L'URL avec l'ownerId
    try {
      final response = await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Retourne une liste d'icônes en s'assurant que c'est une liste de Map<String, dynamic>
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load icons for owner $ownerId');
      }
    } catch (e) {
      print('Error fetching icons for owner: $e');
      return []; // Retourne une liste vide en cas d'erreur
    }
  }

  Future<bool> validatePasswordChange(String userId, String oldPassword,
      String newPassword) async {
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

  Future<bool> resetPassword(String email, String newPassword) async {
    final url = Uri.parse('http://10.0.2.2:3000/auth/ActuallyResetPassword'); // L'URL de l'API

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': newPassword, // Nouveau mot de passe
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Si la réponse est un succès
        return true;
      } else {
        throw Exception('Failed to reset password: ${response.body}');
      }
    } catch (e) {
      print('API Error: $e');
      return false;
    }
  }

  Future<bool> verifyOtpForResetPassword(String email, String otp) async {
    final endpoint = '/auth/verifyOtpResetPassword'; // L'endpoint pour vérifier l'OTP
    final body = {
      'email': email,
      'otp': otp,
    };

    try {
      // Appel de la méthode _sendRequest pour envoyer la requête POST
      final response = await _sendRequest('POST', endpoint, body);

      // Vérifier si la réponse contient un utilisateur
      if (response['user'] != null) {
        // Si l'utilisateur est trouvé, la vérification est réussie
        return true;
      } else {
        throw Exception('OTP verification failed: ${response['message']}');
      }
    } catch (e) {
      print('Erreur lors de la vérification de l\'OTP : $e');
      return false;
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
    print('Appel de checkEmailAvailability avec email : $email');

    try {
      // Construire l'URL de l'API
      final url = Uri.parse('http://10.0.2.2:3000/auth/checkEmail');

      // Envoyer la requête POST avec l'email dans le corps de la requête
      final response = await http.post(
        url,
        body: json.encode({'email': email}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Réponse obtenue : ${response.body}'); // Vérifier la réponse brute

      // Vérifier si la requête a réussi
      if (response.statusCode == 200) {
        // Décoder la réponse JSON
        final responseData = json.decode(response.body);

        // Vérifier si la clé 'isAvailable' existe et est de type booléen
        if (responseData.containsKey('isAvailable') && responseData['isAvailable'] is bool) {
          return responseData['isAvailable'];
        } else {
          throw Exception('Invalid response format: Missing or incorrect isAvailable key');
        }
      } else {
        // Si le statut HTTP n'est pas 200, lancer une exception
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur dans checkEmailAvailability : $e');
      return false; // En cas d'erreur, considérer l'email comme indisponible
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
