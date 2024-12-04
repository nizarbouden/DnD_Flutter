import 'package:dungeon_master/service/auth_service.dart';
import 'package:dungeon_master/sign_in.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService(); // Instance du service AuthService
  String? _errorMessage;
  bool _isEmailValid = false; // Pour gérer l'état de la validation de l'email

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background GIF
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/auth_bg.gif'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      // Subtitle
                      Text(
                        "Enter your email to receive a password reset link.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      // Email Field with Validation
                      TextFormField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.white),
                          suffixIcon: _isEmailValid
                              ? Icon(Icons.check,
                              color: Colors.green) // Icône de validation
                              : null,
                          hintText: "Enter your email address",
                          hintStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            // Vérifie si l'email est valide
                            _isEmailValid =
                                RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                    .hasMatch(value.trim());
                            _errorMessage =
                            null; // Réinitialise le message d'erreur
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email cannot be empty.";
                          } else if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(value)) {
                            return "Please enter a valid email address.";
                          }
                          return null;
                        },
                      ),

                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      SizedBox(height: 20),
                      // Reset Password Button
                      ElevatedButton(
                        onPressed: _validateAndSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7A393D),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "RESET PASSWORD",
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 1.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Return to Login Link
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInApp()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back, color: Colors.orangeAccent),
                            SizedBox(width: 5),
                            Text(
                              "RETURN TO SIGN IN / SIGN UP",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Récupérer l'email de l'utilisateur
      String email = _emailController.text.trim();
      print('Checking email availability for: $email'); // Vérifie si l'email est récupéré

      try {
        // Vérifier la disponibilité de l'email
        bool isEmailAvailable = await AuthService().checkEmailAvailability(email);

        print('Email availability: $isEmailAvailable'); // Afficher ici
        if (!isEmailAvailable) {
          // Si l'email existe, appeler la méthode pour envoyer l'OTP
          await _checkEmailAndSendOtp(email);  // Ajouter 'await' ici
        } else {
          setState(() {
            _errorMessage = "Email is not registered.";
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = "An error occurred: $e. Please try again.";
        });
        print("Error during email validation: $e");
      }
    } else {
      setState(() {
        _errorMessage = "Please fix the errors above.";
      });
    }
  }


  Future<void> _checkEmailAndSendOtp(String email) async {
    try {
      // Step 2: If the email exists, send the OTP
      final response = await AuthService().resetPasswordRequestOTP(email);

      if (response.containsKey('message')) {
        // Success: Display a message or dialog
        print(response['message']);
        _showOtpDialog(); // Call the OTP dialog (no need to return anything)
      } else {
        // Error: Display error message
        setState(() {
          _errorMessage = 'Failed to send OTP. Please try again.';
        });
      }
    } catch (e) {
      // Handle errors
      setState(() {
        _errorMessage = 'Error: $e. Please try again.';
      });
      print('Error: $e');
    }
  }

  void _showOtpDialog() {
    final _otpController = TextEditingController();
    String? errorMessage;
    bool isLoading = false;
    String email = _emailController.text.trim(); // Email de l'utilisateur

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color(0xFF2C2C2C),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFFE1C699)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'OTP Verification',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE1C699),
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _otpController,
                      decoration: InputDecoration(
                        labelText: 'OTP Code',
                        labelStyle: const TextStyle(
                          color: Color(0xFFE1C699),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFFE1C699),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFE1C699)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFE1C699)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                        errorText: errorMessage,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFE1C699),
                        fontFamily: 'Serif',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    if (errorMessage != null && errorMessage!.isNotEmpty)
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () async {
                        final otp = _otpController.text.trim();
                        if (otp.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            // Appel à la méthode de vérification OTP
                            final isValid = await _authService.verifyOtpForResetPassword(email, otp);

                            setState(() {
                              isLoading = false;
                            });

                            if (isValid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "OTP successfully verified!",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.of(context).pop(); // Fermer le dialogue OTP

                              // Afficher le dialogue pour réinitialiser le mot de passe
                              _showResetPasswordDialog(context, email);
                            } else {
                              setState(() {
                                errorMessage = 'Invalid OTP. Please try again.';
                              });
                            }
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                              errorMessage = 'Error occurred during OTP verification.';
                            });
                          }
                        } else {
                          setState(() {
                            errorMessage = 'Please enter the OTP';
                          });
                        }
                      },
                      icon: isLoading
                          ? const CircularProgressIndicator(color: Color(0xFFE1C699))
                          : const Icon(Icons.verified, color: Color(0xFFE1C699)),
                      label: const Text(
                        'Verify OTP',
                        style: TextStyle(color: Color(0xFFE1C699)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1E1E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showResetPasswordDialog(BuildContext context, String email) {
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    String? newPasswordError;
    String? confirmPasswordError;
    bool isLoading = false;

    bool _isPasswordValid(String password) {
      // Vérifie que le mot de passe a au moins 6 caractères
      if (password.length < 6) {
        return false;
      }

      // Vérifie qu'il contient au moins un chiffre
      bool hasDigit = password.contains(RegExp(r'\d'));
      return hasDigit;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color(0xFF2C2C2C),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFFE1C699)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Reset Password',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE1C699),
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        labelStyle: const TextStyle(color: Color(0xFFE1C699)),
                        prefixIcon: const Icon(Icons.lock, color: Color(0xFFE1C699)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFE1C699)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFE1C699)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                        errorText: newPasswordError,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFE1C699),
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        labelStyle: const TextStyle(color: Color(0xFFE1C699)),
                        prefixIcon: const Icon(Icons.lock, color: Color(0xFFE1C699)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFE1C699)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFE1C699)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                        errorText: confirmPasswordError,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFE1C699),
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () async {
                        final newPassword = _newPasswordController.text.trim();
                        final confirmPassword = _confirmPasswordController.text.trim();

                        setState(() {
                          newPasswordError = null;
                          confirmPasswordError = null;
                        });

                        // Validation des champs
                        if (newPassword.isEmpty) {
                          setState(() {
                            newPasswordError = 'New password cannot be empty';
                          });
                        } else if (!_isPasswordValid(newPassword)) {
                          setState(() {
                            newPasswordError = 'Password must be at least 6 characters long and contain a number';
                          });
                        }

                        if (confirmPassword.isEmpty) {
                          setState(() {
                            confirmPasswordError = 'Confirm password cannot be empty';
                          });
                        }

                        if (newPassword == confirmPassword) {
                          try {
                            setState(() {
                              isLoading = true;
                            });

                            final isPasswordReset = await _authService.resetPassword(email, newPassword);

                            setState(() {
                              isLoading = false;
                            });

                            if (isPasswordReset) {
                              Navigator.of(context).pop(); // Fermer le dialogue
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Password reset successful!'),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              // Redirection vers la page de connexion
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => SignInApp()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error resetting password'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error occurred. Please try again.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          setState(() {
                            confirmPasswordError = 'Passwords do not match';
                          });
                        }
                      },
                      icon: isLoading
                          ? const CircularProgressIndicator(color: Color(0xFFE1C699))
                          : const Icon(Icons.lock_reset, color: Color(0xFFE1C699)),
                      label: const Text(
                        'Reset Password',
                        style: TextStyle(color: Color(0xFFE1C699)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1E1E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }




}