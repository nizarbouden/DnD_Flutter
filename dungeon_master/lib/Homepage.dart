import 'package:dungeon_master/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Ajouter cette dépendance
import 'NotificationsPage.dart';
import 'Settings.dart';
import 'UserManagementPage.dart';

class HomePage extends StatefulWidget {
  final ValueNotifier<Map<String, dynamic>> user;

  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _userService = AuthService();
  int totalPlayers = 0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    fetchTotalPlayers();
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
      final users = await _userService.fetchUsers();
      if (users != null && users is List) {
        setState(() {
          totalPlayers = users.length;
        });
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Error fetching players: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsPage(user: widget.user),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section des statistiques
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildStatCard('Active Jobs', '24', Icons.work, Colors.blue),
                  _buildStatCard('Candidates', '298', Icons.group, Colors.green),
                  _buildStatCard('Events', '54', Icons.event, Colors.purple),
                  _buildStatCard('To-dos', '48', Icons.check_circle, Colors.orange),
                ],
              ),
              SizedBox(height: 20),
              // Section du graphique
              Text(
                'Jobs Analytics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              AspectRatio(
                aspectRatio: 1.7,
                child: BarChart(
                  BarChartData(
                    barGroups: _createSampleData(),
                    titlesData: FlTitlesData(
                      leftTitles: SideTitles(showTitles: true),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTitles: (value) {
                          const titles = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'];
                          return titles[value.toInt()] ?? '';
                        },
                      ),
                    ),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Mettre à jour l'index actif
          });

          // Gérer la navigation en fonction de l'index
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(user: widget.user),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserManagementPage(),
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

  // Carte de statistiques
  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 10),
            Text(
              count,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Données échantillons pour le graphique
  List<BarChartGroupData> _createSampleData() {
    return List.generate(8, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            y: (index + 1) * 10.0,      // Hauteur de la barre bleue
            colors: [Colors.blue],       // Utilisation de 'colors' pour la couleur de la barre
            width: 15,                   // Largeur de la barre
            borderRadius: BorderRadius.zero, // Bordure de la barre
          ),
          BarChartRodData(
            y: (index + 1) * 7.0,       // Hauteur de la barre verte
            colors: [Colors.green],      // Utilisation de 'colors' pour la couleur de la barre
            width: 15,                   // Largeur de la barre
            borderRadius: BorderRadius.zero, // Bordure de la barre
          ),


        ],
      );
    });
  }

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
}
