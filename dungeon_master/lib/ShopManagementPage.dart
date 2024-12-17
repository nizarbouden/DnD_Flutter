import 'dart:io';

import 'package:dungeon_master/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'CategoryPage.dart';
import 'Homepage.dart';
import 'Settings.dart';
import 'UserManagementPage.dart';
import 'ItemDetailPage.dart';

class ShopManagementPage extends StatefulWidget {
  final ValueNotifier<Map<String, dynamic>> user;

  ShopManagementPage({required this.user});

  @override
  _ShopManagementPageState createState() => _ShopManagementPageState();
}

class _ShopManagementPageState extends State<ShopManagementPage> {
  int _currentIndex = 1; // Set the default index to 1 for ShopManagementPage
  final AuthService _userService = AuthService();
  // List of products for ShopManagementPage
  final List<Map<String, String>> products = [
    {
      'title': "Gold chest",
      'image': 'assets/gold3.png',
      'oldPrice': "\$550.00",
      'newPrice': "\$295.00"
    },
    {
      'title': "Stylish Leather Jacket",
      'image': 'assets/gold2.png',
      'oldPrice': "\$700.00",
      'newPrice': "\$450.00"
    },
    {
      'title': "Classic Black Boots",
      'image': 'assets/gold1.png',
      'oldPrice': "\$350.00",
      'newPrice': "\$220.00"
    },
    {
      'title': "Smart Watch Series 6",
      'image': 'assets/gems3.png',
      'oldPrice': "\$400.00",
      'newPrice': "\$250.00"
    },
  ];

  Future<void> _navigateToSettings() async {
    try {
      final response = await _userService.getUserByEmail(
          widget.user.value['email']);
      if (response['error'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        return;
      }
      final user = response['user'];

      final updatedUser = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPage(user: user),
        ),
      );

      if (updatedUser != null) {
        widget.user.value = updatedUser; // Mettre à jour le ValueNotifier
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
            'Erreur lors de la récupération des données utilisateur.')),
      );
    }
  }

  Future<void> _showOfferDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController discountController = TextEditingController();
    File? _imageFile;

    String priceError = '';
    String discountError = '';
    String nameError = '';
    bool nameValid = false;
    bool priceValid = false;
    bool discountValid = false;

    Future<void> _pickImage() async {
      final status = await Permission.photos.request(); // Pour Android 13+
      if (status.isGranted) {
        // Permission accordée, ouvrez la galerie
        final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _imageFile = File(pickedFile.path);
          });
        }
      } else {
        // Permission refusée, affichez un message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission d'accès refusée")),
        );
      }
    }




    showDialog<void>(
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
                      'Add New Offer',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE1C699), // Couleur dorée
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Champ pour "Offer Name"
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Offer Name',
                        labelStyle: const TextStyle(
                          color: Color(0xFFE1C699),
                        ),
                        prefixIcon: const Icon(
                          Icons.local_offer,
                          color: Color(0xFFE1C699),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: nameValid ? Colors.green : const Color(0xFFE1C699),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: nameValid ? Colors.green : const Color(0xFFE1C699),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                        errorText: nameError.isNotEmpty ? nameError : null,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFE1C699),
                        fontFamily: 'Serif',
                      ),
                      onChanged: (text) {
                        setState(() {
                          nameValid = text.isNotEmpty;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Champ pour "Discounted Price"
                    TextField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: 'Discounted Price',
                        labelStyle: const TextStyle(
                          color: Color(0xFFE1C699),
                        ),
                        prefixIcon: const Icon(
                          Icons.attach_money,
                          color: Color(0xFFE1C699),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: priceValid ? Colors.green : const Color(0xFFE1C699),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: priceValid ? Colors.green : const Color(0xFFE1C699),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                        errorText: priceError.isNotEmpty ? priceError : null,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFE1C699),
                        fontFamily: 'Serif',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        setState(() {
                          priceValid = double.tryParse(text) != null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Champ pour "Discount Percentage"
                    TextField(
                      controller: discountController,
                      decoration: InputDecoration(
                        labelText: 'Discount Percentage',
                        labelStyle: const TextStyle(
                          color: Color(0xFFE1C699),
                        ),
                        prefixIcon: const Icon(
                          Icons.percent,
                          color: Color(0xFFE1C699),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: discountValid ? Colors.green : const Color(0xFFE1C699),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: discountValid ? Colors.green : const Color(0xFFE1C699),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                        errorText: discountError.isNotEmpty ? discountError : null,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFE1C699),
                        fontFamily: 'Serif',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        setState(() {
                          discountValid = double.tryParse(text) != null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Section pour importer l'image
                    _imageFile == null
                        ? Text(
                      'No image selected',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFFE1C699),
                        fontFamily: 'Serif',
                      ),
                    )
                        : Image.file(_imageFile!, height: 100, width: 100), // Afficher l'image sélectionnée
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _pickImage, // Appel de la fonction pour choisir une image
                      child: Text('Pick an Image'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFFE1C699),
                        backgroundColor: const Color(0xFF1E1E1E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Bouton pour ajouter l'offre
                    ElevatedButton.icon(
                      onPressed: () {
                        String name = nameController.text.trim();
                        String price = priceController.text.trim();
                        String discount = discountController.text.trim();

                        setState(() {
                          nameError = '';
                          priceError = '';
                          discountError = '';
                        });

                        bool isValid = true;

                        if (name.isEmpty) {
                          setState(() {
                            nameError = 'Offer name cannot be empty';
                          });
                          isValid = false;
                        }

                        // Contrôle de saisie sur "Discounted Price" et "Discount Percentage"
                        if (price.isEmpty || double.tryParse(price) == null) {
                          setState(() {
                            priceError = 'Please enter a valid price';
                          });
                          isValid = false;
                        }

                        if (discount.isEmpty || double.tryParse(discount) == null) {
                          setState(() {
                            discountError = 'Please enter a valid discount percentage';
                          });
                          isValid = false;
                        }

                        if (_imageFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please select an image')),
                          );
                          isValid = false;
                        }

                        if (isValid) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Offer Added: $name')),
                          );
                          Navigator.of(context).pop(); // Fermer la boîte de dialogue
                        }
                      },
                      icon: const Icon(Icons.save, color: Color(0xFFE1C699)),
                      label: const Text(
                        'Add Offer',
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop Management"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Logic for cart
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            Container(
              margin: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/gems3.png', // Replace with your image
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "NEW OFFER",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "20% OFF",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            _showOfferDialog(context); // Passer le BuildContext comme argument
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.7),
                          ),
                          child: Text("ADD NEW OFFER"),
                        )


                      ],
                    ),
                  ),
                ],
              ),
            ),



            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row( // Row pour aligner "Items" et "(89)" côte à côte
                    children: [
                      Text(
                        "Categorys",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 4), // Optionnel : petit espacement entre "Items" et "(89)"
                      Text(
                        "(9)",
                      ),
                    ],
                  ),

                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryItem("Icon", "assets/avataricon1.webp",
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(),
                    ),),),
                  SizedBox(width: 16),
                  _buildCategoryItem("Weapon", "assets/weap3.png",
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(),
                      ),
                    ),),
                  SizedBox(width: 16),
                  _buildCategoryItem("Helmet", "assets/head1.webp",
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(),
                      ),),),
                  SizedBox(width: 16),
                  _buildCategoryItem("Body", "assets/body1.webp",
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(),
                      ),),),
                  SizedBox(width: 16),
                  _buildCategoryItem("Legs", "assets/leg1.webp",
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(),
                      ),),),
                  SizedBox(width: 16),
                  _buildCategoryItem("Artifact", "assets/artifact1.webp",
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(),
                      ),),),
                  SizedBox(width: 16),
                  _buildCategoryItem("Ring", "assets/ring1.png",
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(),
                      ),),),
                  SizedBox(width: 16),
                  _buildCategoryItem("Gold", "assets/coin_ic.png",
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(),
                      ),),),
                  SizedBox(width: 16),
                  _buildCategoryItem("Gems", "assets/gem_ic.png",
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(),
                      ),),),
                ],
              ),
            ),

            // Curated For You Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row( // Row pour aligner "Items" et "(89)" côte à côte
                    children: [
                      Text(
                        "Items",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 4), // Optionnel : petit espacement entre "Items" et "(89)"
                      Text(
                        "(89)",
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Logic for See All
                    },
                    child: Text("See All"),
                  ),
                ],
              ),
            ),


            // ListView for products (scrollable horizontally with smaller card size)
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(
                    products[index]['title']!,
                    products[index]['image']!,
                    products[index]['oldPrice']!,
                    products[index]['newPrice']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == _currentIndex) return;

          setState(() {
            _currentIndex = index;
          });

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(user: widget.user),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ShopManagementPage(user: widget.user),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserManagementPage(user: widget.user),
              ),
            );
          } else if (index == 3) {
            _navigateToSettings();
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Players',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // Appelle la fonction lors d'un clic
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(imagePath),
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildProductCard(
      String title, String imagePath, String oldPrice, String newPrice) {
    return GestureDetector(
      onTap: () {
        // Navigation vers ItemDetailPage avec les données du produit
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailpage(
              title: title,        // Titre du produit
              imagePath: imagePath, // Image du produit
              oldPrice: oldPrice,   // Ancien prix
              newPrice: newPrice,   // Nouveau prix
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        width: 160,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1, // Limite le texte à une ligne
                  overflow: TextOverflow.ellipsis, // Ajoute "..." si le texte dépasse
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  oldPrice,
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.red,
                    fontSize: 12, // Réduit la taille pour économiser de l'espace
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  newPrice,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
