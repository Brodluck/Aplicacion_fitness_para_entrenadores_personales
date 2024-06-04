// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_state.dart';
import 'tabs/profile_tab.dart';
import 'tabs/training_tab.dart';
import 'tabs/dieting_tab.dart';
import 'tabs/messages_tab.dart';
import 'tabs/dashboard_tab.dart';
import 'login_page.dart';

class ClientHomeScreen extends StatelessWidget {
  final String userId;

  const ClientHomeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      // const DashboardTab(),
      TrainingTab(clientId: userId),
      DietingTab(clientId: userId),
      MessagesTab(userId: userId),
    ];

    final appState = Provider.of<AppState>(context);

    Future<void> _logout(BuildContext context) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }

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
                MaterialPageRoute(builder: (context) => ProfileTab(userId: userId)),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.person,
                size: 28.0, // Adjust size as needed
                color: Colors.grey,
              ),
            ),
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
        onTap: (index) {
          appState.setIndex(index);
        },
        items: const [
          // BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Training'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Dieting'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
        ],
      ),
    );
  }
}
