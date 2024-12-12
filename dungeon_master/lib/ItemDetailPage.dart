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
              child: Image.network(
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
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {
                          // Ajouter aux favoris
                        },
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

                  // Options de couleur
                  Text(
                    'Colors',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      _ColorOption(color: Colors.black),
                      _ColorOption(color: Colors.blue),
                      _ColorOption(color: Colors.grey),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Options de taille
                  Text(
                    'Size',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      _SizeOption(size: 'XS'),
                      _SizeOption(size: 'S'),
                      _SizeOption(size: 'M'),
                    ],
                  ),
                  SizedBox(height: 24),

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
                          child: Text('ADD TO CART'),
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
                          child: Text('BUY NOW'),
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


class _ColorOption extends StatelessWidget {
  final Color color;

  const _ColorOption({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey),
      ),
    );
  }
}

class _SizeOption extends StatelessWidget {
  final String size;

  const _SizeOption({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(size, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
