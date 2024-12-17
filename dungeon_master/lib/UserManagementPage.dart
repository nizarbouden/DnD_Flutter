import 'package:flutter/material.dart';
import 'Homepage.dart';
import 'ProfileDetailPage.dart';
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

  // Example list of users
  ValueNotifier<List<Map<String, dynamic>>> users = ValueNotifier([
    {
      'name': 'Precious',
      'imageUrl': 'https://via.placeholder.com/150',
      'joinDate': 'Aug, 2022',
      'progress': 0.73,
      'level': 5,
      'currentXP': 220,
      'maxXP': 300,
      'completedSessions': 23,
      'minutesSpent': 94,
      'longestStreak': '15 days',
    },
    {
      'name': 'New User',
      'imageUrl': 'https://via.placeholder.com/150',
      'joinDate': 'Dec, 2024',
      'progress': 0.0,
      'level': 1,
      'currentXP': 0,
      'maxXP': 100,
      'completedSessions': 0,
      'minutesSpent': 0,
      'longestStreak': '0 days',
    },
  ]);

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            child: ValueListenableBuilder(
              valueListenable: users,
              builder: (context, userList, _) {
                var filteredUsers = userList
                    .where((user) => user['name']!
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()))
                    .toList();
                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    return UserCard(
                      user: filteredUsers[index],
                      onEdit: () {
                        // Logic for editing user
                      },
                      onDelete: () {
                        setState(() {
                          users.value.remove(filteredUsers[index]);
                        });
                      },
                      onTap: () {
                        // Logic for navigating to user details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileDetailPage(user: ValueNotifier(filteredUsers[index])),
                          ),
                        );
                      },
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
            // Navigate to profile/settings page
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
  final Map<String, dynamic> user;
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
            backgroundImage: NetworkImage(user['imageUrl']!),
          ),
          title: Text(user['name']!),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Level: ${user['level']}'),
              Text('XP: ${user['currentXP']}/${user['maxXP']}'),
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
            ],
          ),
        ),
      ),
    );
  }
}

