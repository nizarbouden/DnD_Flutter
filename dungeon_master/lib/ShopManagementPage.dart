

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
  int totalCoins = 0;
  int totalGems = 0;
  List<Map<String, dynamic>> packs = [];
  List<Map<String, dynamic>> gemCoins = [];
  List<Map<String, dynamic>> Gems = [];
  List<Map<String, dynamic>> Coins = [];
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
    fetchCoinGemsShop();
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
                            _showAddNewPackDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 320,
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
                         Expanded( // Ensures the text takes up space on the left
                          child: Text(
                            "Shop - Coins (Total: $totalCoins)",
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
                            _showAddNewCoinsDialog( context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 328,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Coins.length,
                  itemBuilder: (context, index) {
                    return _buildCoinsGemsCard(
                      "Coins #$index",
                      Coins[index]['images']!,
                      Coins[index]['type'].toString(),
                      Coins[index]['amount'].toString(),
                      Coins[index]['price'].toString(),
                      Coins[index],
                    );
                  },
                ),
              ),
              /*Padding(
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
                            "Shop - Gems (Total: $totalGems)",
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
              ),*/
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




  Widget _buildCoinsGemsCard(
      String title, String imagePath, String type, String amount, String price, Map<String, dynamic> coin) {
    return GestureDetector(
      onTap: () {
        // Show a dialog with the pack details instead of navigating
        _showCoinGemDetailsDialog(context, coin);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        width: 160,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image for the card
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  'assets/bg_friends.webp', // Background image
                  fit: BoxFit.cover,
                ),
              ),
              // Card content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Smaller image of the coin or gem
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Rounded edges for the image
                      child: Image.asset(
                        'assets/$imagePath.webp', // Dynamically load image based on imagePath
                        fit: BoxFit.cover,
                        height: 80, // Reduced image size
                        width: 80,  // Reduced image size
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
                        color: Colors.black, // Changed text color to black
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Amount of coin or gem
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Amount: $amount",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black, // Changed text color to black
                      ),
                    ),
                  ),
                  // Price with Gems icon
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        // Icon for gems
                        const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.purple, // Gem icon color
                          size: 16,
                        ),
                        const SizedBox(width: 5), // Space between icon and text
                        Text(
                          "Price: $price",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black, // Changed text color to black
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "Gems", // Always show "Gems" next to the price
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Row for edit and delete icons
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Edit Icon
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue, // Color for the edit icon
                          ),
                          onPressed: () {
                            _showEditCoinsGemsDialog( context, coin);
                          },
                        ),
                        // Delete Icon
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red, // Color for the delete icon
                          ),
                          onPressed: () async {
                            // Show a confirmation dialog before deleting the coin/gem
                            bool confirmed = await _confirmDelete(context);

                            if (confirmed) {
                              try {
                                // Call the API to delete the coin/gem
                                _shopService.deleteCoinsGems(coin['_id']);

                                // Update the local list of coins/gems
                                setState(() {
                                  Coins.removeWhere((item) => item['_id'] == coin['_id']);
                                  Gems.removeWhere((item) => item['_id'] == coin['_id']);
                                  gemCoins.removeWhere((item) => item['_id'] == coin['_id']); // Remove the deleted coin/gem
                                  totalCoins--;
                                });

                                // Optionally show a success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${coin['title']} has been deleted successfully.'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (error) {
                                // Handle any errors that may occur during the deletion process
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to delete coin/gem: $error'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
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
                  const SizedBox(height: 3),
                  // Row for edit and delete icons
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Edit Icon
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue, // Color for the edit icon
                          ),
                          onPressed: () {
                            _showEditPackDialog(context, pack);
                          },
                        ),
                        // Delete Icon
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red, // Color for the delete icon
                          ),
                          onPressed: () async {
                            // Show a confirmation dialog before deleting the pack
                            bool confirmed = await _confirmDelete(context);

                            if (confirmed) {
                              try {
                                // Call the API to delete the pack
                                _shopService.deletePack(pack['_id']);

                                // Update the local list of packs
                                setState(() {
                                  packs.removeWhere((item) => item['_id'] == pack['_id']); // Remove the deleted pack
                                  totalPacks--;
                                });

                                // Optionally show a success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${pack['title']} has been deleted successfully.'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (error) {
                                // Handle any errors that may occur during the deletion process
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to delete pack: $error'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
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

  void _showEditCoinsGemsDialog(BuildContext context, Map<String, dynamic> pack) {
    final TextEditingController priceController = TextEditingController(text: pack['price'].toString());
    final TextEditingController quantityController = TextEditingController(text: pack['amount'].toString());
    final TextEditingController imageController = TextEditingController(text: pack['images']);

    int selectedPackType = pack['type'] ?? 0;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title of the dialog
                  const Text(
                    "Edit Coins/Gems Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Pack Image Dropdown
                  _buildCoinsGemsImageDropdownField(
                    selectedValue: imageController.text,
                    onChanged: (newValue) {
                      imageController.text = newValue ?? '';
                    },
                  ),
                  const SizedBox(height: 10),

                  // Price Input
                  _buildInputField(
                    controller: priceController,
                    labelText: 'Price',
                    hintText: 'Enter Price',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),

                  // Quantity Input
                  _buildInputField(
                    controller: quantityController,
                    labelText: 'Amount',
                    hintText: 'Enter Amount',
                    icon: Icons.add_shopping_cart,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  // Centered and Enlarged Save Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Get the updated values from the controllers
                        pack['images'] = imageController.text;
                        pack['price'] = int.tryParse(priceController.text) ?? 0;
                        pack['amount'] = int.tryParse(quantityController.text) ?? 0;
                        pack['type'] = selectedPackType;

                        // Use setState to update the UI
                        setState(() {
                          // Assuming you have a method to update the pack in your local data
                          // and that `packs` is a list or map where the pack is stored
                          int packIndex = Coins.indexWhere((element) => element['_id'] == pack['_id']);
                          if (packIndex != -1) {
                            if(pack['type'] == 1)
                              {
                                Coins[packIndex] = pack;
                              }
                            else
                              {
                                Gems[packIndex] = pack;
                              }
                            // Replace the old pack with the updated one
                          }
                          _shopService.updateCoinsGemsShop(pack['_id'],pack);
                        });

                        // Call API to update the pack in the backend (if needed)
                        //_updatePack(pack);

                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Update Coins',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A393D), // Dark red fantasy color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
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

  void _showEditPackDialog(BuildContext context, Map<String, dynamic> pack) {
    final TextEditingController priceController = TextEditingController(text: pack['price'].toString());
    final TextEditingController quantityController = TextEditingController(text: pack['quantity'].toString());
    final TextEditingController imageController = TextEditingController(text: pack['images']);

    bool isAvailable = pack['available'] ?? true;
    int selectedPackType = pack['packType'] ?? 0;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title of the dialog
                  const Text(
                    "Edit Pack Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Pack Image Dropdown
                  _buildImageDropdownField(
                    selectedValue: imageController.text,
                    onChanged: (newValue) {
                      imageController.text = newValue ?? '';
                    },
                  ),
                  const SizedBox(height: 10),

                  // Price Input
                  _buildInputField(
                    controller: priceController,
                    labelText: 'Price',
                    hintText: 'Enter Price',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),

                  // Quantity Input
                  _buildInputField(
                    controller: quantityController,
                    labelText: 'Quantity',
                    hintText: 'Enter Quantity',
                    icon: Icons.add_shopping_cart,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),

                  // Pack Type Dropdown
                  _buildDropdownField(
                    selectedPackType: selectedPackType,
                    onChanged: (newValue) {
                      selectedPackType = newValue!;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Centered and Enlarged Save Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Get the updated values from the controllers
                        pack['images'] = imageController.text;
                        pack['price'] = int.tryParse(priceController.text) ?? 0;
                        pack['quantity'] = int.tryParse(quantityController.text) ?? 0;
                        pack['packType'] = selectedPackType;
                        pack['available'] = isAvailable;

                        // Use setState to update the UI
                        setState(() {
                          // Assuming you have a method to update the pack in your local data
                          // and that `packs` is a list or map where the pack is stored
                          int packIndex = packs.indexWhere((element) => element['_id'] == pack['_id']);
                          if (packIndex != -1) {
                            packs[packIndex] = pack; // Replace the old pack with the updated one
                          }
                        });

                        // Call API to update the pack in the backend (if needed)
                        _updatePack(pack);

                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Update Pack',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A393D), // Dark red fantasy color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
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
  Widget _buildCoinsGemsImageDropdownField({
    required String selectedValue,
    required ValueChanged<String?> onChanged, // Update to use ValueChanged<String?> for type safety
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0), // Margin between fields
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: onChanged, // Correctly handling the value change
        decoration: InputDecoration(
          labelText: 'Coins/Gems Image Name',
          labelStyle: const TextStyle(
            color: Colors.black, // Darker label color for better readability
            fontWeight: FontWeight.bold, // Bold for clarity
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9), // Lighter background for better contrast
          prefixIcon: const Icon(
            Icons.image,
            color: Colors.black, // Black icon color for clarity
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners for modern design
            borderSide: const BorderSide(
              color: Colors.grey, // Light gray border color for subtlety
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.grey, // Light gray when not focused
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.blue, // Highlighted blue when focused
              width: 2,
            ),
          ),
        ),
        items: ['gold1', 'gold2', 'gold3', 'gold4', 'gold5', 'gold6', 'gems1', 'gems2', 'gems3', 'gem4', 'gem5', 'gem6']
            .map((imageName) {
          return DropdownMenuItem<String>(
            value: imageName,
            child: Text(
              imageName,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }
  Widget _buildImageDropdownField({
    required String selectedValue,
    required ValueChanged<String?> onChanged, // Update to use ValueChanged<String?> for type safety
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0), // Margin between fields
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: onChanged, // Correctly handling the value change
        decoration: InputDecoration(
          labelText: 'Pack Image Name',
          labelStyle: const TextStyle(
            color: Colors.black, // Darker label color for better readability
            fontWeight: FontWeight.bold, // Bold for clarity
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9), // Lighter background for better contrast
          prefixIcon: const Icon(
            Icons.image,
            color: Colors.black, // Black icon color for clarity
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners for modern design
            borderSide: const BorderSide(
              color: Colors.grey, // Light gray border color for subtlety
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.grey, // Light gray when not focused
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.blue, // Highlighted blue when focused
              width: 2,
            ),
          ),
        ),
        items: ['pack1', 'pack2', 'pack3', 'pack4', 'pack5']
            .map((imageName) {
          return DropdownMenuItem<String>(
            value: imageName,
            child: Text(
              imageName,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0), // Margin between fields
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: const TextStyle(
            color: Colors.black, // Black label text for better visibility
            fontWeight: FontWeight.bold, // Bold label for better readability
          ),
          hintStyle: const TextStyle(
            color: Colors.grey, // Lighter hint text color for a subtle effect
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9), // Light background for input fields
          prefixIcon: Icon(icon, color: Colors.black), // Black icon color for clarity
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners for a modern look
            borderSide: const BorderSide(
              color: Colors.grey, // Light border color for a soft touch
              width: 2, // Subtle border width
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.grey, // Light border color when not focused
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.blue, // Blue color when the input field is focused
              width: 2,
            ),
          ),
        ),
        style: const TextStyle(color: Colors.black, fontSize: 16), // Black text for better visibility
      ),
    );
  }


  Widget _buildDropdownField({
    required int selectedPackType,
    required ValueChanged<int?> onChanged, // Correctly updated to accept the ValueChanged<int?>
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0), // Margin between fields
      child: DropdownButtonFormField<int>(
        value: selectedPackType,
        onChanged: onChanged, // This now properly accepts the function
        decoration: InputDecoration(
          labelText: 'Pack Type',
          labelStyle: const TextStyle(
            color: Colors.black, // Darker label color for better readability
            fontWeight: FontWeight.bold, // Bold for clarity
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9), // Lighter background for better contrast
          prefixIcon: const Icon(
            Icons.category,
            color: Colors.black, // Black icon color for clarity
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners for modern design
            borderSide: const BorderSide(
              color: Colors.grey, // Light gray border color for subtlety
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.grey, // Light gray when not focused
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.blue, // Highlighted blue when focused
              width: 2,
            ),
          ),
        ),
        items: const [
          DropdownMenuItem(
            value: 0,
            child: Text(
              'Gold Pack',
              style: TextStyle(color: Colors.black),
            ),
          ),
          DropdownMenuItem(
            value: 1,
            child: Text(
              'Gem Pack',
              style: TextStyle(color: Colors.black),
            ),
          ),
          DropdownMenuItem(
            value: 2,
            child: Text(
              'Mixed Pack',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }





  void _updatePack(Map<String, dynamic> updatedPack) {
    // API call or state update logic to update the pack
    _shopService.updatePack(updatedPack['_id'], updatedPack);
    print("Updated pack: $updatedPack");
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF333333), // Dark background to match DnD theme
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange, size: 28), // Warning icon
            SizedBox(width: 8),
            Text(
              'Delete Pack',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text color for better readability
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this pack? This action cannot be undone.',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white70, // Slightly lighter text for readability
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancellation
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.redAccent, backgroundColor: Colors.black, // Dark background for button
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text for button
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirmation
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.greenAccent, backgroundColor: Colors.black, // Dark background for button
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text for button
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 20, // Add shadow for a more mystical feel
      ),
    );
    return result ?? false;
  }
  void _showAddNewPackDialog(BuildContext context) {
    final TextEditingController imageController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    int selectedPackType = 0;

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
                image: AssetImage('assets/bg_friends.webp'), // Background image for the dialog
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
                  const Text(
                    "Add New Pack",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Price Input
                  _buildPriceField(
                    controller: priceController,
                    hintText: 'Enter Price',
                    icon: Icons.attach_money,
                  ),
                  const SizedBox(height: 10),

                  // Quantity Input
                  _buildQuantityField(
                    controller: quantityController,
                    hintText: 'Enter Quantity',
                    icon: Icons.add_shopping_cart,
                  ),
                  const SizedBox(height: 10),

                  // Pack Type Dropdown
                  _buildPackTypeDropdown(
                    selectedPackType,
                        (newValue) {
                      selectedPackType = newValue!;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Add New Pack Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Get the new pack data from controllers
                      if(imageController.text.isEmpty)
                        {
                          imageController.text = "pack1";
                        }
                      final newPack = {
                        'images': imageController.text,
                        'price': int.tryParse(priceController.text) ?? 0,
                        'quantity': int.tryParse(quantityController.text) ?? 0,
                        'packType': selectedPackType,
                        'priceType': 0,  // Ensure this is sent
                        'available': true,
                      };

                      try {
                        // Wait for the response from the backend and get the created pack
                        final createdPack = await _shopService.addPack(newPack);
                        print(createdPack);
                        // After receiving the full pack with its ID, update the UI
                        setState(() {
                          packs.add(createdPack);  // Add the new pack to the list
                          totalPacks++;  // Increment the total count of packs
                        });

                        Navigator.of(context).pop(); // Close the dialog
                      } catch (error) {
                        // Handle the error if pack creation fails
                        print('Error adding pack: $error');
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Add Pack',
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

  void _showAddNewCoinsDialog(BuildContext context) {
    final TextEditingController imageController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    int selectedPackType = 0;

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
                image: AssetImage('assets/bg_friends.webp'), // Background image for the dialog
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
                  const Text(
                    "Add New Coins/Gems",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Pack Image Dropdown

                  const SizedBox(height: 10),

                  // Price Input
                  _buildPriceField(
                    controller: priceController,
                    hintText: 'Enter Price',
                    icon: Icons.attach_money,
                  ),
                  const SizedBox(height: 10),

                  // Quantity Input
                  _buildQuantityField(
                    controller: quantityController,
                    hintText: 'Enter Amount',
                    icon: Icons.add_shopping_cart,
                  ),
                  const SizedBox(height: 10),
                  // Add New Pack Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Get the new pack data from controllers
                      if(imageController.text.isEmpty)
                      {
                        imageController.text = "gold1";
                      }
                      final newPack = {
                        'images': imageController.text,
                        'price': int.tryParse(priceController.text) ?? 0,
                        'amount': int.tryParse(quantityController.text) ?? 0,
                        'type': 0,  // Ensure this is sent
                      };

                      try {
                        // Wait for the response from the backend and get the created pack
                        final createdPack = await _shopService.addCoinShop(newPack);
                        print(createdPack);
                        // After receiving the full pack with its ID, update the UI
                        setState(() {
                          gemCoins.add(createdPack);
                          Coins.add(createdPack);// Add the new pack to the list
                          Gems.add(createdPack);
                          totalCoins++;
                          totalGems++;
                        });

                        Navigator.of(context).pop(); // Close the dialog
                      } catch (error) {
                        // Handle the error if pack creation fails
                        print('Error adding pack: $error');
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Add Gems/Coins',
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

// Image Picker Dropdown
  Widget _buildImagePickerDropdown({
    required String selectedValue,
    required ValueChanged<String?> onChanged, // Correctly updated to handle string values
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0), // Margin between fields
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: onChanged, // Properly handling the value change
        decoration: InputDecoration(
          labelText: 'Pack Image Name',
          labelStyle: const TextStyle(
            color: Colors.black, // Darker label color for better readability
            fontWeight: FontWeight.bold, // Bold for clarity
          ),
          filled: true,
          fillColor: Colors.white, // Set the dropdown background to white
          prefixIcon: const Icon(
            Icons.image,
            color: Colors.black, // Black icon color for clarity
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners for modern design
            borderSide: const BorderSide(
              color: Colors.grey, // Light gray border color for subtlety
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.grey, // Light gray when not focused
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.blue, // Highlighted blue when focused
              width: 2,
            ),
          ),
        ),
        items: ['pack1', 'pack2', 'pack3', 'pack4', 'pack5']
            .map((imageName) {
          return DropdownMenuItem<String>(
            value: imageName,
            child: Text(
              imageName,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }


// Price Input Field
  Widget _buildPriceField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0), // Margin between fields
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Price',
          hintText: hintText,
          labelStyle: const TextStyle(
            color: Colors.black, // Black label for better visibility
            fontWeight: FontWeight.bold, // Bold label for better readability
          ),
          hintStyle: const TextStyle(
            color: Colors.black54, // Lighter hint text color
          ),
          filled: true,
          fillColor: Colors.white, // Set the background to white
          prefixIcon: Icon(
            icon,
            color: Colors.black, // Black icon color
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners for a clean look
            borderSide: const BorderSide(
              color: Colors.grey, // Light gray border color for subtlety
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.grey, // Light gray border color when not focused
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.blue, // Highlighted blue when focused
              width: 2,
            ),
          ),
        ),
        style: const TextStyle(
          color: Colors.black, // Black text color for readability
          fontSize: 16, // Size of the text
        ),
      ),
    );
  }


// Quantity Input Field
  Widget _buildQuantityField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0), // Margin between fields
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Quantity',
          hintText: hintText,
          labelStyle: const TextStyle(
            color: Colors.black, // Black label for better visibility
            fontWeight: FontWeight.bold, // Bold label for clarity
          ),
          hintStyle: const TextStyle(
            color: Colors.black54, // Lighter hint text color
          ),
          filled: true,
          fillColor: Colors.white, // Set the background to white
          prefixIcon: Icon(
            icon,
            color: Colors.black, // Black icon color
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners for modern design
            borderSide: const BorderSide(
              color: Colors.grey, // Light gray border color for subtlety
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.grey, // Light gray border color when not focused
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.blue, // Highlighted blue when focused
              width: 2,
            ),
          ),
        ),
        style: const TextStyle(
          color: Colors.black, // Black text color for readability
          fontSize: 16, // Font size
        ),
      ),
    );
  }


// Pack Type Dropdown
  Widget _buildPackTypeDropdown(
      int selectedPackType,
      ValueChanged<int?> onChanged
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0), // Margin between fields
      child: DropdownButtonFormField<int>(
        value: selectedPackType,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: 'Pack Type',
          labelStyle: const TextStyle(
            color: Colors.black, // Black label text for better visibility
            fontWeight: FontWeight.bold, // Bold label for clarity
          ),
          filled: true,
          fillColor: Colors.white, // Set background to white for contrast
          prefixIcon: const Icon(
            Icons.category,
            color: Colors.black, // Black icon color for clarity
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners for modern look
            borderSide: const BorderSide(
              color: Colors.grey, // Light gray border color for subtlety
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.grey, // Light gray border when not focused
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.blue, // Highlighted blue border when focused
              width: 2,
            ),
          ),
        ),
        items: const [
          DropdownMenuItem(
            value: 0,
            child: Text(
              'Gold Pack',
              style: TextStyle(color: Colors.black),
            ),
          ),
          DropdownMenuItem(
            value: 1,
            child: Text(
              'Gem Pack',
              style: TextStyle(color: Colors.black),
            ),
          ),
          DropdownMenuItem(
            value: 2,
            child: Text(
              'Mixed Pack',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _showCoinGemDetailsDialog(BuildContext context, Map<String, dynamic> cg) async {
    // Define rewards with odds based on packType
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
                      'assets/${cg['images']}.webp', // Pack image based on the pack data
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Pack Title
                  Text(
                    "CG: ${cg['type'] ?? 'N/A'}", // Null-aware operator added for safety
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
                    cg['type'] == 0 ? Icons.monetization_on : Icons.account_balance_wallet,
                    'Price',
                    "${cg['price']} ${cg['type'] == 1 ? 'Coins' : 'Gems'}",
                  ),
                  _buildPackDetailWithIcon(
                    Icons.shopping_cart,
                    'Amount',
                    cg['amount']?.toString() ?? 'N/A', // Safe check for null quantity
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Colors.black, // Divider color changed to black
                    thickness: 2,
                    indent: 30,
                    endIndent: 30,
                  ),
                  const SizedBox(height: 20),

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

  Future<void> fetchCoinGemsShop() async {
    try {
      final coinss = await _shopService.fetchCoinsGemsShop();

      setState(() {
        totalCoins = 0; // Reset to 0 before calculating
        totalGems = 0;  // Reset to 0 before calculating

        // Loop through the fetched data and update coins or gems based on 'type'
        for (var coin in coinss) {
          if (coin['type'] == 0) {
            Coins.add(coin);
            totalCoins ++;  // Increase totalCoins if type is 0
          } else if (coin['type'] == 1) {
            Gems.add(coin);
            totalGems ++;  // Increase totalGems if type is 1
          }
        }

        gemCoins = coinss; // Store the coin/gem list for later use
        print(coinss);
      });
    } catch (e) {
      print('Error fetching players: $e');
    }
  }


}
