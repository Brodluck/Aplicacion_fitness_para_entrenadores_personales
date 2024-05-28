// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:ventanas/models/user.dart';
import 'package:ventanas/services/json_utils.dart';

class EditClientDataPage extends StatefulWidget {
  final User client;

  const EditClientDataPage({super.key, required this.client});

  @override
  _EditClientDataPageState createState() => _EditClientDataPageState();
}

class _EditClientDataPageState extends State<EditClientDataPage> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String email;
  late String phoneNumber;
  late double weight;
  late double height;
  late double armCircumference;
  late double legCircumference;
  late double waistCircumference;
  late double backWidth;
  late double chestWidth;
  late double bodyFatPercentage;

  @override
  void initState() {
    super.initState();
    firstName = widget.client.firstName;
    lastName = widget.client.lastName;
    email = widget.client.email;
    phoneNumber = widget.client.phoneNumber;
    weight = widget.client.weight;
    height = widget.client.height;
    armCircumference = widget.client.armCircumference;
    legCircumference = widget.client.legCircumference;
    waistCircumference = widget.client.waistCircumference;
    backWidth = widget.client.backWidth;
    chestWidth = widget.client.chestWidth;
    bodyFatPercentage = widget.client.bodyFatPercentage;
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      User updatedClient = User(
        id: widget.client.id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: widget.client.password, // Keep the existing password
        phoneNumber: phoneNumber,
        photoUrl: widget.client.photoUrl, // Keep the existing photoUrl
        weight: weight,
        height: height,
        armCircumference: armCircumference,
        legCircumference: legCircumference,
        waistCircumference: waistCircumference,
        backWidth: backWidth,
        chestWidth: chestWidth,
        bodyFatPercentage: bodyFatPercentage,
        userType: widget.client.userType,
        assignedExercises: widget.client.assignedExercises,
        assignedDiets: widget.client.assignedDiets,
      );

      await JsonUtils.updateUser(updatedClient);
      Navigator.pop(context, updatedClient);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Client Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),
              TextFormField(
                initialValue: phoneNumber,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  phoneNumber = value!;
                },
              ),
              TextFormField(
                initialValue: weight.toString(),
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter weight';
                  }
                  return null;
                },
                onSaved: (value) {
                  weight = double.tryParse(value!) ?? 0.0;
                },
              ),
              TextFormField(
                initialValue: height.toString(),
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter height';
                  }
                  return null;
                },
                onSaved: (value) {
                  height = double.tryParse(value!) ?? 0.0;
                },
              ),
              TextFormField(
                initialValue: armCircumference.toString(),
                decoration: const InputDecoration(labelText: 'Arm Circumference (cm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter arm circumference';
                  }
                  return null;
                },
                onSaved: (value) {
                  armCircumference = double.tryParse(value!) ?? 0.0;
                },
              ),
              TextFormField(
                initialValue: legCircumference.toString(),
                decoration: const InputDecoration(labelText: 'Leg Circumference (cm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter leg circumference';
                  }
                  return null;
                },
                onSaved: (value) {
                  legCircumference = double.tryParse(value!) ?? 0.0;
                },
              ),
              TextFormField(
                initialValue: waistCircumference.toString(),
                decoration: const InputDecoration(labelText: 'Waist Circumference (cm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter waist circumference';
                  }
                  return null;
                },
                onSaved: (value) {
                  waistCircumference = double.tryParse(value!) ?? 0.0;
                },
              ),
              TextFormField(
                initialValue: backWidth.toString(),
                decoration: const InputDecoration(labelText: 'Back Width (cm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter back width';
                  }
                  return null;
                },
                onSaved: (value) {
                  backWidth = double.tryParse(value!) ?? 0.0;
                },
              ),
              TextFormField(
                initialValue: chestWidth.toString(),
                decoration: const InputDecoration(labelText: 'Chest Width (cm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter chest width';
                  }
                  return null;
                },
                onSaved: (value) {
                  chestWidth = double.tryParse(value!) ?? 0.0;
                },
              ),
              TextFormField(
                initialValue: bodyFatPercentage.toString(),
                decoration: const InputDecoration(labelText: 'Body Fat Percentage (%)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter body fat percentage';
                  }
                  return null;
                },
                onSaved: (value) {
                  bodyFatPercentage = double.tryParse(value!) ?? 0.0;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
