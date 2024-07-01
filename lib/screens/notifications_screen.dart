import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final List<Map<String, String>> notifications = [
    {
      'title': 'New Message',
      'description': 'You have received a new message.',
      'time': '5 mins ago'
    },
    {
      'title': 'Update Available',
      'description': 'A new update is available for your app.',
      'time': '1 hour ago'
    },
    {
      'title': 'Friend Request',
      'description': 'You have a new friend request.',
      'time': '3 hours ago'
    },
    {
      'title': 'Reminder',
      'description': 'Don\'t forget your meeting at 3 PM.',
      'time': '1 day ago'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: const Icon(Icons.notifications, color: Colors.blue),
            title: Text(notification['title']!),
            subtitle: Text(notification['description']!),
            trailing: Text(notification['time']!),
            onTap: () {
              // Handle notification tap
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Clicked on: ${notification['title']}')),
              );
            },
          );
        },
      ),
    );
  }
}
