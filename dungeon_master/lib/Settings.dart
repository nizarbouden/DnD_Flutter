import 'package:dungeon_master/service/auth_service.dart';
import 'package:dungeon_master/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsPage extends StatefulWidget {
  final Map<String, dynamic> user; // Données utilisateur initiales

  SettingsPage({required this.user});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Map<String, dynamic> user; // État local pour stocker les données utilisateur
  String currentUserEmail = ""; // Email de l'utilisateur

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Ajoutez cette clé

  @override
  void initState() {
    super.initState();
    user = widget.user; // Initialisez l'état local avec les données passées
  }
  void _updateEmail(String newEmail) {
    setState(() {
      user['email'] = newEmail; // Mettez à jour l'email dans le state
    });
  }
  // Méthode pour mettre à jour les données utilisateur
  void _updateUserData(Map<String, dynamic> updatedUser) {
    setState(() {
      user = updatedUser;
    });
  }

  Future<List<Map<String, dynamic>>> _fetchPlayerIcons(String userId) async {
    try {
      // Appelle la méthode fetchIconsByOwner() du service AuthService avec l'ID utilisateur
      List<Map<String, dynamic>> icons = await AuthService().fetchIconsByOwner(userId);
      return icons; // Retourne la liste des icônes
    } catch (e) {
      // En cas d'erreur, affichez un message ou traitez l'exception
      throw Exception("Erreur lors du chargement des icônes : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userId = user['_id'] ?? ''; // Récupère l'ID utilisateur ou une chaîne vide
    if (userId.isEmpty) {
      throw Exception("User ID is required for the Drawer");
    }
    return Scaffold(
      key: _scaffoldKey, // Associez la clé ici
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
            SizedBox(height: 90),
            // Profile Section - Première section
            _buildProfileSection(context),

            SizedBox(height: 40),
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
            SizedBox(height: 40),

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

      drawer: _buildDrawer(context, userId), // Associe le Drawer ici
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final String userName = user['name'] ?? 'Nom inconnu'; // Nom de l'utilisateur
    final String userEmail = user['email'] ?? 'Email inconnu'; // Email de l'utilisateur
    final String? userImage = user['image']; // Image dynamique de l'utilisateur

    return Card(
      color: Colors.black.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Image du profil cliquable
            GestureDetector(
              onTap: () {
                _scaffoldKey.currentState!.openDrawer(); // Ouvrir le Drawer
              },
              child: CircleAvatar(
                radius: 40,
                backgroundImage: (userImage != null && userImage.isNotEmpty)
                    ? (userImage.startsWith('assets/')
                    ? AssetImage(userImage) as ImageProvider
                    : NetworkImage(userImage))
                    : AssetImage('assets/default_profile.png'), // Image par défaut
              ),
            ),
            const SizedBox(width: 16),
            // Nom de l'utilisateur
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName, // Affiche le nom dynamique
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                Text(
                  userEmail, // Affiche l'email dynamique
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, String ownerId) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 100.0, right: 20.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Drawer(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg_friends.webp'), // Fond du drawer
                  fit: BoxFit.cover,
                ),
              ),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: AuthService().fetchIconsByOwner(ownerId), // Charge les icônes liées à l'utilisateur
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print("Erreur FutureBuilder : ${snapshot.error}");
                    return Center(child: Text('Erreur de chargement des icônes'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucune icône disponible'));
                  } else {
                    List<Map<String, dynamic>> icons = snapshot.data!;
                    print("Données des icônes reçues : $icons"); // Debug

                    return GridView.builder(
                      padding: EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: icons.length,
                      itemBuilder: (context, index) {
                        var iconData = icons[index];
                        String iconPath = iconData['image'] ?? '';

                        if (iconPath.isEmpty || !iconPath.startsWith('assets/')) {
                          return Center(child: Icon(Icons.error));
                        }

                        return GestureDetector(
                          onTap: () async {
                            // Met à jour l'image de l'utilisateur
                            await _updateUserAvatar(ownerId, iconPath, context);

                            // Ferme le drawer après la mise à jour
                            Navigator.of(context).pop();

                            // Recharge la page en utilisant setState
                            setState(() {
                              // Met à jour l'image dans les données utilisateur si nécessaire
                              user['image'] = iconPath; // Assurez-vous que 'user' est bien mis à jour
                            });
                          },
                          child: Image.asset(
                            iconPath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print("Erreur pour $iconPath : $error");
                              return Icon(Icons.error);
                            },
                          ),
                        );

                      },
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }





// Méthode pour mettre à jour l'avatar de l'utilisateur
  Future<void> _updateUserAvatar(String userId, String newAvatarUrl, BuildContext context) async {
    try {
      AuthService authService = AuthService();
      // Appeler la méthode updateAvatar du service AuthService
      final response = await authService.updateAvatar(userId, newAvatarUrl);

      // Vérifier la réponse
      if (response.containsKey('message') && response['message'] == 'Avatar updated successfully') {
        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Avatar updated successfully')));
      } else {
        // Afficher un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update avatar')));
        print(response);
      }
    } catch (e) {
      // En cas d'erreur lors de l'appel
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }




  // Fonction pour construire une carte de paramètres généraux
  Widget _buildSettingsCard(BuildContext context, {required String title, required List<Widget> children}) {
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

  // Fonction pour construire un bouton de paramètres
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
              // Si l'utilisateur a été modifié, renvoyer les nouvelles données à la page précédente
              if (user != null) {
                Navigator.pop(context, user);  // Passer les données de l'utilisateur modifié à la page précédente
              } else {
                Navigator.pop(context);  // Revenir sans données si l'utilisateur n'a pas été modifié
              }
            }
            else if (label == "Change Name") {
              if (user == null || user['name'] == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User data is missing or invalid')),
                );
                return;
              }
              _showChangeNameDialog(context, user);
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
                  'Confirm Logout',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE1C699), // Couleur dorée
                    fontFamily: 'Serif', // Remplacez par votre police
                  ),
                ),
                const SizedBox(height: 20),

                // Texte de confirmation
                const Text(
                  'Are you sure you want to log out?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE1C699), // Couleur dorée
                    fontFamily: 'Serif',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Boutons d'actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Bouton "Cancel"
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Ferme la boîte de dialogue
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1E1E), // Fond sombre
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Coins arrondis
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Color(0xFFE1C699)), // Texte doré
                      ),
                    ),

                    // Bouton "Log Out"
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Ferme la boîte de dialogue
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignInApp()), // Navigue vers SignInPage
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE1C699), // Couleur dorée
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Coins arrondis
                        ),
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(color: Color(0xFF2C2C2C)), // Texte sombre
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChangeNameDialog(BuildContext context, Map<String, dynamic> user) {
    if (user == null || user['_id'] == null) {
      print('User or User ID is missing!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data or ID is not available')),
      );
      return;
    }

    TextEditingController _nameController = TextEditingController(text: user['name']);
    AuthService apiService = AuthService(); // Service API

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  'Change Account Name',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE1C699),
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'New Name',
                    labelStyle: const TextStyle(
                      color: Color(0xFFE1C699),
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
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
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE1C699),
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    String newName = _nameController.text.trim();

                    if (newName.isNotEmpty) {
                      try {
                        String userId = user['_id']; // R cup re l'ID utilisateur
                        final result = await apiService.updateUserName(userId, newName);

                        String message = result['message'] ?? 'Name updated successfully';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );

                        // Mettre   jour l' tat local de la page Settings
                        _updateUserData({...user, 'name': newName});

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
                  icon: const Icon(Icons.save, color: Color(0xFFE1C699)),
                  label: const Text(
                    'Save',
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
  }




  void _showChangeEmailDialog(BuildContext context) {
    final _emailController = TextEditingController();
    String errorMessage = ''; // Variable pour stocker le message d'erreur
    bool _isEmailValid = false; // Variable pour stocker l'état de la validation

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( // Utilisation de StatefulBuilder pour mettre à jour la vue
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
                    const Text(
                      'Change Email',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE1C699), // Couleur dorée
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
                          style: const TextStyle(
                            color: Colors.redAccent, // Couleur de l'erreur
                            fontSize: 14,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Bouton "Save"
                    ElevatedButton.icon(
                      onPressed: () async {
                        final newEmail = _emailController.text.trim();
                        String userId = user['_id']; // ID utilisateur (remplacez par une source dynamique)

                        // Validation de l'email : vérifie si l'email est vide
                        if (newEmail.isEmpty) {
                          setState(() {
                            errorMessage = 'Email cannot be empty'; // Message d'erreur si l'email est vide
                          });
                        } else if (_isEmailValid) {
                          try {
                            // Appelez l'API pour envoyer l'OTP
                            final response = await AuthService().sendOtpForEmailVerification(newEmail);

                            if (response['error'] == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: ${response['message']}')),
                              );
                            } else {
                              // Ne pas fermer immédiatement le dialogue, afficher d'abord le dialogue OTP
                              _showOtpVerificationDialog(context, newEmail, userId);
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        } else {
                          setState(() {
                            errorMessage = 'Please enter a valid email'; // Message d'erreur si l'email est invalide
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


  void _showOtpVerificationDialog(BuildContext context, String newEmail, String userId) {
    final _otpController = TextEditingController();
    AuthService _authService = AuthService();
    String? errorMessage;
    bool isLoading = false;

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
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE1C699),
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                            final response = await _authService.verifyOtpForChangeEmail(newEmail, otp, userId);

                            setState(() {
                              isLoading = false;
                            });

                            if (response['message'] == 'Changed Email successful') {
                              // Affichage du SnackBar pour informer l'utilisateur
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Email successfully changed!",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              // Ferme les dialogues
                              Navigator.of(context).pop(); // Ferme le dialogue OTP
                              Navigator.of(context).pop(); // Ferme le dialogue de changement d'email

                              // Mettez à jour les données de l'utilisateur après changement d'email
                              Map<String, dynamic> updatedUser = {
                                ...user, // Garde les autres informations de l'utilisateur intactes
                                'email': newEmail, // Mettez à jour l'email
                              };

                              // Naviguer à nouveau vers la page SettingsPage avec les nouvelles données utilisateur
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsPage(user: updatedUser), // Passez les données mises à jour
                                ),
                              );
                            }
                            else {
                              setState(() {
                                errorMessage = response['message'] ?? 'Invalid OTP or OTP expired';
                              });
                            }
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                              errorMessage = 'Error: ${e.toString()}';
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







  void _showChangePasswordDialog(BuildContext context) {
    TextEditingController _currentPasswordController = TextEditingController();
    TextEditingController _newPasswordController = TextEditingController();
    AuthService apiService = AuthService();

    String currentPasswordError = '';
    String newPasswordError = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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
                        fontFamily: 'Serif',
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
                          color: Color(0xFFE1C699),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
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
                        errorText: currentPasswordError.isNotEmpty ? currentPasswordError : null,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFE1C699),
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
                        errorText: newPasswordError.isNotEmpty ? newPasswordError : null,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFE1C699),
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: () async {
                        String currentPassword = _currentPasswordController.text.trim();
                        String newPassword = _newPasswordController.text.trim();

                        setState(() {
                          // Réinitialisez les erreurs avant de vérifier
                          currentPasswordError = '';
                          newPasswordError = '';
                        });

                        // Validation des mots de passe
                        if (currentPassword.isEmpty) {
                          setState(() {
                            currentPasswordError = 'Current password cannot be empty';
                          });
                        }
                        if (newPassword.isEmpty) {
                          setState(() {
                            newPasswordError = 'New password cannot be empty';
                          });
                        }

                        if (currentPassword.isNotEmpty && newPassword.isNotEmpty) {
                          try {
                            // Remplacez "userId" par l'ID réel de l'utilisateur
                            String userId = user['_id'];

                            // Étape 1 : Valider les mots de passe avec l'API
                            final isValid = await apiService.validatePasswordChange(userId, currentPassword, newPassword);

                            if (isValid) {
                              // Étape 2 : Si valide, procéder à la mise à jour
                              final result = await apiService.updatePassword(userId, currentPassword, newPassword);

                              String message = result['message'] ?? 'Password updated successfully';
                              Navigator.of(context).pop(); // Fermer la boîte de dialogue
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message)),
                              );
                            } else {
                              setState(() {
                                currentPasswordError = 'Invalid current password';
                              });
                            }
                          } catch (error) {
                            setState(() {
                              currentPasswordError = 'Failed to validate password. Please try again.';
                            });
                          }
                        }
                      },
                      icon: const Icon(Icons.save, color: Color(0xFFE1C699)),
                      label: const Text(
                        'Save',
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
