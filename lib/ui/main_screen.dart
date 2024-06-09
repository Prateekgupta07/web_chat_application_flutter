import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/websocket_service.dart';
import 'chat_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String selectedSession = 'Session 1'; // Default session

  void _logout() async {
    final authService = context.read<AuthService>();
    await authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Row(
        children: [
          // Session List
          Expanded(
            flex: 1,
            child: SessionList(
              onSessionSelected: (session) {
                setState(() {
                  selectedSession = session;
                });
              },
            ),
          ),
          // Chat Area
          Expanded(
            flex: 3,
            child: ChatScreen(session: selectedSession),
          ),
        ],
      ),
    );
  }
}

class SessionList extends StatelessWidget {
  final Function(String) onSessionSelected;

  SessionList({required this.onSessionSelected});

  @override
  Widget build(BuildContext context) {
    final sessions = ['Session 1', 'Session 2', 'Session 3'];

    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(sessions[index]),
          onTap: () {
            onSessionSelected(sessions[index]);
          },
        );
      },
    );
  }
}
