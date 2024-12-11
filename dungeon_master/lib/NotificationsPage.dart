import 'package:flutter/material.dart';

import 'Homepage.dart';

class NotificationsPage extends StatelessWidget {
  final ValueNotifier<Map<String, dynamic>> user;

  NotificationsPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Section "New"
            Text(
              'New',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            NotificationItem(
              name: 'Julia Hosten',
              role: 'Senior Designer',
              time: '13:55',
              message: 'Hey Kate how are things going...',
              isNew: true,
            ),
            NotificationItem(
              name: 'Chris Evans',
              role: 'Software Engineer',
              time: '12:30',
              message: 'Can we reschedule the meeting?',
              isNew: true,
            ),
            SizedBox(height: 20),

            // Section "Yesterday"
            Text(
              'Yesterday',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            NotificationItem(
              name: 'Olivia Holt',
              role: 'Junior Designer',
              time: '09:45',
              message: 'Let me know when you\'re available.',
              isNew: false,
            ),
            NotificationItem(
              name: 'Mark Smith',
              role: 'Team Lead',
              time: '08:20',
              message: 'Good job on the recent project!',
              isNew: false,
            ),
            NotificationItem(
              name: 'Emma Watson',
              role: 'Project Manager',
              time: '07:15',
              message: 'We need to finalize the report by EOD.',
              isNew: false,
            ),
            SizedBox(height: 20),

            // Section "Last Week"
            Text(
              'Last Week',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            NotificationItem(
              name: 'Steve Rogers',
              role: 'Quality Analyst',
              time: 'Last Monday',
              message: 'All tests passed successfully.',
              isNew: false,
            ),
            NotificationItem(
              name: 'Tony Stark',
              role: 'CTO',
              time: 'Last Sunday',
              message: 'Keep pushing the limits!',
              isNew: false,
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            // Retour à la page d'accueil et passer le `user` en paramètre
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(user: user), // Passer `user`
              ),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
        ],
      ),

    );
  }
}

class NotificationItem extends StatelessWidget {
  final String name;
  final String role;
  final String time;
  final String message;
  final bool isNew;

  NotificationItem({
    required this.name,
    required this.role,
    required this.time,
    required this.message,
    required this.isNew,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        child: Text(
          name[0],
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(role),
          Text(
            message,
            style: TextStyle(color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(color: Colors.grey),
          ),
          if (isNew)
            Icon(
              Icons.circle,
              size: 10,
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}
