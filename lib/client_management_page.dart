// ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'services/user_service.dart';
// import 'models/user.dart';
// import 'register_user_page.dart';

// class ClientManagementPage extends StatefulWidget {
//   const ClientManagementPage({super.key});

//   @override
//   _ClientManagementPageState createState() => _ClientManagementPageState();
// }

// class _ClientManagementPageState extends State<ClientManagementPage> {
//   final UserService _userService = UserService();
//   List<User> _clients = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadClients();
//   }

//   Future<void> _loadClients() async {
//     List<User> clients = await _userService.getAllUsers();
//     setState(() {
//       _clients = clients;
//     });
//   }

//   Future<void> _deleteClient(String id) async {
//     await _userService.deleteUser(id);
//     _loadClients();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Client Management'),
//       ),
//       body: ListView.builder(
//         itemCount: _clients.length,
//         itemBuilder: (context, index) {
//           User client = _clients[index];
//           return ListTile(
//             title: Text('${client.firstName} ${client.lastName}'),
//             subtitle: Text(client.email),
//             trailing: IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: () => _deleteClient(client.id),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const RegisterUserPage()),
//           ).then((value) => _loadClients());
//         },
//       ),
//     );
//   }
// }


//2nd snippet
// import 'package:flutter/material.dart';
// import 'services/user_service.dart';
// import 'models/user.dart';
// import 'register_user_page.dart';

// class ClientManagementPage extends StatefulWidget {
//   const ClientManagementPage({super.key});

//   @override
//   _ClientManagementPageState createState() => _ClientManagementPageState();
// }

// class _ClientManagementPageState extends State<ClientManagementPage> {
//   final UserService _userService = UserService();
//   List<User> _clients = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadClients();
//   }

//   Future<void> _loadClients() async {
//     List<User> clients = await _userService.getAllUsers();
//     setState(() {
//       _clients = clients;
//     });
//   }

//   Future<void> _deleteClient(String id) async {
//     await _userService.deleteUser(id);
//     _loadClients();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Client Management'),
//       ),
//       body: ListView.builder(
//         itemCount: _clients.length,
//         itemBuilder: (context, index) {
//           User client = _clients[index];
//           return ListTile(
//             title: Text('${client.firstName} ${client.lastName}'),
//             subtitle: Text(client.email),
//             trailing: IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: () => _deleteClient(client.id),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const RegisterUserPage()),
//           ).then((value) => _loadClients());
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'services/user_service.dart';
import 'models/user.dart';
import 'register_user_page.dart';

class ClientManagementPage extends StatefulWidget {
  const ClientManagementPage({super.key});

  @override
  _ClientManagementPageState createState() => _ClientManagementPageState();
}

class _ClientManagementPageState extends State<ClientManagementPage> {
  final UserService _userService = UserService();
  List<User> _clients = [];

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    List<User> clients = await _userService.getAllUsers();
    setState(() {
      _clients = clients;
    });
  }

  Future<void> _deleteClient(String id) async {
    await _userService.deleteUser(id);
    _loadClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Management'),
      ),
      body: ListView.builder(
        itemCount: _clients.length,
        itemBuilder: (context, index) {
          User client = _clients[index];
          return ListTile(
            title: Text('${client.firstName} ${client.lastName}'),
            subtitle: Text(client.email),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteClient(client.id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterUserPage()),
          ).then((value) => _loadClients());
        },
      ),
    );
  }
}
