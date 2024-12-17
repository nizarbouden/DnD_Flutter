import 'package:flutter/material.dart';

class ItemDetailpage extends StatelessWidget {
  final String title;
  final String imagePath;
  final String oldPrice;
  final String newPrice;

  // Constructeur qui reçoit les données dynamiques
  const ItemDetailpage({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.oldPrice,
    required this.newPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Item'),

      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image principale
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                imagePath, // Utilisation de l'image passée en paramètre
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 16),

            // Détails du produit
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom et notes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title, // Utilisation du titre passé en paramètre
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        newPrice, // Utilisation du prix actuel passé en paramètre
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        oldPrice, // Utilisation de l'ancien prix passé en paramètre
                        style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Elevate your casual wardrobe with our Loose Fit Printed T-shirt. '
                        'Crafted from premium cotton for maximum comfort, this relaxed-fit tee features.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),

                  // Boutons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Ajouter au panier
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: Text('MODIFY'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Acheter maintenant
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: Text('DELETE'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




