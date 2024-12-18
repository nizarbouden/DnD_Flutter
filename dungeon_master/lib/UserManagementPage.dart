import 'package:flutter/material.dart';
import 'Homepage.dart';
import 'NotificationsPage.dart';
import 'package:dungeon_master/service/auth_service.dart';
import 'ShopManagementPage.dart';

class UserManagementPage extends StatefulWidget {
  final ValueNotifier<Map<String, dynamic>> user;

  const UserManagementPage({required this.user});

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  int _currentIndex = 2;

  // Liste initiale des utilisateurs (avant tout filtre ou tri)
  ValueNotifier<List<Map<String, dynamic>>> users = ValueNotifier([]);

  TextEditingController _searchController = TextEditingController();
  String selectedFilter = '';
  bool isAscendingName = true;
  bool isAscendingLevel = true;
  final AuthService _userService = AuthService();
  List<Map<String, dynamic>> players = [];

  int _currentPage = 1;
  final int _usersPerPage = 10;

  @override
  void initState() {
    super.initState();
    fetchTotalPlayers();
  }

  List<Map<String, dynamic>> _getPaginatedUsers(
      List<Map<String, dynamic>> userList) {
    int start = (_currentPage - 1) * _usersPerPage;
    int end = start + _usersPerPage;
    return userList.sublist(
        start, end > userList.length ? userList.length : end);
  }

  void sortByName() {
    setState(() {
      isAscendingName = !isAscendingName;
      selectedFilter = 'name';
      users.value.sort((a, b) =>
      isAscendingName
          ? a['name'].compareTo(b['name'])
          : b['name'].compareTo(a['name']));
    });
  }

  Future<void> fetchTotalPlayers() async {
    try {
      final usersx = await _userService.fetchUsers();

      setState(() {
        players = usersx;
        users.value = List.from(players);
      });
    } catch (e) {
      print('Error fetching players: $e');
    }
  }

  void sortByLevel() {
    setState(() {
      isAscendingLevel = !isAscendingLevel;
      selectedFilter = 'level';
      users.value.sort((a, b) =>
      isAscendingLevel
          ? a['level'].compareTo(b['level'])
          : b['level'].compareTo(a['level']));
    });
  }

  void clearFilters() {
    setState(() {
      selectedFilter = '';
      _searchController.clear();
      _currentPage = 1; // Réinitialiser à la première page
      // Restaurer les utilisateurs à leur état initial
      users.value = List.from(players);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image for the Entire Screen
          Positioned.fill(
            child: Image.asset(
              'assets/bg_dash.webp', // Replace with your background image path
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),
          // Foreground Content
          Column(
            children: [
              // AppBar with Search Field
              AppBar(
                backgroundColor: const Color(0xFF502722),
                title: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _currentPage = 1; // Reset to first page on search
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search users...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Color(0xFFD4CFC4),
                      fontSize: 16,
                    ),
                  ),
                  style: const TextStyle(
                    color: Color(0xFFD4CFC4),
                    fontSize: 18,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    color: const Color(0xFFD4CFC4),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NotificationsPage(user: widget.user),
                        ),
                      );
                    },
                  ),
                ],
              ),
              // Filter Chips Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    vertical: 5, horizontal: 16),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 2.0), // Add vertical margin
                    padding: const EdgeInsets.all(6.0), // Padding inside the container
                    width: MediaQuery.of(context).size.width * 0.95, // 95% of the screen width
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5), // Semi-transparent black overlay
                      borderRadius: BorderRadius.circular(12), // Match outer corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add padding inside the container
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly space the chips
                        children: [
                          _buildFilterChip('Name', isAscendingName, sortByName, selectedFilter == 'name'),
                          _buildFilterChip('Level', isAscendingLevel, sortByLevel, selectedFilter == 'level'),
                          _buildFilterChip('Clear Filters', false, clearFilters, selectedFilter == ''),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Pagination Controls at the Top
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 0), // Padding for spacing
                    height: 4, // Divider thickness
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), // Rounded edges
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3E3E3E), // Dark gray
                          Color(0xFF6A4E23), // Copper-like shade
                          Color(0xFF4B4B4B), // Dark gray
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2), // Add shadow below
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/bg_friends.webp'), // Background image
                        fit: BoxFit.cover, // Cover the entire container
                      ),
                    ),
                    child:
                    Container(
                      // Overlay
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2), // Semi-transparent overlay
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFF000000), // Icon color
                            ),
                            onPressed: _currentPage > 1
                                ? () {
                              setState(() {
                                _currentPage--;
                              });
                            }
                                : null,
                          ),
                          Text(
                            'Page $_currentPage of ${(users.value.length / _usersPerPage).ceil()}',
                            style: const TextStyle(
                              fontSize: 18, // Increase font size
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000), // Text color
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF000000), // Icon color
                            ),
                            onPressed: _currentPage <
                                (users.value.length / _usersPerPage).ceil()
                                ? () {
                              setState(() {
                                _currentPage++;
                              });
                            }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Gradient Divider
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 0), // Padding for spacing
                    height: 4, // Divider thickness
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), // Rounded edges
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3E3E3E), // Dark gray
                          Color(0xFF6A4E23), // Copper-like shade
                          Color(0xFF4B4B4B), // Dark gray
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2), // Add shadow below
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // List of User Cards
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: users,
                  builder: (context, userList, _) {
                    var filteredUsers = userList
                        .where((user) =>
                        user['name']
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()))
                        .toList();

                    var paginatedUsers = _getPaginatedUsers(filteredUsers);

                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: paginatedUsers.length,
                      itemBuilder: (context, index) {
                        final user = paginatedUsers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            height: 115, // Adjusted for better fit
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: AssetImage('assets/bg_friends.webp'),
                                // Background image for the card
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black26,
                                  // Dark overlay for better readability
                                  BlendMode.darken,
                                ),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // User Image
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundImage: AssetImage(
                                      'assets/${user['image']}.webp', // Construct the path dynamically
                                    ),
                                    onBackgroundImageError: (_, __) {
                                      print('Error loading avatar image: ${user['image']}');
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                  // User Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Text(
                                          user['name'] ?? 'No Name',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Level: ${user['level'] ?? 'N/A'}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          'Coins: ${user['coins'] ?? 0}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Info Button
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end, // Align icons to the end of the row
                                    children: [
                                      // First Icon: Info Button with Label
                                      Column(
                                        children: [
                                          IconButton(
                                            icon: Image.asset(
                                              'assets/infoicf.png', // Replace with your custom image asset
                                              width: 30,
                                              height: 30,
                                            ),
                                            onPressed: () {
                                              _showUserDetailsDialog(context, user);
                                            },
                                            tooltip: 'View Details',
                                          ),
                                          const Text(
                                            'Info',
                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 8), // Add spacing between icons

                                      // Second Icon: Edit Button with Label
                                      Column(
                                        children: [
                                          IconButton(
                                            icon: Image.asset(
                                              'assets/modic.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                            onPressed: () {
                                              _showEditUserDialog(context, user, (updatedUser, {resetPassword = false}) {
                                                setState(() {
                                                  int index = users.value.indexOf(user);
                                                  if (index != -1) {
                                                    users.value[index] = updatedUser;
                                                    print(updatedUser);
                                                    _userService.updateUser(user['_id'], updatedUser, resetPassword: resetPassword);
                                                  }
                                                });
                                              });
                                            },
                                            tooltip: 'Edit User',
                                          ),
                                          const Text(
                                            'Edit',
                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 8), // Add spacing between icons

                                      // Third Icon: Delete Button with Label
                                      Column(
                                        children: [
                                          IconButton(
                                            icon: Image.asset(
                                              'assets/deleteic.png', // Replace with your custom delete image asset
                                              width: 30, // Adjust size
                                              height: 30,
                                              color: Colors.red.shade200, // Apply a dark red tint
                                              colorBlendMode: BlendMode.srcIn,
                                            ),
                                            onPressed: () async {
                                              // Show confirmation dialog before deleting
                                              bool confirmed = await showDialog<bool>(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  backgroundColor: const Color(0xFF2C2C2C), // Dark background to match the DnD theme
                                                  title: const Text(
                                                    'Confirm Deletion',
                                                    style: TextStyle(
                                                      color: Colors.white, // White title for better visibility
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                        'Are you sure you want to delete this user?',
                                                        style: TextStyle(
                                                          color: Colors.white70, // Slightly lighter text for readability
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 16),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop(false); // User cancels deletion
                                                            },
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                color: Colors.redAccent,
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop(true); // User confirms deletion
                                                            },
                                                            child: const Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                color: Colors.greenAccent,
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(16),
                                                    side: BorderSide(
                                                      color: Colors.grey.shade600,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  elevation: 20, // Adding shadow for a more mystical feel
                                                ),
                                              ) ?? false;

                                              // Process the deletion if confirmed
                                              if (confirmed) {
                                                setState(() {
                                                  users.value.remove(user); // Remove user from the list
                                                  _userService.deleteUser(user['_id']);
                                                });

                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('${user['name']} has been deleted successfully.'),
                                                    duration: const Duration(seconds: 2),
                                                    backgroundColor: Colors.redAccent,
                                                  ),
                                                );
                                              }
                                            },
                                            tooltip: 'Delete User',
                                          ),
                                          const Text(
                                            'Delete',
                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
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
}
Widget _buildFilterChip(String label, bool isAscending, VoidCallback onSelected, bool isSelected) {
  return Container(
    height: 50, // Adjust height as needed
    margin: const EdgeInsets.symmetric(horizontal: 4), // Add spacing between chips
    child: FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF000000), // Off-white D&D theme color
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          if (label != 'Clear Filters') ...[
            const SizedBox(width: 4),
            Icon(
              isAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 16,
              color: Color(0xFF000000), // Same color for consistency
            ),
          ],
        ],
      ),
      onSelected: (value) => onSelected(),
      selected: isSelected,
      selectedColor: const Color(0xFF7A393D), // Deep red selection color
      backgroundColor: Colors.transparent, // Transparent to allow image overlay
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners for filter chip
        side: BorderSide(
          color: isSelected ? const Color(0xFFD4CFC4) : Colors.transparent,
          width: 1, // Optional border for selected chips
        ),
      ),
    ),
  );
}
int getMaxXPForLevel(int level) {
  // Example logic: XP increases by a fixed value as the level increases
  const int baseXP = 1000; // Base XP required for level 2
  const int increment = 200; // Increment for each subsequent level

  return baseXP + (increment * (level - 1)); // Level 1 doesn't require XP
}

bool resetPassword = false; // State for reset password toggle

void _showEditUserDialog(
    BuildContext context,
    Map<String, dynamic> user,
    Function(Map<String, dynamic>, {bool resetPassword}) onSave, // Updated callback with a flag
    ) {
  final nameController = TextEditingController(text: user['name']);
  final emailController = TextEditingController(text: user['email']);
  final coinsController = TextEditingController(text: user['coins'].toString());
  final gemsController = TextEditingController(text: user['gems'].toString());

  int selectedLevel = user['level'] ?? 1;
  double xpValue = double.tryParse(user['xp'].toString()) ?? 0.0;
  int maxXP = getMaxXPForLevel(selectedLevel);

  bool resetPassword = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/bg_friends.webp'),
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Edit User',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildEditableField('Name', nameController),
                      _buildEditableField('Email', emailController),

                      _buildSliderField(
                        'XP',
                        xpValue,
                        0.0,
                        maxXP.toDouble(),
                            (value) {
                          setState(() {
                            xpValue = value;
                          });
                        },
                      ),

                      _buildDropdownField(
                        'Level',
                        selectedLevel,
                        List<int>.generate(100, (index) => index + 1),
                            (newValue) {
                          setState(() {
                            selectedLevel = newValue!;
                            maxXP = getMaxXPForLevel(selectedLevel);
                            if (xpValue > maxXP) {
                              xpValue = maxXP.toDouble();
                            }
                          });
                        },
                      ),

                      _buildEditableField('Coins', coinsController, isNumeric: true),
                      _buildEditableField('Gems', gemsController, isNumeric: true),

                      const SizedBox(height: 12),

                      // Reset Password Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Reset Password?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Switch(
                            value: resetPassword,
                            activeColor: const Color(0xFF7A393D),
                            onChanged: (value) {
                              setState(() {
                                resetPassword = value;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Prepare updated user data
                            user['name'] = nameController.text;
                            user['email'] = emailController.text;
                            user['xp'] = xpValue.toInt();
                            user['level'] = selectedLevel;
                            user['coins'] = int.tryParse(coinsController.text) ?? user['coins'];
                            user['gems'] = int.tryParse(gemsController.text) ?? user['gems'];

                            // Call onSave with resetPassword flag
                            onSave(user, resetPassword: resetPassword);

                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(resetPassword
                                    ? 'User details updated and password reset.'
                                    : 'User details updated successfully.'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7A393D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'SAVE CHANGES',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}






// Helper for TextField
Widget _buildEditableField(String label, TextEditingController controller,
    {bool isNumeric = false, IconData? prefixIcon}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0), // Slightly increased vertical spacing
    child: Material(
      elevation: 3, // Adds shadow for a slight elevation
      borderRadius: BorderRadius.circular(12), // Rounded edges for the material wrapper
      shadowColor: Colors.black38, // Subtle shadow color
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        style: const TextStyle(
          color: Colors.black, // Text color
          fontSize: 16,
        ),
        decoration: InputDecoration(
          // Prefix Icon for better context
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: const Color(0xFF7A393D))
              : null,

          // Label Text
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF7A393D), // D&D themed color
            fontWeight: FontWeight.bold,
          ),

          filled: true,
          fillColor: Colors.white.withOpacity(0.9), // Slightly more opaque background

          // Border when not focused
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF7A393D), width: 1.0),
          ),

          // Border when focused
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black, width: 2.0),
          ),

          // Error border
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),

          // Focused Error border
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),

          // Content padding for better alignment
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        ),
      ),
    ),
  );
}


// Helper for Slider
Widget _buildSliderField(String label, double value, double min, double max, ValueChanged<double> onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$label: ${value.toInt()}',
        style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      Slider(
        value: value,
        min: min,
        max: max,
        divisions: (max - min).toInt(),
        activeColor: const Color(0xFF7A393D),
        inactiveColor: Colors.grey,
        onChanged: onChanged,
      ),
    ],
  );
}

// Helper for Dropdown
Widget _buildDropdownField(String label, int value, List<int> options, ValueChanged<int?> onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        DropdownButton<int>(
          value: value,
          items: options
              .map((level) => DropdownMenuItem<int>(
            value: level,
            child: Text(level.toString()),
          ))
              .toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue); // Safely call onChanged with non-null value
            }
          },
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    ),
  );
}



void _showUserDetailsDialog(BuildContext context, Map<String, dynamic> user) {
  final int level = user['level'] ?? 1; // Default to level 1
  final int currentXP = user['xp'] ?? 0;
  final int maxXP = getMaxXPForLevel(level);
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // User Avatar with Shadow
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/${user['image'] ?? 'default_avatar.png'}.webp'),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 12),

                // User Name
                Text(
                  user['name'] ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Updated to black
                  ),
                ),
                const Divider(
                  color: Color(0xFF4B4B4B),
                  thickness: 2,
                  indent: 30,
                  endIndent: 30,
                ),

                // User Info with Icons
                _buildUserDetailWithIcon(Icons.email, 'Email', user['email']),
                _buildUserDetailWithIcon(Icons.stars, 'Level', user['level'].toString()),
                _buildUserDetailWithIcon(Icons.bar_chart, 'XP', '$currentXP / $maxXP'),
                _buildUserDetailWithIcon(Icons.attach_money, 'Coins', user['coins'].toString()),
                _buildUserDetailWithIcon(Icons.diamond, 'Gems', user['gems'].toString()),
                _buildUserDetailWithIcon(
                  user['isOnline'] == true ? Icons.circle : Icons.circle_outlined,
                  'Status',
                  user['isOnline'] == true ? 'Online' : 'Offline',
                  color: user['isOnline'] == true ? Colors.green : Colors.red,
                ),

                const SizedBox(height: 16),

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

Widget _buildUserDetailWithIcon(IconData icon, String label, String value, {Color? color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: color ?? Colors.black, // Icon color remains black or custom
        ),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Text label in black
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black, // User info value in black
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}



class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final Function onDelete;
  final VoidCallback onTap;

  const UserCard({super.key,
    required this.user,
    required this.onDelete,
    required this.onTap,
  });

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.grey.shade600,
            width: 2,
          ),
        ),
        elevation: 20, // Adding shadow for a more mystical feel
        child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/bg_friends.webp'), // Background image
              fit: BoxFit.cover, // Cover the entire container
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Delete Notification',
                  style: TextStyle(
                    color: Colors.white, // White text for better visibility
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Are you sure you want to delete this user?',
                  style: TextStyle(
                    color: Colors.white70, // Slightly lighter text for readability
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // Cancellation
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.redAccent, // Red color for cancellation
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); // Confirmation
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.greenAccent, // Green color for confirmation
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return result ?? false;
  }



  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user['imageUrl']!),
        radius: 30,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user['name']!, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(user['email']!, style: TextStyle(color: Colors.grey)),
          Text('Level: ${user['level']}', style: TextStyle(color: Colors.blue)),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () async {
          bool confirmed = await _confirmDelete(context);
          if (confirmed) {
            onDelete(); // Call the deletion function if confirmed
          }
        },
      ),
      onTap: onTap,
    );
  }
}

