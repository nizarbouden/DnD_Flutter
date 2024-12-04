import 'package:dungeon_master/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'CustomNavbar.dart';
import 'Settings.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> user; // Définir l'utilisateur

  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _userService = AuthService();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Deux onglets
    _tabController.addListener(_onTabChanged); // Écouteur pour le changement d'onglet
  }

  void _onTabChanged() {
    setState(() {}); // Mettre à jour l'UI lors du changement d'onglet
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged); // Retirer l'écouteur pour éviter les fuites de mémoire
    super.dispose();
  }
  Future<void> _navigateToSettings() async {
    try {
      // Récupération des données utilisateur

      final response = await _userService.getUserByEmail(widget.user['email']);
      if (response['error'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        return;
      }
      final user = response['user'];

      // Navigation avec les données utilisateur
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPage(user: user),
        ),
      );
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
          // Image de fond
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_hs.jpeg'), // Assurez-vous que l'image est dans le dossier `assets`
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu principal
          CustomScrollView(
            slivers: [
              // AppBar dans un SliverAppBar pour permettre le défilement avec le contenu
              SliverAppBar(
                backgroundColor: Colors.black.withOpacity(0.8), // Transparence
                title: Center(
                  child: Text(
                    'Dashboard',
                    style: TextStyle(color: Colors.white), // Couleur du titre
                  ),
                ),
                pinned: true,
                floating: false,
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.black, // Couleur de l'indicateur sous les onglets
                  labelColor: Colors.deepPurple, // Couleur des onglets sélectionnés (mauve)
                  unselectedLabelColor: Colors.grey, // Couleur des onglets non sélectionnés (gris)
                  labelStyle: TextStyle(fontWeight: FontWeight.bold), // Style pour les labels sélectionnés
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Style pour les labels non sélectionnés
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.dashboard,
                        color: _tabController.index == 0 ? Colors.deepPurple : Colors.grey, // Dynamique en fonction de la sélection
                      ),
                      text: 'Vue d\'ensemble',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.settings,
                        color: _tabController.index == 1 ? Colors.deepPurple : Colors.grey, // Dynamique en fonction de la sélection
                      ),
                      text: 'Gestion',
                    ),
                  ],
                ),
              ),
              // TabBarView sous forme de SliverList pour gérer correctement le défilement
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    OverviewTab(email: widget.user['email']),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(user: widget.user['user'])),
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
  final String email; // Utilisation de l'email pour cet onglet

  OverviewTab({required this.email});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        shrinkWrap: true, // Utilisation de shrinkWrap pour éviter que GridView ne prenne toute la place
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          DashboardCard(
            title: 'Utilisateurs actifs',
            value: '150',
            icon: Icons.group,
          ),
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
