import 'package:flutter/material.dart';
import 'CustomNavbar.dart';
import 'Settings.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Permet à l'image de s'étendre sous la navbar

      body: Stack(
        children: [
          // Image d'arrière-plan
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg_hs.jpeg'), // Nom de l'image
                  fit: BoxFit.cover, // Ajuste l'image pour couvrir tout l'écran
                ),
              ),
            ),
          ),
          // Contenu principal
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to the Home Page!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Couleur pour contraster avec l'arrière-plan
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Action lorsque le bouton est cliqué
                  },
                  child: Text('Go to Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7A393D),
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Navigation bar sans marges
      bottomNavigationBar: CustomNavbar(
        onButtonPressed: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
              break;
          }
        },
      ),
    );
  }
}
