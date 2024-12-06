import 'package:dungeon_master/service/auth_service.dart';
import 'package:dungeon_master/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:dungeon_master/service/auth_service.dart' as auth;
import 'Homepage.dart';

void main() => runApp(SignUpApp());

class SignUpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  String? _errorMessage;
  bool _isConfirmPasswordValid = false;  // Variable pour la validation du mot de passe confirmé
  final AuthService _authService = AuthService(); // Instance du service
  bool _isLoading = false; // Indicateur de progression
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
  void _validateConfirmPassword(String value) {
    setState(() {
      _isConfirmPasswordValid = value == _passwordController.text;
    });
  }
  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true; // Début de l'indicateur de progression
      });

      try {
        // Appeler le service d'inscription
        final response = await _authService.signUp(
          _emailController.text,
          _passwordController.text,
        );

        // Si l'inscription réussit
        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign up successful! Please log in.')),
          );

          // Naviguer vers l'écran de connexion
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Sign up failed!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Fin de l'indicateur de progression
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ajout du GIF en arrière-plan
          Container(
            width: double.infinity,
            height: double.infinity, // Cette ligne garantit que le Container prend toute la taille
            child: Image.asset(
              'assets/auth_bg.gif',
              fit: BoxFit.cover, // L'image couvre tout l'écran
            ),
          ),
          SingleChildScrollView( // Ajout de ScrollView
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 200),
                  Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'VecnaBold_4yy4',
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white), // Texte du label en blanc
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white), // Bordure blanche
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white), // Bordure blanche quand l'input est actif
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white), // Bordure blanche quand l'input est focalisé
                      ),
                      prefixIcon: Icon(Icons.email, color: Colors.white), // Icône d'enveloppe en blanc
                      suffixIcon: _isEmailValid
                          ? Icon(Icons.check, color: Colors.green)
                          : null,
                    ),
                    onChanged: _validateEmail,
                    style: TextStyle(color: Colors.white), // Texte en blanc dans le champ de texte
                    validator: (value) {
                      if (value == null || !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white), // Texte du label en blanc
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white), // Bordure blanche
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white), // Bordure blanche quand l'input est actif
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white), // Bordure blanche quand l'input est focalisé
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.white), // Icône en blanc
                      suffixIcon: _isPasswordValid
                          ? Icon(Icons.check, color: Colors.green)
                          : null,
                    ),
                    obscureText: true,
                    onChanged: _validatePassword,
                    style: TextStyle(color: Colors.white), // Texte en blanc dans le champ de texte
                    validator: (value) {
                      if (value == null || value.length <= 5) {
                        return 'Password must be more than 5 characters.';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),
                  // Champ Confirmer le mot de passe
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      suffixIcon: _isConfirmPasswordValid
                          ? Icon(Icons.check, color: Colors.green)
                          : (_confirmPasswordController.text.isNotEmpty
                          ? Icon(Icons.error, color: Colors.red)
                          : null),
                    ),
                    obscureText: true,
                    onChanged: _validateConfirmPassword,
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value != _passwordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() == true) {
                          setState(() {
                            _isLoading = true; // Indique que le processus est en cours
                          });

                          try {
                            final email = _emailController.text.trim(); // Récupère l'email de l'utilisateur et supprime les espaces inutiles

                            // Validation de l'email
                            if (email.isEmpty || !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
                              // Affiche un message d'erreur si l'email est invalide
                              setState(() {
                                _errorMessage = 'Please enter a valid email address.';
                              });
                              return; // Arrête le processus si l'email est invalide
                            }

                            final name = generateRandomPlayerName(); // Générez le nom du joueur
                            final signupData = auth.SignupDto(
                              password: _passwordController.text,
                              name: name,
                            ); // Crée une instance de SignupDto avec les données de l'utilisateur

                            await _signUp(); // Appel à la méthode _signUp (votre logique d'inscription)

                            // Ouvre un dialog pour la vérification OTP
                            _showOtpVerificationDialog(context, email, signupData);
                          } catch (e) {
                            print('Erreur : $e');
                          } finally {
                            setState(() {
                              _isLoading = false; // Réinitialisation de l'état
                            });
                          }
                        }
                      },
                      child: _isLoading
                          ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7A393D),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),



                  SizedBox(height: 30), // Espacement entre le bouton "SIGN UP" et la partie en dessous
                  Center(
                    child: TextButton(
                      onPressed: () { // Navigue vers la page de création de compte (SignUpScreen)
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                        );
                      },
                      child: Text(
                        'Already have an account? Sign in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(child: Text('Log in With',
                      style: TextStyle( color: Colors.white,
                        fontSize: 20,))),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Color(0xFFFFA500), // Exemple de teinte noire, vous pouvez ajuster la couleur
                            BlendMode.srcIn, // Applique la teinte à l'image
                          ),
                          child: Image.asset(
                            'assets/ic_steam.png',
                            height: 32, // Ajustement de la hauteur
                            width: 32,  // Ajustement de la largeur
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(12),
                          elevation: 5,
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {},
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Color(0xFFFFA500), // Exemple de teinte bleue de Facebook
                            BlendMode.srcIn, // Applique la teinte à l'image
                          ),
                          child: Image.asset(
                            'assets/ic_fb.png',
                            height: 32, // Ajustement de la hauteur
                            width: 32,  // Ajustement de la largeur
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(12),
                          elevation: 5,
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {},
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Color(0xFFFFA500), // Teinte orange
                            BlendMode.srcIn, // Applique la teinte à l'image
                          ),
                          child: Image.asset(
                            'assets/ic_reddit.png',
                            height: 32, // Ajustement de la hauteur
                            width: 32,  // Ajustement de la largeur
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(12),
                          elevation: 5,
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {},
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Color(0xFFFFA500), // Exemple de teinte bleue
                            BlendMode.srcIn, // Applique la teinte à l'image
                          ),
                          child: Image.asset(
                            'assets/ic_epic.png',
                            height: 32, // Ajustement de la hauteur
                            width: 32,  // Ajustement de la largeur
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(12),
                          elevation: 5,
                        ),
                      ),

                    ],
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



  void _showOtpVerificationDialog(BuildContext context, String email, auth.SignupDto signupData) {
  final _otpController = TextEditingController();
  AuthService _authService = AuthService();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          bool _isLoading = false;
          String? _errorMessage;

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: const Color(0xFF2C2C2C),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFFE1C699)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Verify OTP',
                      style: TextStyle(
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
                        labelStyle: const TextStyle(color: Color(0xFFE1C699)),
                        errorText: _errorMessage,
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
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFE1C699),
                        fontFamily: 'Serif',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () async {
                        final otp = _otpController.text.trim();
                        if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
                          setState(() {
                            _errorMessage = 'Enter a valid 6-digit OTP.';
                          });
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                          _errorMessage = null;
                        });

                        try {
                          // Appel à la méthode verifyOtpLogin
                          final result = await _authService.verifyOtpLogin(
                            email,
                            otp,
                            signupData.toJson(),
                          );

                          if (result['message'] == 'Signup successful') {
                            // Récupérer l'utilisateur après une inscription réussie
                            final user = result['user']; // Assurez-vous que la réponse contient l'utilisateur

                            // Fermer la boîte de dialogue
                            Navigator.of(context).pop();

                            // Navigation vers la page d'accueil avec l'utilisateur
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(user: user), // Passer l'utilisateur ici
                              ),
                            );
                          } else {
                            setState(() {
                              _errorMessage = result['message'] ?? 'Invalid OTP code.';
                            });
                          }
                        } catch (e) {
                          setState(() {
                            _errorMessage = 'An error occurred. Please try again.';
                          });
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      icon: _isLoading
                          ? const CircularProgressIndicator(color: Color(0xFFE1C699))
                          : const Icon(Icons.verified, color: Color(0xFFE1C699)),
                      label: Text(
                        _isLoading ? 'Verifying...' : 'Verify OTP',
                        style: const TextStyle(color: Color(0xFFE1C699)),
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
            ),
          );
        },
      );
    },
  );
}



