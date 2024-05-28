// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'app_state.dart';
import 'tabs/profile_tab.dart';
import 'tabs/trainer_dashboard_tab.dart';
import 'client_management_page.dart';
import 'tabs/trainer_messages_tab.dart';

class TrainerHomeScreen extends StatelessWidget {
  final String trainerId;

  const TrainerHomeScreen({super.key, required this.trainerId});

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final List<Widget> _pages = [
      const TrainerDashboardTab(),
      const ClientManagementPage(),
      TrainerMessagesTab(trainerId: trainerId),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainer App'),
        actions: <Widget>[
          InkWell(
            onTap: () => _logout(context),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.exit_to_app),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileTab(userId: trainerId)),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person, 
                  size: 50.0,
                  color: Colors.grey,
                ),
              )
            )
          ),
        ],
      ),
      body: IndexedStack(
        index: appState.selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: appState.selectedIndex,
        onTap: (index) => appState.setIndex(index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clients'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
        ],
      ),
    );
  }
}
