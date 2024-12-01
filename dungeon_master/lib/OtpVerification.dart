import 'dart:convert';
import 'package:dungeon_master/service/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'Homepage.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final SignupDto signupData;

  OtpVerificationScreen({required this.email, required this.signupData});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();

  // URL de base pour l'API
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<void> _submitOtp() async {
    final otp = _otpController.text;

    if (otp.isEmpty) {
      // Affiche un message d'erreur si l'OTP est vide
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }

    try {
      final result = await verifyOtp(widget.email, otp, widget.signupData);

      if (result['message'] == 'Signup successful') {
        // Redirection vers la page d'accueil ou de connexion
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );

      } else {
        // Afficher un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'OTP verification failed')),
        );
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during OTP verification')),
      );
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
          'signupData': signupData.toJson(),
        }),
      );

      if (response.statusCode == 200) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: 'Enter OTP'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitOtp,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}


