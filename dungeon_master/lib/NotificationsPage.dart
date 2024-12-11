import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  final ValueNotifier<Map<String, dynamic>> user;

  NotificationsPage({required this.user});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Map<String, List<Map<String, dynamic>>> notifications = {
    'New': [
      {
        'name': 'Julia Hosten',
        'role': 'Senior Designer',
        'time': '13:55',
        'message': 'Hey Kate how are things going...',
        'isNew': true,
      },
      {
        'name': 'Chris Evans',
        'role': 'Software Engineer',
        'time': '12:30',
        'message': 'Can we reschedule the meeting?',
        'isNew': true,
      },
    ],
    'Yesterday': [
      {
        'name': 'Olivia Holt',
        'role': 'Junior Designer',
        'time': '09:45',
        'message': 'Let me know when you\'re available.',
        'isNew': false,
      },
      {
        'name': 'Mark Smith',
        'role': 'Team Lead',
        'time': '08:20',
        'message': 'Good job on the recent project!',
        'isNew': false,
      },
      {
        'name': 'Emma Watson',
        'role': 'Project Manager',
        'time': '07:15',
        'message': 'We need to finalize the report by EOD.',
        'isNew': false,
      },
    ],
    'Last Week': [
      {
        'name': 'Steve Rogers',
        'role': 'Quality Analyst',
        'time': 'Last Monday',
        'message': 'All tests passed successfully.',
        'isNew': false,
      },
      {
        'name': 'Tony Stark',
        'role': 'CTO',
        'time': 'Last Sunday',
        'message': 'Keep pushing the limits!',
        'isNew': false,
      },
    ],
  };

  Future<bool> _confirmDelete(String section, int index) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Notification'),
        content: Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Annulation
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
          children: notifications.keys.map((section) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ...List.generate(notifications[section]!.length, (index) {
                  final notification = notifications[section]![index];
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await _confirmDelete(section, index);
                    },
                    onDismissed: (direction) {
                      setState(() {
                        notifications[section]!.removeAt(index);
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: NotificationItem(
                      name: notification['name'],
                      role: notification['role'],
                      time: notification['time'],
                      message: notification['message'],
                      isNew: notification['isNew'],
                    ),
                  );
                }),
                SizedBox(height: 20),
              ],
            );
          }).toList(),
        ),
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
