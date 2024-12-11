import 'package:flutter/material.dart';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  // Exemple de liste d'utilisateurs
  List<Map<String, String>> users = [
    {
      'name': 'John Doe',
      'email': 'johndoe@example.com',
      'level': 'Admin',
      'image': 'assets/user1.jpg', // Image de l'utilisateur
    },
    {
      'name': 'Jane Smith',
      'email': 'janesmith@example.com',
      'level': 'User',
      'image': 'assets/user2.jpg', // Image de l'utilisateur
    },
    // Ajoutez plus d'utilisateurs ici
  ];

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des utilisateurs'),
      ),
      body: Column(
        children: [
          // Barre de recherche dynamique
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Recherche',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Affichage de la liste des utilisateurs avec recherche dynamique
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
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        onTap: onTap,  // Redirection vers les détails
        leading: CircleAvatar(
          backgroundImage: AssetImage(user['image']!),
        ),
        title: Text(user['name']!),
        subtitle: Text('${user['email']} - ${user['level']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,  // Modification de l'utilisateur
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,  // Suppression de l'utilisateur
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: onTap,  // Clic sur la carte pour les détails
            ),
          ],
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
        title: Text('Détails de l\'utilisateur'),
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
            Text('Nom: ${user['name']}'),
            Text('Email: ${user['email']}'),
            Text('Niveau: ${user['level']}'),
          ],
        ),
      ),
    );
  }
}
