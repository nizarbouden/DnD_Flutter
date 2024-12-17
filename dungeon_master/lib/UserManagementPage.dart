import 'package:flutter/material.dart';
import 'Homepage.dart';
import 'ProfileDetailPage.dart';
import 'Settings.dart';
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
  final List<Map<String, dynamic>> _initialUsers = [
    for (var i = 1; i <= 25; i++) // Create 25 users for testing pagination
      {
        'name': 'User $i',
        'imageUrl': 'https://via.placeholder.com/150',
        'progress': (i * 0.1) % 1,
        'level': i,
        'currentXP': i * 10,
        'maxXP': 100,
        'completedSessions': i * 2,
        'minutesSpent': i * 10,
        'longestStreak': '${i} days',
        'coins': i * 10,
        'gems': i * 5,
        'email': 'user$i@example.com',
        'friends': i % 3 + 1,
      }
  ];

  ValueNotifier<List<Map<String, dynamic>>> users = ValueNotifier([]);

  TextEditingController _searchController = TextEditingController();
  String selectedFilter = '';
  bool isAscendingName = true;
  bool isAscendingLevel = true;

  int _currentPage = 1;
  final int _usersPerPage = 10;

  @override
  void initState() {
    super.initState();
    // Initialiser les utilisateurs avec la liste d'origine
    users.value = List.from(_initialUsers);
  }

  List<Map<String, dynamic>> _getPaginatedUsers(List<Map<String, dynamic>> userList) {
    int start = (_currentPage - 1) * _usersPerPage;
    int end = start + _usersPerPage;
    return userList.sublist(start, end > userList.length ? userList.length : end);
  }

  void sortByName() {
    setState(() {
      isAscendingName = !isAscendingName;
      selectedFilter = 'name';
      users.value.sort((a, b) => isAscendingName
          ? a['name'].compareTo(b['name'])
          : b['name'].compareTo(a['name']));
    });
  }

  void sortByLevel() {
    setState(() {
      isAscendingLevel = !isAscendingLevel;
      selectedFilter = 'level';
      users.value.sort((a, b) => isAscendingLevel
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
      users.value = List.from(_initialUsers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _currentPage = 1; // Reset to the first page when searching
            });
          },
          decoration: InputDecoration(
            hintText: 'Search users...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Filtres horizontaux
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Name'),
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
                FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Level'),
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
          // Pagination controls at the top
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _currentPage < (users.value.length / _usersPerPage).ceil()
                    ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
                    : null,
              ),
            ],
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: users,
              builder: (context, userList, _) {
                var filteredUsers = userList
                    .where((user) => user['name']!
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()))
                    .toList();

                var paginatedUsers = _getPaginatedUsers(filteredUsers);

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: paginatedUsers.length,
                  itemBuilder: (context, index) {
                    return UserCard(
                      user: paginatedUsers[index],
                      onDelete: () {
                        setState(() {
                          users.value.remove(paginatedUsers[index]);
                        });
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileDetailPage(
                                user: ValueNotifier(paginatedUsers[index])),
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
  final Function onDelete;
  final VoidCallback onTap;

  const UserCard({
    required this.user,
    required this.onDelete,
    required this.onTap,
  });

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Notification'),
        content: Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancellation
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirmation
            },
            child: Text('Delete'),
          ),
        ],
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
        icon: Icon(Icons.delete, color: Colors.red),
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

