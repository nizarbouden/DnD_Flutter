import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final List<Map<String, dynamic>> products = List.generate(
    20, // On suppose qu'il y a 20 produits maintenant
        (index) => {
      'title': 'Product $index',
      'price': (index + 1) * 20.0,
      'level': index + 1,
      'image': 'assets/gold1.png',
    },
  );

  String searchQuery = '';
  late List<Map<String, dynamic>> filteredProducts;
  bool isAscendingPrice = true;
  bool isAscendingLevel = true;
  bool isAscendingName = true;

  String selectedFilter = '';
  int currentPage = 0; // Pour gérer la page courante

  @override
  void initState() {
    super.initState();
    filteredProducts = products; // Initialement, tous les produits sont affichés
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredProducts = products
          .where((product) =>
          product['title'].toLowerCase().contains(searchQuery))
          .toList();
    });
  }

  void sortByPrice() {
    setState(() {
      isAscendingPrice = !isAscendingPrice;
      selectedFilter = 'price';
      filteredProducts.sort((a, b) => isAscendingPrice
          ? a['price'].compareTo(b['price'])
          : b['price'].compareTo(a['price']));
    });
  }

  void sortByLevel() {
    setState(() {
      isAscendingLevel = !isAscendingLevel;
      selectedFilter = 'level';
      filteredProducts.sort((a, b) => isAscendingLevel
          ? a['level'].compareTo(b['level'])
          : b['level'].compareTo(a['level']));
    });
  }

  void sortByName() {
    setState(() {
      isAscendingName = !isAscendingName;
      selectedFilter = 'name';
      filteredProducts.sort((a, b) => isAscendingName
          ? a['title'].compareTo(b['title'])
          : b['title'].compareTo(a['title']));
    });
  }

  // Fonction pour récupérer les produits pour la page actuelle
  List<Map<String, dynamic>> getPageProducts() {
    int startIndex = currentPage * 10;
    int endIndex = (currentPage + 1) * 10;
    return filteredProducts.sublist(startIndex, endIndex > filteredProducts.length ? filteredProducts.length : endIndex);
  }

  // Fonction pour changer de page
  void goToPage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  void clearFilters() {
    setState(() {
      // Réinitialiser tous les filtres
      isAscendingPrice = true;
      isAscendingLevel = true;
      isAscendingName = true;
      selectedFilter = '';
      searchQuery = '';  // Réinitialiser la recherche
      filteredProducts = List.from(products); // Réinitialiser à la liste d'origine
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: updateSearchQuery,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Filtres horizontaux
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Price'),
                      Icon(
                        isAscendingPrice
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 16,
                      ),
                    ],
                  ),
                  onSelected: (value) => sortByPrice(),
                  selected: selectedFilter == 'price',
                  selectedColor: Colors.blue.shade200,
                  backgroundColor: Colors.grey.shade300,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Level'),
                      Icon(
                        isAscendingLevel
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 16,
                      ),
                    ],
                  ),
                  onSelected: (value) => sortByLevel(),
                  selected: selectedFilter == 'level',
                  selectedColor: Colors.blue.shade200,
                  backgroundColor: Colors.grey.shade300,
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Name'),
                      Icon(
                        isAscendingName
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 16,
                      ),
                    ],
                  ),
                  onSelected: (value) => sortByName(),
                  selected: selectedFilter == 'name',
                  selectedColor: Colors.blue.shade200,
                  backgroundColor: Colors.grey.shade300,
                ),
                SizedBox(width: 8),
                // Clear Filters Button
                FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Clear Filters'),
                      Icon(
                        Icons.clear_all,
                        size: 16,
                      ),
                    ],
                  ),
                  onSelected: (value) => clearFilters(),
                  selected: selectedFilter == '',
                  selectedColor: Colors.red.shade200,
                  backgroundColor: Colors.grey.shade300,
                ),
              ],
            ),
          ),
          // Pagination
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: currentPage > 0
                      ? () => goToPage(currentPage - 1)
                      : null,
                ),
                Text('Page ${currentPage + 1}'),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: (currentPage + 1) * 10 < filteredProducts.length
                      ? () => goToPage(currentPage + 1)
                      : null,
                ),
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
              itemCount: getPageProducts().length,
              itemBuilder: (context, index) {
                final product = getPageProducts()[index];
                return ProductCard(
                  image: product['image'],
                  title: product['title'],
                  price: '\$${product['price']}',
                  level: 'Level ${product['level']}',
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
  final String image;
  final String title;
  final String price;
  final String level;

  const ProductCard({
    required this.image,
    required this.title,
    required this.price,
    required this.level,
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
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 48,
                    ),
                  );
                },
              ),
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
                    Icon(Icons.shield, color: Colors.blue, size: 16),
                    SizedBox(width: 4),
                    Text(level),
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
