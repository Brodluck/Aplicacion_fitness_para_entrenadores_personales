// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:ventanas/tabs/exercise_assignment_page.dart';
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
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ExerciseAssignmentPage(clientId: _clients[index].id),
//                 ),
//               );
//             },
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

// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:ventanas/models/diet.dart';
import 'package:ventanas/services/json_utils.dart';
import 'package:ventanas/tabs/edit_client_data_page.dart';
import 'package:ventanas/tabs/exercise_assignment_page.dart';
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
  List<Diet> _diets = [];

  @override
  void initState() {
    super.initState();
    _loadClients();
    _loadDiets();
  }

  Future<void> _loadClients() async {
    List<User> clients = await _userService.getAllUsers();
    setState(() {
      _clients = clients;
    });
  }

  Future<void> _loadDiets() async {
    List<Diet> diets = await JsonUtils.readDiets();
    setState(() {
      _diets = diets;
    });
  }

  Future<void> _deleteClient(String id) async {
    await _userService.deleteUser(id);
    _loadClients();
  }

  void _showClientOptions(User client) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Client Data'),
              onTap: () async {
                Navigator.pop(context);
                final updatedClient = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditClientDataPage(client: client),
                  ),
                );
                if (updatedClient != null) {
                  setState(() {
                    int index = _clients.indexWhere((c) => c.id == updatedClient.id);
                    if (index != -1) {
                      _clients[index] = updatedClient;
                    }
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Assign Exercises'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseAssignmentPage(clientId: client.id),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('Assign Diet'),
              onTap: () {
                Navigator.pop(context);
                _assignDiet(client);
              },
            ),
          ],
        );
      },
    );
  }

  void _assignDiet(User client) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Assign Diet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _diets.map((diet) {
              return ListTile(
                title: Text(diet.name),
                onTap: () async {
                  setState(() {
                    client.assignedDiets.add(diet);
                  });
                  await JsonUtils.updateUser(client);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
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
            onTap: () => _showClientOptions(client),
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
