import 'package:dungeon_master/service/auth_service.dart';
import 'package:flutter/material.dart';


import 'ForgotPasswordScreen.dart';
import 'Homepage.dart';


class SignInApp extends StatelessWidget {
  const SignInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

        fontFamily: 'VecnaBold',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          displayLarge: TextStyle(fontSize: 32),
          titleLarge: TextStyle(fontSize: 20),
          bodySmall: TextStyle(fontSize: 12),
        ),
      ),
      home: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  final AuthService _authService = AuthService(); // Instance du service
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail(String value) {
    setState(() {
      final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      _isEmailValid = regex.hasMatch(value);
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _isPasswordValid = value.length > 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ajout du GIF en arrière-plan
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/auth_bg.gif',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5), // Black color with 50% transparency
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),
                  const Center(
                    child: Text(
                      'Admin Sign In',
                      style: TextStyle(
                        color: Color(0xFFD4CFC4),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'VecnaBold',
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Ensures it takes minimal vertical space
                      children: [
                        // Email Field
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'VecnaBold',
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Bottom border color
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 2), // Thicker bottom border on focus
                              ),
                              prefixIcon: const Icon(Icons.email, color: Colors.white),
                              suffixIcon: _isEmailValid
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                            ),
                            onChanged: _validateEmail,
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null ||
                                  !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                      .hasMatch(value)) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'VecnaBold',
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Bottom border color
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 2), // Thicker bottom border on focus
                              ),
                              prefixIcon: const Icon(Icons.lock, color: Colors.white),
                              suffixIcon: _isPasswordValid
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                            ),
                            onChanged: _validatePassword,
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.length <= 5) {
                                return 'Password must be more than 6 characters.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() == true) {
                          try {
                            String email = _emailController.text.trim();
                            String password = _passwordController.text.trim();
                            // Call the login function
                            final loginResponse = await _authService.login(email, password);

                            if (loginResponse['success'] == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(loginResponse['message'] ?? 'Invalid credentials')),
                              );
                            } else {
                              final admin = loginResponse["admin"];
                              ValueNotifier<Map<String, dynamic>> userNotifier = ValueNotifier<Map<String, dynamic>>(admin);

                              // Navigate to the HomePage and clear navigation stack
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage(user: userNotifier)),
                                    (route) => false,
                              );
                            }
                          } catch (e) {
                            // Handle any unexpected errors
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('An error occurred! Please try again later.')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A393D),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),

                      child: const Text(
                        'SIGN IN',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Espacement entre le bouton "SIGN UP" et la partie en dessous
                  Center(
                    child: TextButton(
                      onPressed: () { // Navigue vers la page de création de compte (SignUpScreen)
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        'Forgot Your Password? Recover It',
                        style: TextStyle(
                          color: Color(0xFFC0C0C0),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}