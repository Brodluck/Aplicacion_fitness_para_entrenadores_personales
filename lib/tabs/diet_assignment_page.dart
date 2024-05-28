// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ventanas/models/diet.dart';
import 'package:ventanas/services/diet_service.dart';

class DietAssignmentPage extends StatefulWidget {
  final String clientId;

  const DietAssignmentPage({super.key, required this.clientId});

  @override
  _DietAssignmentPageState createState() => _DietAssignmentPageState();
}

class _DietAssignmentPageState extends State<DietAssignmentPage> {
  List<Diet> _diets = [];

  @override
  void initState() {
    super.initState();
    _loadDiets();
  }

  Future<void> _loadDiets() async {
    List<Diet> diets = await DietService().getAllDiets();
    setState(() {
      _diets = diets;
    });
  }

  Future<void> _assignDiet(Diet diet) async {
    await DietService().assignDietToClient(widget.clientId, diet);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Diet'),
      ),
      body: ListView.builder(
        itemCount: _diets.length,
        itemBuilder: (context, index) {
          Diet diet = _diets[index];
          return ListTile(
            title: Text(diet.name),
            subtitle: Text('Meals: ${diet.meals.join(', ')}'),
            onTap: () => _assignDiet(diet),
          );
        },
      ),
    );
  }
}
