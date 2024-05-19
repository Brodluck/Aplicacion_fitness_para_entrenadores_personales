// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'app_state.dart';
// import 'tabs/profile_tab.dart';
// import 'tabs/training_tab.dart';
// import 'tabs/dieting_tab.dart';
// import 'tabs/messages_tab.dart';
// import 'tabs/dashboard_tab.dart';

// class ClientHomeScreen extends StatelessWidget {
//   final List<Widget> _pages = [
//     const DashboardTab(),
//     const TrainingTab(),
//     const DietingTab(),
//     const MessagesTab(),
//   ];

//   final String userProfileImageUrl = 'https://cdn.pixabay.com/photo/2016/08/31/11/54/icon-1633249_1280.png';

//   ClientHomeScreen({super.key});


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
//                 backgroundColor: Colors.white,
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
//           BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Training'),
//           BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Dieting'),
//           BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ventanas/login_page.dart';
import 'app_state.dart';
import 'tabs/profile_tab.dart';
import 'tabs/training_tab.dart';
import 'tabs/dieting_tab.dart';
import 'tabs/messages_tab.dart';
import 'tabs/dashboard_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientHomeScreen extends StatelessWidget {
  final List<Widget> _pages = [
    const DashboardTab(),
    const TrainingTab(),
    const DietingTab(),
    const MessagesTab(chatId: '',),
  ];

  // final String userProfileImageUrl = 'https://cdn.pixabay.com/photo/2016/08/31/11/54/icon-1633249_1280.png';

  ClientHomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
  // Assuming you're using SharedPreferences for storing tokens or user session
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // This clears all data stored in SharedPreferences, adjust if necessary

  // Navigate back to the LoginPage and remove all routes behind it
  // ignore: use_build_context_synchronously
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
                backgroundColor: Colors.white,
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
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Training'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Dieting'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
        ],
      ),
    );
  }
}
