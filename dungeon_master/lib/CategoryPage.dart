import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Men\'s Fashion'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Fonction de recherche
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres horizontaux
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                FilterChip(label: Text('Bags'), onSelected: (value) {}),
                SizedBox(width: 8),
                FilterChip(label: Text('Wallets'), onSelected: (value) {}),
                SizedBox(width: 8),
                FilterChip(label: Text('Footwear'), onSelected: (value) {}),
                SizedBox(width: 8),
                FilterChip(label: Text('Clothes'), onSelected: (value) {}),
                SizedBox(width: 8),
                FilterChip(label: Text('Watches'), onSelected: (value) {}),
              ],
            ),
          ),
          // Grille des produits
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: 10, // Nombre d'éléments
              itemBuilder: (context, index) {
                return ProductCard(
                  imageUrl: 'https://via.placeholder.com/150',
                  title: 'Product $index',
                  price: '\$${(index + 1) * 20}',
                  rating: 4.5,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final double rating;

  const ProductCard({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(price, style: TextStyle(color: Colors.green)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(rating.toString()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
