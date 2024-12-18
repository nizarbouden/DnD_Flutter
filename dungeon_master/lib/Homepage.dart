import 'package:dungeon_master/gamemodes_page.dart';
import 'package:dungeon_master/icon_player.dart';
import 'package:dungeon_master/service/auth_service.dart';
import 'package:dungeon_master/service/equip_service.dart';
import 'package:dungeon_master/service/gm_service.dart';
import 'package:dungeon_master/service/icon_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Ajouter cette dépendance
import 'NotificationsPage.dart';
import 'Settings.dart';
import 'ShopManagementPage.dart';
import 'UserManagementPage.dart';

class HomePage extends StatefulWidget {
  final ValueNotifier<Map<String, dynamic>> user;

  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _userService = AuthService();
  final EquipService _eqpService = EquipService();
  final IconService _icService = IconService();
  final GmService _gmService = GmService();
  int totalPlayers = 0;
  int totalEquipments = 0;
  int totalIcons = 0;
  int totalgms = 0;
  int onlinePlayers = 0;
  int offlinePlayers = 0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    fetchTotalPlayers();
    fetchTotalEquipments();
    fetchTotalIcons();
    fetchGamemodes();
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
      int onlineCount = 0;
      int offlineCount = 0;

      // Count online and offline players
      for (var user in users) {
        if (user['isOnline'] == true) {
          onlineCount++;
        } else {
          offlineCount++;
        }
      }
      setState(() {
        totalPlayers = users.length;
        onlinePlayers = onlineCount;
        offlinePlayers = offlineCount;
      });
    } catch (e) {
      print('Error fetching players: $e');
    }
  }

  Future<void> fetchTotalEquipments() async {
    try {
      final eqps = await _eqpService.fetchEqps();
      setState(() {
        totalEquipments = eqps.length;
      });
    } catch (e) {
      print('Error fetching players: $e');
    }
  }

  Future<void> fetchTotalIcons() async {
    try {
      final icons = await _icService.fetchIcons();
      setState(() {
        totalIcons = icons.length;
      });
    } catch (e) {
      print('Error fetching icons: $e');
    }
  }

  Future<void> fetchGamemodes() async {
    try {
      final gms = await _gmService.fethcGms();
      setState(() {
        totalgms = gms.length;
        print(gms);
      });
    } catch (e) {
      print('Error fetching icons: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Color(0xFFD4CFC4), // Set text color to white
            fontSize: 20, // Increase the font size
            fontWeight: FontWeight.bold, // Optional: Make it bold
          ),
        ),
        backgroundColor: const Color(0xFF502722),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: const Color(0xFFD4CFC4),
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
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/bg_dash.webp', // Path to your background image
              fit: BoxFit.cover, // Ensures the image fills the space
            ),
          ),
          // Foreground Content
          SingleChildScrollView(
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
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildStatCard(
                        'Equipments',
                        totalEquipments.toString(),
                        'assets/eqp.png',
                        () {},
                      ),
                      _buildStatCard(
                        'Players',
                        totalPlayers.toString(),
                        'assets/items.png',
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserManagementPage(
                                      user: widget.user,
                                    ))),
                      ),
                      _buildStatCard(
                        'Icons',
                        totalIcons.toString(),
                        'assets/icc.png',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IconPlayer(user: widget.user),
                          ),
                        ),
                      ),
                      _buildStatCard(
                        'Game Mode(s)',
                        totalgms.toString(),
                        'assets/gamemodes.png',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GamemodesPage(user: widget.user),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Section du graphique
                  Card(
                    elevation: 6, // Add elevation for shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    child: Stack(
                      children: [
                        // Background Image
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                12), // Match card's rounded corners
                            child: Image.asset(
                              'assets/bg_friends.webp', // Replace with your image path
                              fit: BoxFit
                                  .cover, // Ensures image covers the entire card
                              color: Colors.black.withOpacity(
                                  0.3), // Optional: Darken the image
                              colorBlendMode: BlendMode.darken,
                            ),
                          ),
                        ),
                        // Foreground Content
                        Padding(
                          padding: const EdgeInsets.all(
                              16.0), // Padding for spacing inside the card
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                'Online Vs Offline Players (Total: $totalPlayers)',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(
                                      0xFFD4CFC4), // Text color for better visibility
                                ),
                              ),

                              const SizedBox(height: 20),
                              // Pie Chart
                              AspectRatio(
                                aspectRatio: 1.6,
                                child: Card(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Stack(
                                    children: [
                                      // Pie Chart Content
                                      Center(
                                        child: PieChart(
                                          PieChartData(
                                            sections: _generatePieSections(
                                                online: onlinePlayers,
                                                offline: offlinePlayers),
                                            borderData:
                                                FlBorderData(show: false),
                                            centerSpaceRadius:
                                                40, // Space in center for aesthetics
                                            sectionsSpace:
                                                4, // Space between sections
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  height:
                                      16), // Spacing between chart and legend
                              // Legend Section
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Online Players Legend
                                  Row(
                                    children: [
                                      Icon(Icons.circle,
                                          color: Color(0xFF7A393D),
                                          size: 16), // Red Circle
                                      SizedBox(width: 8),
                                      Text(
                                        'Online Players',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20), // Space between legends
                                  // Offline Players Legend
                                  Row(
                                    children: [
                                      Icon(Icons.circle,
                                          color: Color(0xFFD4CFC4),
                                          size: 16), // White Circle
                                      SizedBox(width: 8),
                                      Text(
                                        'Offline Players',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Color(0xFF7A393D), // Deep red background for medieval feel
        currentIndex: _currentIndex,
        selectedItemColor:
            Color(0xFFD4CFC4), // Slightly off-white for selected item
        unselectedItemColor: Colors.white70, // Soft white for unselected items
        selectedLabelStyle: const TextStyle(
          fontFamily: 'VecnaBold', // Fantasy-inspired font
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'VecnaBold',
          fontSize: 15,
        ),
        type: BottomNavigationBarType.fixed, // Ensures all items are visible
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
          } else if (index == 3) {
            _navigateToSettings();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                  'assets/homeicnav.png'), // Replace with your custom sword icon
              size: 20,
              color: Color(0xFFD4CFC4),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                  'assets/shopnav.png'), // Replace with a medieval store icon
              size: 30,
            ),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                  'assets/playersnav.png'), // Replace with a players or adventurers icon
              size: 30,
            ),
            label: 'Players',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                  'assets/profilenav.png'), // Replace with a shield or profile icon
              size: 25,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String count, String imagePath, VoidCallback onPressed) {
    return Card(
      elevation: 6, // Add prominent elevation for depth
      shadowColor: Colors.black26, // Subtle shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Consistent rounded corners
      ),
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/bg_friends.webp', // Background image path
                fit: BoxFit.cover, // Cover the entire card
                color: Colors.black
                    .withOpacity(0.3), // Optional: Add a dark overlay
                colorBlendMode: BlendMode.darken, // Blend to darken the image
              ),
            ),
          ),
          // Foreground Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Custom Image/Icon
                  Image.asset(
                    imagePath, // Custom image path for icons
                    height: 50,
                    width: 50,
                  ),
                  const SizedBox(height: 5),
                  // Count Text
                  Text(
                    count,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(
                          0xFFD4CFC4), // Visible on the darkened background
                    ),
                  ),
                  // Title Text
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFD4CFC4), // Softer white for the subtitle
                    ),
                  ),
                  // Navigation Button
                  IconButton(
                    onPressed: onPressed,
                    icon: const Icon(
                      Icons.info_outline, // Info icon
                      color: Color(0xFF7A393D), // Icon color
                      size: 28, // Adjust size if needed
                    ),
                    tooltip: 'More Details', // Tooltip for accessibility
                  ),
                ],
              ),
            ),
          ),
        ],
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
            y: (index + 1) * 10.0, // Hauteur de la barre bleue
            colors: [
              Colors.blue
            ], // Utilisation de 'colors' pour la couleur de la barre
            width: 15, // Largeur de la barre
            borderRadius: BorderRadius.zero, // Bordure de la barre
          ),
          BarChartRodData(
            y: (index + 1) * 7.0, // Hauteur de la barre verte
            colors: [
              Colors.green
            ], // Utilisation de 'colors' pour la couleur de la barre
            width: 15, // Largeur de la barre
            borderRadius: BorderRadius.zero, // Bordure de la barre
          ),
        ],
      );
    });
  }

  Future<void> _navigateToSettings() async {
    try {
      final response =
          await _userService.fetchAdminByEmail(widget.user.value['email']);
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
        const SnackBar(
            content: Text(
                'Erreur lors de la récupération des données utilisateur.')),
      );
    }
  }

  // Function to Generate PieChart Sections
  List<PieChartSectionData> _generatePieSections(
      {required int online, required int offline}) {
    final total = online + offline;
    return [
      PieChartSectionData(
        color: const Color(0xFF7A393D), // D&D Red for online players
        value: online.toDouble(),
        title: '${((online / total) * 100).toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: const Color(0xFFD4CFC4), // Light D&D Beige for offline players
        value: offline.toDouble(),
        title: '${((offline / total) * 100).toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ];
  }
}
