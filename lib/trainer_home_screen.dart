// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'app_state.dart';
// import 'tabs/profile_tab.dart';
// import 'tabs/trainer_dashboard_tab.dart';
// import 'tabs/show_client_tab.dart';
// import 'tabs/trainer_messages_tab.dart';

// class TrainerHomeScreen extends StatelessWidget {
//   final List<Widget> _pages = [
//     const TrainerDashboardTab(),
//     const ShowClientTab(),
//     const TrainerMessagesTab(),
//   ];

//   final String userProfileImageUrl = 'https://via.placeholder.com/150';

//   TrainerHomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final appState = Provider.of<AppState>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Trainer App'),
//         actions: <Widget>[
//           InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ProfileTab()),
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: CircleAvatar(
//                 backgroundImage: NetworkImage(userProfileImageUrl),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: IndexedStack(
//         index: appState.selectedIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: appState.selectedIndex,
//         onTap: (index) => appState.setIndex(index),
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clients'),
//           BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ventanas/login_page.dart';
// import 'app_state.dart';
// import 'tabs/profile_tab.dart';
// import 'tabs/trainer_dashboard_tab.dart';
// import 'package:ventanas/client_home_screen.dart';
// import 'tabs/trainer_messages_tab.dart';

// class TrainerHomeScreen extends StatelessWidget {
//   final List<Widget> _pages = [
//     TrainerDashboardTab(),
//     TrainerMessagesTab(),
//     ClientHomeScreen(),
//   ];


//   TrainerHomeScreen({super.key});

//   Future<void> _logout(BuildContext context) async {
//   // Assuming you're using SharedPreferences for storing tokens or user session
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.clear(); // This clears all data stored in SharedPreferences, adjust if necessary

//   // Navigate back to the LoginPage and remove all routes behind it
//   // ignore: use_build_context_synchronously
//   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
// }

//   @override
//   Widget build(BuildContext context) {
//     final appState = Provider.of<AppState>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Trainer App'),
//         actions: <Widget>[
//           InkWell(
//             onTap: () => _logout(context),
//             child: const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Icon(Icons.exit_to_app),
//             ),
//           ),
//           InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ProfileTab(userId: '',)),
//               );
//             },
//             child: const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: CircleAvatar(
//                 backgroundImage: NetworkImage('https://via.placeholder.com/150'),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: IndexedStack(
//         index: appState.selectedIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: appState.selectedIndex,
//         onTap: (index) => appState.setIndex(index),
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clients'),
//           BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'app_state.dart';
import 'tabs/profile_tab.dart';
import 'tabs/trainer_dashboard_tab.dart';
import 'client_management_page.dart'; // Ensure this is imported
import 'tabs/trainer_messages_tab.dart';

class TrainerHomeScreen extends StatelessWidget {
  final List<Widget> _pages = [
    const TrainerDashboardTab(),
    const ClientManagementPage(),
    const TrainerMessagesTab(),
  ];

  TrainerHomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This clears all data stored in SharedPreferences, adjust if necessary

    // Navigate back to the LoginPage and remove all routes behind it
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
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
                MaterialPageRoute(builder: (context) => const ProfileTab(userId: '',)),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage('https://via.placeholder.com/150'),
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
