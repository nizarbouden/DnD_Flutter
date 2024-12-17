import 'dart:convert';
import 'dart:math';
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
      rethrow;
    }
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    final url = Uri.parse('http://10.0.2.2:3000/admins/ActuallyResetPassword'); // L'URL de l'API

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
        print("reset succ");
        // Si la réponse est un succès
        return true;
      } else {
        throw Exception('Failed to reset password: ${response.body}');
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyOtpForResetPassword(String email, String otp) async {
    const endpoint = '/admins/verifyOtpResetPassword'; // L'endpoint pour vérifier l'OTP
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
      return false;
    }
  }


  // Méthode pour envoyer la requête de réinitialisation du mot de passe
  Future<Map<String, dynamic>> resetPasswordRequestOTP(String email) async {
    // Définir l'endpoint de la requête
    const endpoint = '/admins/resetPasswordRequestOTP';

    // Créer le corps de la requête avec l'email
    final body = {
      'email': email,
    };

    // Appeler la méthode générique _sendRequest
    return await _sendRequest('POST', endpoint, body);
  }
  Future<bool> checkAdminEmailAvailability(String email) async {
    try {
      // Build the URL with the email as a query parameter
      final url = Uri.parse('http://10.0.2.2:3000/admins/checkEmail?email=$email');

      // Send a POST request without a body (since email is in the query parameter)
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      // Check for successful status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Decode the response JSON (expected to be a boolean)
        final responseData = json.decode(response.body);

        if (responseData is bool) {
          return responseData; // Return true if available, false otherwise
        } else {
          throw Exception('Invalid response format: Expected a boolean value');
        }
      } else {
        // Handle unexpected status codes
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error checking email availability: $e');
      return false; // Consider email unavailable in case of an error
    }
  }


  Future<Map<String, dynamic>> login(String email, String password) async {
    const String apiUrl = 'http://10.0.2.2:3000/admins/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseData['message'],
          'admin': responseData['admin'],
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Invalid email or password.',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to login. Please try again later.',
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'success': false,
        'message': 'Something went wrong. Please try again later.',
        'error': e.toString(),
      };
    }
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


  Future<Map<String, dynamic>> fetchAdminByEmail(String email) async {
    final String apiUrl = 'http://10.0.2.2:3000/admins/getByEmail/$email'; // Replace with your server URL

    try {
      // Send a GET request to fetch admin by email
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse the successful response
        final Map<String, dynamic> adminData = jsonDecode(response.body);
        return {
          'success': true,
          'admin': adminData, // Admin details
        };
      } else if (response.statusCode == 404) {
        // Admin not found
        return {
          'success': false,
          'message': 'Admin not found. Please check the email.',
        };
      } else {
        // Generic error for other status codes
        return {
          'success': false,
          'message': 'Failed to retrieve admin. Please try again later.',
        };
      }
    } catch (e) {
      // Handle network or unexpected errors
      return {
        'success': false,
        'message': 'Something went wrong. Please check your connection.',
        'error': e.toString(),
      };
    }
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
