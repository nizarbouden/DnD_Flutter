import 'package:dungeon_master/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'CustomNavbar.dart';
import 'PlayersPieChart.dart';
import 'Settings.dart';

class HomePage extends StatefulWidget {
  final ValueNotifier<Map<String, dynamic>> user; // Utiliser un ValueNotifier

  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _userService = AuthService();
  int totalPlayers = 0; // Ajouter une variable d'état pour les joueurs

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    fetchTotalPlayers(); // Appeler la méthode lors de l'initialisation
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {});
  }
  Future<void> fetchTotalPlayers() async {
    try {
      // Appeler la méthode de votre service pour récupérer tous les utilisateurs
      final users = await _userService.fetchUsers();

      // Vérifier si `users` est une liste et mettre à jour l'état
      if (users != null && users is List) {
        setState(() {
          totalPlayers = users.length; // Mettre à jour le total des joueurs
        });
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Error fetching players: $e');
    }
  }

  Future<void> _navigateToSettings() async {
    try {
      final response = await _userService.getUserByEmail(widget.user.value['email']);
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
        SnackBar(content: Text('Erreur lors de la récupération des données utilisateur.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_hs.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.black.withOpacity(0.8),
                title: Center(
                  child: Text(
                    'Dashboard',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                pinned: true,
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.black,
                  labelColor: Colors.deepPurple,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(
                      icon: Icon(Icons.dashboard),
                      text: 'Vue d\'ensemble',
                    ),
                    Tab(
                      icon: Icon(Icons.settings),
                      text: 'Gestion',
                    ),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    OverviewTab(
                      email: widget.user.value['email'],
                      totalPlayers: totalPlayers,
                      onlinePlayers: 1,// Passer le nombre dynamique
                    ),
                    ManagementTab(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomNavbar(
        onButtonPressed: (index) async {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(user: widget.user),
                ),
              );
              break;
            case 1:
              await _navigateToSettings();
              break;
            case 2:
              await _navigateToSettings();
              break;
            case 3:
              await _navigateToSettings();
              break;
          }
        },
      ),
    );
  }
}


class OverviewTab extends StatelessWidget {
  final String email;
  final int totalPlayers;
  final int onlinePlayers;

  OverviewTab({required this.email, required this.totalPlayers, required this.onlinePlayers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Carte spéciale pour la charte graphique qui prend toute la largeur
          Card(
            color: Colors.black.withOpacity(0.8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Carte Charte Graphique
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Charte Graphique',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      // Vous pouvez ajouter ici un graphique ou un visuel lié à la charte graphique
                      Icon(Icons.color_lens, size: 40, color: Colors.white),
                    ],
                  ),
                  // Carte des joueurs en ligne et hors ligne à droite
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Joueurs en ligne: $onlinePlayers',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Joueurs hors ligne: ${totalPlayers - onlinePlayers}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Utilisation de Expanded pour que GridView puisse s'ajuster à l'espace restant
          Expanded(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                DashboardCard(
                  title: 'Parties jouées',
                  value: '1200',
                  icon: Icons.videogame_asset,
                ),
                DashboardCard(
                  title: 'Objets échangés',
                  value: '320',
                  icon: Icons.swap_horiz,
                ),
                DashboardCard(
                  title: 'Armes améliorées',
                  value: '45',
                  icon: Icons.upgrade,
                ),
                DashboardCard(
                  title: 'Armes améliorées',
                  value: '45',
                  icon: Icons.upgrade,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




class ManagementTab extends StatelessWidget {
  final List<Item> _items = [
    Item(header: 'Gestion des Objets', body: 'Ajouter, modifier ou supprimer des objets.'),
    Item(header: 'Gestion des Utilisateurs', body: 'Modifier les permissions ou supprimer des comptes.'),
  ];


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          _items[index].isExpanded = !isExpanded;
        },
        children: _items.map<ExpansionPanel>((Item item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  item.header,
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
            body: ListTile(
              title: Text(item.body, style: TextStyle(color: Colors.white)),
              subtitle: Text('Cliquez pour gérer.', style: TextStyle(color: Colors.white70)),
              onTap: () {
                // Navigation ou action correspondante
              },
            ),
            isExpanded: item.isExpanded,
          );
        }).toList(),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.8), // Couleur des cartes
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  String header;
  String body;
  bool isExpanded;

  Item({required this.header, required this.body, this.isExpanded = false});
}
