import 'package:flutter/material.dart';

class ProfileDetailPage extends StatelessWidget {
  final ValueNotifier<Map<String, dynamic>> user;

  const ProfileDetailPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[50],
        elevation: 0,

      ),
      body: ValueListenableBuilder<Map<String, dynamic>>(
        valueListenable: user,
        builder: (context, userData, child) {
          return Container(
            color: Colors.purple[50],
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar et bienvenue
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(userData['imageUrl']),
                ),
                SizedBox(height: 16),
                Text(
                  'Hi, ${userData['name']}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Joined ${userData['joinDate']}',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 16),

                // Citation du jour
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Quote of the day',
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '"The time we spend awake is precious, but so is the time we spend asleep."',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'LEBRON JAMES',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Barre de progression
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ZEN MASTER',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: userData['progress'],
                              color: Colors.purple,
                              backgroundColor: Colors.purple[100],
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('LV ${userData['level']}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                          '${userData['currentXP']}/${userData['maxXP']} to LV ${userData['level']}'),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Statistiques
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatCard(
                        label: '${userData['completedSessions']}',
                        description: 'Completed Sessions'),
                    _StatCard(
                        label: '${userData['minutesSpent']}',
                        description: 'Minutes Spent'),
                    _StatCard(
                        label: '${userData['longestStreak']}',
                        description: 'Longest Streak'),
                  ],
                ),
                SizedBox(height: 16),

                // Bouton de partage
                ElevatedButton.icon(
                  onPressed: () {
                    // Partager les statistiques
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(Icons.share, color: Colors.white),
                  label: Text('Share My Stats',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String description;

  const _StatCard({required this.label, required this.description});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
