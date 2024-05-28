import 'package:flutter/material.dart';
import 'package:ventanas/models/diet.dart';
import 'package:ventanas/models/user.dart';
import 'package:ventanas/services/json_utils.dart';

class DietingTab extends StatelessWidget {
  final String clientId;

  const DietingTab({super.key, required this.clientId});

  Future<List<Diet>> _loadClientDiets() async {
    // Load all diets
    List<Diet> allDiets = await JsonUtils.readDiets();

    // Load client data
    User? client = await JsonUtils.getUserById(clientId);
    if (client == null) {
      return [];
    }

    // Filter diets to only include those assigned to the client
    List<Diet> clientDiets = allDiets
        .where((diet) => client.assignedDiets.any((assigned) => assigned.id == diet.id))
        .toList();

    return clientDiets;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Diet>>(
      future: _loadClientDiets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading diets'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No diets found'));
        } else {
          final diets = snapshot.data!;
          return ListView.builder(
            itemCount: diets.length,
            itemBuilder: (context, index) {
              final diet = diets[index];
              return ListTile(
                title: Text(diet.name),
                subtitle: Text(diet.description),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DietDetailPage(diet: diet),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

class DietDetailPage extends StatelessWidget {
  final Diet diet;

  const DietDetailPage({super.key, required this.diet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(diet.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(diet.description, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Foods:'),
              ...diet.foods.map((food) => Text('- $food')),
            ],
          ),
        ),
      ),
    );
  }
}
