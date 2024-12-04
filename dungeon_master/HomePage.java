import 'package:flutter/material.dart';
import 'CustomNavbar.dart';
import 'Settings.dart';

class HomePage extends StatefulWidget {
    @override
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
    late TabController _tabController;

    @override
    void initState() {
        super.initState();
        _tabController = TabController(length: 2, vsync: this); // Deux onglets
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
        Column(
                children: [
        AppBar(
                backgroundColor: Colors.teal.withOpacity(0.8), // Transparence
                title: Text('Dashboard'),
                bottom: TabBar(
                controller: _tabController,
                tabs: [
        Tab(icon: Icon(Icons.dashboard), text: 'Vue d\'ensemble'),
        Tab(icon: Icon(Icons.settings), text: 'Gestion'),
                  ],
                ),
              ),
        Expanded(
                child: TabBarView(
                controller: _tabController,
                children: [
        OverviewTab(),
                ManagementTab(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
        bottomNavigationBar: CustomNavbar(
                onButtonPressed: (index) {
                switch (index) {
                    case 0:
                        Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage()),
              );
                        break;
                    case 1:
                        Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
                        break;
                    case 2:
                        Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
                        break;
                    case 3:
                        Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
                        break;
                }
        },
      ),
    );
    }
}

class OverviewTab extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
        Text(
                'Performance du jeu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        SizedBox(height: 10),
        Expanded(
                child: GridView.count(
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
                color: Colors.teal.withOpacity(0.8),
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
