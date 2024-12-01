import 'package:dungeon_master/service/auth_service.dart';
import 'package:dungeon_master/sign_in.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_hs.jpeg'), // Image de fond
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Account Settings Section
            _buildSettingsCard(
              context,
              title: "Account Settings",
              children: [
                _buildSettingsButton(context, "Change Name", Icons.person),
                _buildSettingsButton(context, "Change Password", Icons.lock),
                _buildSettingsButton(context, "Change Email", Icons.email),
              ],
            ),
            SizedBox(height: 20),

            // Audio Settings Section
            _buildSettingsCard(
              context,
              title: "Audio Settings",
              children: [
                _buildAudioSlider(),
              ],
            ),
            SizedBox(height: 20),

            // Quick Actions Section
            _buildSettingsCard(
              context,
              title: "Quick Actions",
              children: [
                _buildSettingsButton(context, "Log Out", Icons.logout),
                _buildSettingsButton(context, "Back", Icons.arrow_back),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Card(
      color: Colors.black.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings, color: Colors.amber),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity, // Le bouton s'étend sur toute la largeur
        child: ElevatedButton(
          onPressed: () {
            if (label == "Log Out") {
              // Afficher la boîte de dialogue de confirmation
              _showLogoutConfirmationDialog(context);
            } else if (label == "Back") {
              // Revenir à la page précédente
              Navigator.pop(context); // Ferme la page actuelle et revient à la page précédente
            } else if (label == "Change Name") {
              // Afficher la pop-up pour changer le nom
              _showChangeNameDialog(context);
            } else if (label == "Change Password") {
              // Afficher la pop-up pour changer le mot de passe
              _showChangePasswordDialog(context);
            } else if (label == "Change Email") {
              // Afficher la pop-up pour changer l'email
              _showChangeEmailDialog(context); // Appeler la méthode pour changer l'email
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centre le texte et l'icône
            children: [
              Icon(icon, color: Colors.amber),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Ferme la boîte de dialogue sans faire de déconnexion
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Ferme la boîte de dialogue et effectue la déconnexion
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInApp()), // Remplacez SignInPage() par votre page de connexion
                );
              },
              child: Text("Log Out"),
            ),
          ],
        );
      },
    );
  }

  void _showChangeNameDialog(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    AuthService apiService = AuthService(); // Créez une instance du service API

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Coins arrondis
          ),
          backgroundColor: const Color(0xFF2C2C2C), // Fond sombre
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Bouton "X" pour fermer
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFFE1C699)), // Couleur dorée
                    onPressed: () {
                      Navigator.of(context).pop(); // Ferme la pop-up
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Titre
                Text(
                  'Change Account Name',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE1C699), // Couleur dorée
                    fontFamily: 'Serif', // Remplacez par la police que vous utilisez
                  ),
                ),
                const SizedBox(height: 20),

                // Champ de saisie
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'New Name',
                    labelStyle: const TextStyle(
                      color: Color(0xFFE1C699), // Couleur dorée
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Color(0xFFE1C699), // Couleur dorée
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE1C699)), // Bordure dorée
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE1C699)), // Bordure dorée
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E), // Fond sombre
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE1C699), // Couleur dorée
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 20),

                // Bouton "Save"
                ElevatedButton.icon(
                  onPressed: () async {
                    String newName = _nameController.text.trim();

                    if (newName.isNotEmpty) {
                      try {
                        // Remplacez "userId" par l'ID réel de l'utilisateur
                        String userId = '673bb51ff1145297991dca61';
                        final result = await apiService.updateUserName(userId, newName);

                        String message = result['message'] ?? 'Name updated successfully';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );

                        // Fermer la pop-up
                        Navigator.of(context).pop();
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update name: $error')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Name cannot be empty')),
                      );
                    }
                  },
                  icon: const Icon(Icons.save, color: Color(0xFFE1C699)), // Icône dorée
                  label: const Text(
                    'Save',
                    style: TextStyle(color: Color(0xFFE1C699)), // Texte doré
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1E1E), // Fond sombre
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Coins arrondis
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  void _showChangeEmailDialog(BuildContext context) {
    final _emailController = TextEditingController();
    String errorMessage = '';  // Variable pour stocker le message d'erreur
    bool _isEmailValid = false; // Variable pour stocker l'état de la validation

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(  // Utilisation de StatefulBuilder pour mettre à jour la vue
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Coins arrondis
              ),
              backgroundColor: const Color(0xFF2C2C2C), // Fond sombre
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Bouton "X" pour fermer
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFFE1C699)), // Couleur dorée
                        onPressed: () {
                          Navigator.of(context).pop(); // Ferme la pop-up
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Titre
                    Text(
                      'Change Email',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE1C699), // Couleur dorée
                        fontFamily: 'Serif', // Remplacez par la police que vous utilisez
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Champ de saisie avec validation d'email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'New Email',
                        labelStyle: const TextStyle(
                          color: Color(0xFFE1C699), // Couleur dorée
                        ),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color(0xFFE1C699), // Couleur dorée
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFE1C699)), // Bordure dorée
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFE1C699)), // Bordure dorée
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E), // Fond sombre
                        suffixIcon: _isEmailValid
                            ? const Icon(Icons.check, color: Colors.green) // Icône de validation
                            : null,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFE1C699), // Couleur dorée
                        fontFamily: 'Serif',
                      ),
                      onChanged: (value) {
                        setState(() {
                          // Validation de l'email avec regex
                          _isEmailValid = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value);
                        });
                      },

                    ),
                    const SizedBox(height: 10),

                    // Afficher le message d'erreur sous le champ de texte si présent
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                            color: Colors.redAccent, // Couleur de l'erreur
                            fontSize: 14,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Bouton "Save"
                    ElevatedButton.icon(
                      onPressed: () {
                        final newEmail = _emailController.text.trim();
                        var userId = "673bb51ff1145297991dca61";
                        if (_isEmailValid) {
                          _showOtpVerificationDialog(context, newEmail, userId);
                          Navigator.of(context).pop(); // Ferme le dialogue de changement d'email
                        } else {
                          setState(() {
                            errorMessage = 'Please enter a valid email'; // Message d'erreur si l'email n'est pas valide
                          });
                        }
                      },
                      icon: const Icon(Icons.save, color: Color(0xFFE1C699)), // Icône dorée
                      label: const Text(
                        'Save',
                        style: TextStyle(color: Color(0xFFE1C699)), // Texte doré
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1E1E), // Fond sombre
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Coins arrondis
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

  void _showOtpVerificationDialog(BuildContext context, String email, String userId) {
    final _otpController = TextEditingController();
    AuthService _authService = AuthService();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Verify OTP'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'OTP Code',
                  hintText: 'Enter the OTP sent to your email',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialog sans rien faire
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final otp = _otpController.text.trim();

                if (otp.isNotEmpty) {
                  try {
                    userId = "673bb51ff1145297991dca61";
                    // Appel à la méthode de vérification de l'OTP
                    final response = await _authService.verifyOtpForChangeEmail(
                      email,
                      otp,
                      userId,
                    );

                    // Vérifier la réponse et afficher un message approprié
                    if (response['message'] == 'Changed Email successful') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Email successfully updated!')),
                      );
                      Navigator.of(context).pop(); // Ferme le dialog
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid OTP or OTP expired')),
                      );
                    }
                  } catch (e) {
                    // Gérer les erreurs de l'API ou autre exception
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter the OTP')),
                  );
                }
              },
              child: Text('Verify OTP'),
            ),
          ],
        );
      },
    );
  }





  void _showChangePasswordDialog(BuildContext context) {
    TextEditingController _currentPasswordController = TextEditingController();
    TextEditingController _newPasswordController = TextEditingController();
    AuthService apiService = AuthService(); // Créez une instance du service API

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Coins arrondis
          ),
          backgroundColor: const Color(0xFF2C2C2C), // Fond sombre
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Bouton "X" pour fermer
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFFE1C699)), // Couleur dorée
                    onPressed: () {
                      Navigator.of(context).pop(); // Ferme la pop-up
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Titre
                Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE1C699), // Couleur dorée
                    fontFamily: 'Serif', // Remplacez par la police que vous utilisez
                  ),
                ),
                const SizedBox(height: 20),

                // Champ pour "Current Password"
                TextField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    labelStyle: const TextStyle(
                      color: Color(0xFFE1C699), // Couleur dorée
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFFE1C699), // Couleur dorée
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE1C699)), // Bordure dorée
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE1C699)), // Bordure dorée
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E), // Fond sombre
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE1C699), // Couleur dorée
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 20),

                // Champ pour "New Password"
                TextField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: const TextStyle(
                      color: Color(0xFFE1C699), // Couleur dorée
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color(0xFFE1C699), // Couleur dorée
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE1C699)), // Bordure dorée
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE1C699)), // Bordure dorée
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E), // Fond sombre
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE1C699), // Couleur dorée
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 20),

                // Bouton "Save"
                ElevatedButton.icon(
                  onPressed: () async {
                    String currentPassword = _currentPasswordController.text.trim();
                    String newPassword = _newPasswordController.text.trim();

                    if (currentPassword.isNotEmpty && newPassword.isNotEmpty) {
                      try {
                        // Remplacez "userId" par l'ID réel de l'utilisateur
                        String userId = '673bb51ff1145297991dca61';
                        final result = await apiService.updatePassword(
                          userId,
                          currentPassword,
                          newPassword,
                        );

                        String message = result['message'] ?? 'Password updated successfully';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );

                        // Fermer la pop-up
                        Navigator.of(context).pop();
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update password: $error')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fields cannot be empty')),
                      );
                    }
                  },
                  icon: const Icon(Icons.save, color: Color(0xFFE1C699)), // Icône dorée
                  label: const Text(
                    'Save',
                    style: TextStyle(color: Color(0xFFE1C699)), // Texte doré
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1E1E), // Fond sombre
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Coins arrondis
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAudioSlider() {
    return Column(
      children: [
        Slider(
          value: 50,
          min: 0,
          max: 100,
          divisions: 10,
          onChanged: (value) {
            // Action pour changer le volume
          },
          activeColor: Colors.amber,
          inactiveColor: Colors.brown[700],
        ),
        Text(
          "Volume: 50%",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
