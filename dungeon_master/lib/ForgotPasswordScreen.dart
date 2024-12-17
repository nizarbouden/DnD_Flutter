import 'package:dungeon_master/service/auth_service.dart';
import 'package:dungeon_master/sign_in.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

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
            decoration: const BoxDecoration(
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
                      const Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Subtitle
                    const Text(
                      "Enter your email below, and we’ll send you a link to reset your password securely.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.5, // Line height for better readability
                      ),
                      textAlign: TextAlign.center,
                    ),
                      const SizedBox(height: 30),
                      // Email Field with Validation
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9, // 80% of the screen width
                          child: TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white), // Input text in white
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email, color: Colors.white), // Email icon
                              suffixIcon: _isEmailValid
                                  ? const Icon(Icons.check, color: Colors.green) // Validation icon
                                  : null,
                              hintText: "Enter your email address", // Hint text
                              hintStyle: const TextStyle(color: Colors.white70), // Hint style
                              filled: false, // Removes the filled background
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70), // Bottom border color
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 2), // Highlighted bottom border
                              ),
                              errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent), // Error bottom border
                              ),
                              focusedErrorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent, width: 2), // Focused error border
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              setState(() {
                                _isEmailValid = RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                    .hasMatch(value.trim());
                                _errorMessage = null; // Reset error message
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
                        ),
                      ),


                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Reset Password Button
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                          child: ElevatedButton(
                            onPressed: _validateAndSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7A393D),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12, // Adjusted padding vertically
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "RESET PASSWORD",
                              style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 1.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Return to Login Link
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInApp()),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back, color: Colors.orangeAccent),
                            SizedBox(width: 5),
                            Text(
                              "RETURN TO SIGN IN",
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

      try {
        bool emailLinked = await AuthService().checkAdminEmailAvailability(email);

        if (!emailLinked) {
          await _checkEmailAndSendOtp(email);
        } else {
          setState(() {
            _errorMessage = "Email is not registered to any admin account.";
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = "An error occurred: $e. Please try again.";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Please fix the errors above.";
      });
    }
  }


  Future<void> _checkEmailAndSendOtp(String email) async {
    try {
      final response = await AuthService().resetPasswordRequestOTP(email);

      if (response.containsKey('message')) {
        // Success: Display a message or dialog
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
    }
  }

  void _showOtpDialog() {
    final otpController = TextEditingController();
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
                    const Text(
                      'OTP Verification',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE1C699),
                        fontFamily: 'VecnaBold',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: otpController,
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
                        fontFamily: 'VecnaBold',
                      ),

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
                        final otp = otpController.text.trim();
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
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    String? newPasswordError;
    String? confirmPasswordError;
    bool isLoading = false;

    bool isPasswordValid(String password) {
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
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE1C699),
                        fontFamily: 'VecnaBold',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: newPasswordController,
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
                        fontFamily: 'VecnaBold',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: confirmPasswordController,
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
                        fontFamily: 'VecnaBold',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () async {
                        final newPassword = newPasswordController.text.trim();
                        final confirmPassword = confirmPasswordController.text.trim();

                        setState(() {
                          newPasswordError = null;
                          confirmPasswordError = null;
                        });

                        // Validation des champs
                        if (newPassword.isEmpty) {
                          setState(() {
                            newPasswordError = 'New password cannot be empty';
                          });
                        } else if (!isPasswordValid(newPassword)) {
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
                                MaterialPageRoute(builder: (context) => const SignInApp()),
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