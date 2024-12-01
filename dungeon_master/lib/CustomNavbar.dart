import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  final void Function(int index) onButtonPressed;

  const CustomNavbar({Key? key, required this.onButtonPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCircularButton(
            onPressed: () => onButtonPressed(0),
            icon: Icons.home,
            label: "Home",
          ),
          _buildCircularButton(
            onPressed: () => onButtonPressed(1),
            icon: Icons.settings,
            label: "Settings",
          ),
          _buildCircularButton(
            onPressed: () => onButtonPressed(2),
            icon: Icons.shopping_cart,
            label: "Shop",
          ),
          _buildCircularButton(
            onPressed: () => onButtonPressed(3),
            icon: Icons.person,
            label: "City Hall",
          ),
        ],
      ),
    );
  }

  // Fonction pour créer un bouton circulaire
  Widget _buildCircularButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(), // Forme circulaire
            backgroundColor: Colors.brown[800],
            padding: const EdgeInsets.all(15), // Taille du bouton
          ),
          child: Icon(
            icon,
            size: 30,
            color: Colors.amber,
          ),
        ),
        const SizedBox(height: 5), // Espacement entre le bouton et le texte
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
