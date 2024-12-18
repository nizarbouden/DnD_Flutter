

import 'package:dungeon_master/service/auth_service.dart';
import 'package:dungeon_master/service/shop_service.dart';
import 'package:flutter/material.dart';
import 'Homepage.dart';
import 'UserManagementPage.dart';
import 'ItemDetailPage.dart';

class ShopManagementPage extends StatefulWidget {
  final ValueNotifier<Map<String, dynamic>> user;

  const ShopManagementPage({super.key, required this.user});

  @override
  _ShopManagementPageState createState() => _ShopManagementPageState();
}

class _ShopManagementPageState extends State<ShopManagementPage> {
  int _currentIndex = 1; // Set the default index to 1 for ShopManagementPage
  final AuthService _userService = AuthService();
  final ShopService _shopService = ShopService();
  int totalPacks = 0;
  List<Map<String, dynamic>> packs = [];
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
  @override
  void initState() {
    super.initState();
    fetchBasicShop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF502722),
        title: const Text(
          "Shop Management",
          style: TextStyle(
            color: Color(0xFFD4CFC4),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_dash.webp'), // Your background image
            fit: BoxFit.cover, // Makes the image cover the entire screen
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categories Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/bg_friends.webp'), // Your background image
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding inside the container
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the text
                      children: [
                        // Text for "Shop - Gems"
                         Expanded( // Ensures the text takes up space on the left
                          child: Text(
                            "Packs (Total: $totalPacks)", // This will dynamically show the totalPacks variable
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black, // Black text color
                            ),
                            textAlign: TextAlign.center, // Ensures the text stays centered
                          ),
                        ),
                        // Add New Coins Button
                        IconButton(
                          icon: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF8B0000), // Red background
                              shape: BoxShape.circle, // Make it circular
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: const Icon(
                              Icons.add, // The add icon
                              color: Colors.white, // White icon color
                              size: 20,
                            ),
                          ),
                          onPressed: () {
                            // Logic to add new coins
                            print("Add new coins button pressed");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: packs.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(
                      "Pack #$index",
                      packs[index]['images']!,
                      packs[index]['price'].toString(),
                      packs[index]['quantity'].toString(),
                      packs[index],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/bg_friends.webp'), // Your background image
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding inside the container
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the text
                      children: [
                        // Text for "Shop - Gems"
                        const Expanded( // Ensures the text takes up space on the left
                          child: Text(
                            "Shop - Coins",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black, // Black text color
                            ),
                            textAlign: TextAlign.center, // Ensures the text stays centered
                          ),
                        ),
                        // Add New Coins Button
                        IconButton(
                          icon: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF8B0000), // Red background
                              shape: BoxShape.circle, // Make it circular
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: const Icon(
                              Icons.add, // The add icon
                              color: Colors.white, // White icon color
                              size: 20,
                            ),
                          ),
                          onPressed: () {
                            // Logic to add new coins
                            print("Add new coins button pressed");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              /*SizedBox(
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
              ),*/
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/bg_friends.webp'), // Your background image
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding inside the container
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the text
                      children: [
                        // Text for "Shop - Gems"
                        const Expanded( // Ensures the text takes up space on the left
                          child: Text(
                            "Shop - Gems",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black, // Black text color
                            ),
                            textAlign: TextAlign.center, // Ensures the text stays centered
                          ),
                        ),
                        // Add New Coins Button
                        IconButton(
                          icon: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF8B0000), // Red background
                              shape: BoxShape.circle, // Make it circular
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: const Icon(
                              Icons.add, // The add icon
                              color: Colors.white, // White icon color
                              size: 20,
                            ),
                          ),
                          onPressed: () {
                            // Logic to add new coins
                            print("Add new coins button pressed");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              /*SizedBox(
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
              ),*/
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF7A393D),
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFD4CFC4),
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'VecnaBold',
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'VecnaBold',
          fontSize: 15,
        ),
        type: BottomNavigationBarType.fixed,
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShopManagementPage(user: widget.user),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserManagementPage(user: widget.user),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/homeicnav.png'),
              size: 20,
              color: Color(0xFFD4CFC4),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/shopnav.png'),
              size: 30,
            ),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/playersnav.png'),
              size: 30,
            ),
            label: 'Players',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/profilenav.png'),
              size: 25,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }





  Widget _buildProductCard(
      String title, String imagePath, String price, String quantity, Map<String, dynamic> pack) {
    return GestureDetector(
      onTap: () {
        // Show a dialog with the pack details instead of navigating
        _showPackDetailsDialog(context, pack);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 160,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image with rounded edges
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  'assets/bg_friends.webp', // Background image
                  fit: BoxFit.cover,
                ),
              ),
              // Content of the card
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Smaller image with rounded corners
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Rounded edges for the image
                      child: Image.asset(
                        "assets/$imagePath.webp", // Dynamically load image based on imagePath
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1, // Limit text to one line
                      overflow: TextOverflow.ellipsis, // Add "..." if the text overflows
                    ),
                  ),
                  // Price with its label and icon (coins or gems)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        pack['priceType'] == 0
                            ? const Icon(
                          Icons.monetization_on,
                          color: Colors.yellow, // Coin icon color
                          size: 16,
                        )
                            : const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.purple, // Gem icon color
                          size: 16,
                        ),
                        const SizedBox(width: 4), // Space between icon and text
                        const Text(
                          "Price: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          price,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16, // Adjusted price font size
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pack['priceType'] == 0 ? "Coins" : "Gems", // Show label based on priceType
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Quantity with its label
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.green, // Cart icon color
                          size: 20,
                        ),
                        const SizedBox(width: 4), // Space between icon and text
                        const Text(
                          "Quantity: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          quantity,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPackDetailsDialog(BuildContext context, Map<String, dynamic> pack) async {
    // Define rewards with odds based on packType
    List<Map<String, String>> rewardsWithOdds = [];

    switch (pack['packType']) {
      case 0:
        rewardsWithOdds = [
          {'image': 'gold1', 'value': '20', 'odds': '10%'},
          {'image': 'gold2', 'value': '40', 'odds': '20%'},
          {'image': 'gold3', 'value': '60', 'odds': '30%'},
          {'image': 'gold4', 'value': '80', 'odds': '20%'},
          {'image': 'gold5', 'value': '100', 'odds': '10%'},
          {'image': 'gold6', 'value': '150', 'odds': '10%'},
        ];
        break;
      case 1:
        rewardsWithOdds = [
          {'image': 'gems1', 'value': '5', 'odds': '10%'},
          {'image': 'gems2', 'value': '10', 'odds': '20%'},
          {'image': 'gems3', 'value': '15', 'odds': '30%'},
          {'image': 'gem4', 'value': '20', 'odds': '20%'},
          {'image': 'gem5', 'value': '30', 'odds': '10%'},
          {'image': 'gem6', 'value': '50', 'odds': '10%'},
        ];
        break;
      case 2:
        rewardsWithOdds = [
          {'image': 'gold2', 'value': '30', 'odds': '15%'},
          {'image': 'gold3', 'value': '50', 'odds': '20%'},
          {'image': 'gold4', 'value': '70', 'odds': '25%'},
          {'image': 'gems1', 'value': '5', 'odds': '10%'},
          {'image': 'gems2', 'value': '10', 'odds': '20%'},
          {'image': 'gems3', 'value': '15', 'odds': '10%'},
        ];
        break;
      default:
        rewardsWithOdds = [];
        break;
    }

    // Debugging to see the rewards data
    print('Rewards with Odds: $rewardsWithOdds');

    // Show dialog with pack details
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners for the dialog
          ),
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/bg_friends.webp'), // Fantasy background image
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pack Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/${pack['images']}.webp', // Pack image based on the pack data
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Pack Title
                  Text(
                    "Pack: ${pack['packType'] ?? 'N/A'}", // Null-aware operator added for safety
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    color: Colors.black, // Divider color changed to black
                    thickness: 2,
                    indent: 30,
                    endIndent: 30,
                  ),

                  // Price with appropriate icon based on priceType
                  _buildPackDetailWithIcon(
                    pack['priceType'] == 0 ? Icons.monetization_on : Icons.account_balance_wallet,
                    'Price',
                    "${pack['price']} ${pack['priceType'] == 0 ? 'Coins' : 'Gems'}",
                  ),
                  _buildPackDetailWithIcon(
                    Icons.shopping_cart,
                    'Quantity',
                    pack['quantity']?.toString() ?? 'N/A', // Safe check for null quantity
                  ),
                  _buildPackDetailWithIcon(
                    Icons.category,
                    'Pack Type',
                    pack['packType']?.toString() ?? 'N/A', // Safe check for null packType
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Colors.black, // Divider color changed to black
                    thickness: 2,
                    indent: 30,
                    endIndent: 30,
                  ),
                  const SizedBox(height: 20),

                  // Add a section to show rewards with odds
                  const Text(
                    'Rewards with Odds',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Check if there are rewards to display
                  if (rewardsWithOdds.isEmpty)
                    const Text(
                      'No rewards available for this pack.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    )
                  else
                    ...rewardsWithOdds.map((reward) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/${reward['image']}.webp', // Load the reward image
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${reward['value']} (${reward['odds']})", // Display value and odds
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                  // Close Button
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: const Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7A393D), // Dark red fantasy color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPackDetailWithIcon(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchBasicShop() async {
    try {
      final packss = await _shopService.fetchPacksShop();

      setState(() {
        totalPacks = packss.length;
        packs = packss;
        print(packs);
      });
    } catch (e) {
      print('Error fetching players: $e');
    }
  }

}
