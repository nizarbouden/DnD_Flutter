import 'package:dungeon_master/service/auth_service.dart';
import 'package:flutter/material.dart';


import 'ForgotPasswordScreen.dart';
import 'Homepage.dart';
import 'Sign_up.dart';


class SignInApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Enlever la police personnalisée pour utiliser la police par défaut
        fontFamily: 'Roboto', // Vous pouvez utiliser une autre police standard ici
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16), // Style normal sans police spécifique
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
  bool _isLoading = false; // Pour afficher un indicateur de chargement
  String _errorMessage = 'error';

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
                      'Sign In',
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
                      labelStyle: TextStyle(
                          color: Colors.white,
                        fontFamily: 'VecnaBold_4yy4',), // Texte du label en blanc
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
                        return 'Password must be more than 6 characters.';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),


                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() == true) {
                          try {
                            String email = _emailController.text.trim();
                            String password = _passwordController.text.trim();

                            final response = await _authService.login(email, password);

                            if (response['error'] == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response['message'])),
                              );
                            } else {
                              final userResponse = await _authService.getUserByEmail(email);
                              final user = userResponse['user'];

                              if (userResponse['error'] == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(userResponse['message'])),
                                );
                              } else {
                                // Envelopper les données de l'utilisateur dans un ValueNotifier
                                ValueNotifier<Map<String, dynamic>> userNotifier = ValueNotifier<Map<String, dynamic>>(user);

                                // Navigation vers la page d'accueil avec le ValueNotifier
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomePage(user: userNotifier)),
                                      (route) => false, // Cette condition efface toute la pile
                                );
                              }
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Une erreur est survenue. Veuillez réessayer.')),
                            );
                          }
                        }
                      },

                      child: Text(
                        'SIGN IN',
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
                          MaterialPageRoute(builder: (context) => SignUpApp()),
                        );
                      },
                      child: Text(
                        'Dont  have an account? Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
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
                          MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                      child: Text(
                        'Forget Your Password? Recover It',
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