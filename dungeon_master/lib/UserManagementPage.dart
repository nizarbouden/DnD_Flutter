import 'package:dungeon_master/service/auth_service.dart';
import 'package:flutter/material.dart';

import 'Homepage.dart';
import 'Settings.dart';
import 'ShopManagementPage.dart';

class UserManagementPage extends StatefulWidget {
  final ValueNotifier<Map<String, dynamic>> user; // Le paramètre utilisateur

  const UserManagementPage({required this.user});

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  int _currentIndex = 2;
  final AuthService _userService = AuthService();
  // Example list of users
  List<Map<String, String>> users = [
    {
      'name': 'John Doe',
      'email': 'johndoe@example.com',
      'level': 'Admin',
      'image': 'assets/user1.jpg', // User image
    },
    {
      'name': 'Jane Smith',
      'email': 'janesmith@example.com',
      'level': 'User',
      'image': 'assets/user2.jpg', // User image
    },
    // Add more users here
  ];

  TextEditingController _searchController = TextEditingController();

  // Navigate to the settings page
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

  @override
  Widget build(BuildContext context) {
    // Accéder aux informations de l'utilisateur passé en paramètre
    final user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: Column(
        children: [
          // Dynamic search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Displaying the list of users with dynamic search
          Expanded(
            child: ListView.builder(
              itemCount: users
                  .where((user) =>
                  user['name']!.toLowerCase().contains(_searchController.text.toLowerCase()))
                  .toList()
                  .length,
              itemBuilder: (context, index) {
                var filteredUsers = users
                    .where((user) =>
                    user['name']!.toLowerCase().contains(_searchController.text.toLowerCase()))
                    .toList();
                return UserCard(
                  user: filteredUsers[index],
                  onEdit: () {
                    // Logic for editing user
                  },
                  onDelete: () {
                    setState(() {
                      users.remove(filteredUsers[index]);
                    });
                  },
                  onTap: () {
                    // Logic for navigating to user details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsPage(user: filteredUsers[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
}

class UserCard extends StatelessWidget {
  final Map<String, String> user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const UserCard({
    required this.user,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Action on card tap
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(user['image']!),
          ),
          title: Text(user['name']!),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user['email']!, overflow: TextOverflow.ellipsis),
              Text('Level: ${user['level']}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min, // Ensures the icons don't overflow
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: onEdit, // Edit user
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: onDelete, // Delete user
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward), // Arrow icon
                onPressed: () {
                  onTap(); // Action on arrow tap
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDetailsPage extends StatelessWidget {
  final Map<String, String> user;

  const UserDetailsPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(user['image']!),
            ),
            SizedBox(height: 20),
            Text('Name: ${user['name']}'),
            Text('Email: ${user['email']}'),
            Text('Level: ${user['level']}'), // Added level here too
          ],
        ),
      ),
    );
  }
}
