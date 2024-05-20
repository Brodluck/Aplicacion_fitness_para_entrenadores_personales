// additional_info_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ventanas/services/firestore_service.dart'; // Update the import path as necessary

class AdditionalInfoPage extends StatefulWidget {
  const AdditionalInfoPage({super.key});

  @override
  _AdditionalInfoPageState createState() => _AdditionalInfoPageState();
}

class _AdditionalInfoPageState extends State<AdditionalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _armCircumferenceController = TextEditingController();
  final TextEditingController _waistCircumferenceController = TextEditingController();
  final TextEditingController _legCircumferenceController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _takePicture() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> _saveUserInfo() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Map<String, dynamic> userInfo = {
          'weight': _weightController.text,
          'height': _heightController.text,
          'armCircumference': _armCircumferenceController.text,
          'waistCircumference': _waistCircumferenceController.text,
          'legCircumference': _legCircumferenceController.text,
        };
        try {
          await _firestoreService.addUserInfo(user.uid, userInfo);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ConfirmationPage()),
          );
        } catch (e) {
          print('Error saving user info: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save information. Please try again.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Additional Information'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Wrap(
                          children: <Widget>[
                            ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text('Photo Library'),
                                onTap: () {
                                  _pickImage();
                                  Navigator.of(context).pop();
                                }),
                            ListTile(
                              leading: const Icon(Icons.photo_camera),
                              title: const Text('Camera'),
                              onTap: () {
                                _takePicture();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Text('Upload Photograph'),
              ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Image.file(File(_image!.path)),
                ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _armCircumferenceController,
                decoration: const InputDecoration(labelText: 'Arm Circumference (cm)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _waistCircumferenceController,
                decoration: const InputDecoration(labelText: 'Waist Circumference (cm)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _legCircumferenceController,
                decoration: const InputDecoration(labelText: 'Leg Circumference (cm)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUserInfo,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
      ),
      body: const Center(
        child: Text('Your information has been successfully submitted.'),
      ),
    );
  }
}
