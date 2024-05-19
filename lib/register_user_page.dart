// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'models/user.dart';

// class RegisterUserPage extends StatefulWidget {
//   const RegisterUserPage({super.key});

//   @override
//   _RegisterUserPageState createState() => _RegisterUserPageState();
// }

// class _RegisterUserPageState extends State<RegisterUserPage> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneNumberController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//   final TextEditingController _armCircumferenceController = TextEditingController();
//   final TextEditingController _legCircumferenceController = TextEditingController();
//   final TextEditingController _waistCircumferenceController = TextEditingController();
//   final TextEditingController _backWidthController = TextEditingController();
//   final TextEditingController _chestWidthController = TextEditingController();
//   final TextEditingController _bodyFatPercentageController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   Future<String> _localPath() async {
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }

//   Future<File> _localFile() async {
//     final path = await _localPath();
//     return File('$path/users.csv');
//   }

//   Future<void> _writeUserToFile(User user) async {
//     final file = await _localFile();
//     String csvRow = '${user.id},${user.firstName},${user.lastName},${user.email},${user.phoneNumber},${user.photoUrl},${user.weight},${user.height},${user.armCircumference},${user.legCircumference},${user.waistCircumference},${user.backWidth},${user.chestWidth},${user.bodyFatPercentage},${user.password}\n';
//     await file.writeAsString(csvRow, mode: FileMode.append);
//     await _uploadFileToCloud(file);
//   }

//   Future<void> _uploadFileToCloud(File file) async {
//     try {
//       final storageRef = FirebaseStorage.instance.ref().child('users.csv');
//       await storageRef.putFile(file);
//     } catch (e) {
//       print('Error uploading file: $e');
//     }
//   }

//   Future<void> _registerUser() async {
//     if (_formKey.currentState!.validate()) {
//       String hashedPassword = User.hashPassword(_passwordController.text);
      
//       User newUser = User(
//         id: const Uuid().v4(),
//         firstName: _firstNameController.text,
//         lastName: _lastNameController.text,
//         email: _emailController.text,
//         phoneNumber: _phoneNumberController.text,
//         photoUrl: '',
//         weight: double.tryParse(_weightController.text) ?? 0.0,
//         height: double.tryParse(_heightController.text) ?? 0.0,
//         armCircumference: double.tryParse(_armCircumferenceController.text) ?? 0.0,
//         legCircumference: double.tryParse(_legCircumferenceController.text) ?? 0.0,
//         waistCircumference: double.tryParse(_waistCircumferenceController.text) ?? 0.0,
//         backWidth: double.tryParse(_backWidthController.text) ?? 0.0,
//         chestWidth: double.tryParse(_chestWidthController.text) ?? 0.0,
//         bodyFatPercentage: double.tryParse(_bodyFatPercentageController.text) ?? 0.0,
//         password: hashedPassword,
//         userType: 'client',
//       );

//       await _writeUserToFile(newUser);
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User registered successfully')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Register User'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _firstNameController,
//                 decoration: const InputDecoration(labelText: 'First Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter first name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _lastNameController,
//                 decoration: const InputDecoration(labelText: 'Last Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter last name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter email';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _phoneNumberController,
//                 decoration: const InputDecoration(labelText: 'Phone Number'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter phone number';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _weightController,
//                 decoration: const InputDecoration(labelText: 'Weight (kg)'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter weight';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _heightController,
//                 decoration: const InputDecoration(labelText: 'Height (cm)'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter height';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _armCircumferenceController,
//                 decoration: const InputDecoration(labelText: 'Arm Circumference (cm)'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter arm circumference';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _legCircumferenceController,
//                 decoration: const InputDecoration(labelText: 'Leg Circumference (cm)'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter leg circumference';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _waistCircumferenceController,
//                 decoration: const InputDecoration(labelText: 'Waist Circumference (cm)'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter waist circumference';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _backWidthController,
//                 decoration: const InputDecoration(labelText: 'Back Width (cm)'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter back width';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _chestWidthController,
//                 decoration: const InputDecoration(labelText: 'Chest Width (cm)'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter chest width';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _bodyFatPercentageController,
//                 decoration: const InputDecoration(labelText: 'Body Fat Percentage (%)'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter body fat percentage';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(labelText: 'Password'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter password';
//                   }
//                   return null;
//                 },
//                 obscureText: true,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _registerUser,
//                 child: const Text('Register User'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//register_user_page.dart
// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:csv/csv.dart';
// import 'models/user.dart';

// class RegisterUserPage extends StatefulWidget {
//   const RegisterUserPage({super.key});

//   @override
//   _RegisterUserPageState createState() => _RegisterUserPageState();
// }

// class _RegisterUserPageState extends State<RegisterUserPage> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneNumberController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//   final TextEditingController _armCircumferenceController = TextEditingController();
//   final TextEditingController _legCircumferenceController = TextEditingController();
//   final TextEditingController _waistCircumferenceController = TextEditingController();
//   final TextEditingController _backWidthController = TextEditingController();
//   final TextEditingController _chestWidthController = TextEditingController();
//   final TextEditingController _bodyFatPercentageController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();

//   String? _emailError;

//   Future<String> _localPath() async {
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }

//   Future<File> _localFile() async {
//     final path = await _localPath();
//     return File('$path/users.csv');
//   }

//   Future<void> _writeUserToFile(User user) async {
//     final file = await _localFile();
//     String csvRow = '${user.id},${user.firstName},${user.lastName},${user.email},${user.phoneNumber},${user.photoUrl},${user.weight},${user.height},${user.armCircumference},${user.legCircumference},${user.waistCircumference},${user.backWidth},${user.chestWidth},${user.bodyFatPercentage},${user.password},${user.userType}\n';
//     await file.writeAsString(csvRow, mode: FileMode.append);
//     await _uploadFileToCloud(file);
//   }

//   Future<void> _uploadFileToCloud(File file) async {
//     try {
//       final storageRef = FirebaseStorage.instance.ref().child('users.csv');
//       await storageRef.putFile(file);
//     } catch (e) {
//       print('Error uploading file: $e');
//     }
//   }

//   Future<bool> _emailExists(String email) async {
//     final file = await _localFile();
//     if (!await file.exists()) return false;

//     final csvString = await file.readAsString();
//     List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);

//     for (var row in rowsAsListOfValues) {
//       if (row.length > 3 && row[3] == email) {
//         return true;
//       }
//     }
//     return false;
//   }

//   Future<void> _registerUser() async {
//     setState(() {
//       _emailError = null;
//     });

//     if (_formKey.currentState!.validate()) {
//       if (await _emailExists(_emailController.text)) {
//         setState(() {
//           _emailError = 'Email already exists';
//         });
//         return;
//       }

//       String hashedPassword = User.hashPassword(_passwordController.text);

//       User newUser = User(
//         id: const Uuid().v4(),
//         firstName: _firstNameController.text,
//         lastName: _lastNameController.text,
//         email: _emailController.text,
//         phoneNumber: _phoneNumberController.text,
//         photoUrl: '',
//         weight: double.tryParse(_weightController.text) ?? 0.0,
//         height: double.tryParse(_heightController.text) ?? 0.0,
//         armCircumference: double.tryParse(_armCircumferenceController.text) ?? 0.0,
//         legCircumference: double.tryParse(_legCircumferenceController.text) ?? 0.0,
//         waistCircumference: double.tryParse(_waistCircumferenceController.text) ?? 0.0,
//         backWidth: double.tryParse(_backWidthController.text) ?? 0.0,
//         chestWidth: double.tryParse(_chestWidthController.text) ?? 0.0,
//         bodyFatPercentage: double.tryParse(_bodyFatPercentageController.text) ?? 0.0,
//         password: hashedPassword,
//         userType: 'client',
//       );

//       await _writeUserToFile(newUser);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User registered successfully')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Register User'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _firstNameController,
//                 decoration: const InputDecoration(labelText: 'First Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter first name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _lastNameController,
//                 decoration: const InputDecoration(labelText: 'Last Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter last name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   errorText: _emailError,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter email';
//                   }
//                   final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
//                   if (!emailRegex.hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(labelText: 'Password'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter password';
//                   }
//                   return null;
//                 },
//                 obscureText: true,
//               ),
//               TextFormField(
//                 controller: _confirmPasswordController,
//                 decoration: const InputDecoration(labelText: 'Confirm Password'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please confirm your password';
//                   }
//                   if (value != _passwordController.text) {
//                     return 'Passwords do not match';
//                   }
//                   return null;
//                 },
//                 obscureText: true,
//               ),
//               TextFormField(
//                 controller: _phoneNumberController,
//                 decoration: const InputDecoration(labelText: 'Phone Number'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter phone number';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _weightController,
//                 decoration: const InputDecoration(labelText: 'Weight (kg)'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter weight';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _heightController,
//                 decoration: const InputDecoration(labelText: 'Height (cm)'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter height';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _armCircumferenceController,
//                 decoration: const InputDecoration(labelText: 'Arm Circumference (cm)'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter arm circumference';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _legCircumferenceController,
//                 decoration: const InputDecoration(labelText: 'Leg Circumference (cm)'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter leg circumference';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _waistCircumferenceController,
//                 decoration: const InputDecoration(labelText: 'Waist Circumference (cm)'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter waist circumference';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _backWidthController,
//                 decoration: const InputDecoration(labelText: 'Back Width (cm)'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter back width';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _chestWidthController,
//                 decoration: const InputDecoration(labelText: 'Chest Width (cm)'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter chest width';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _bodyFatPercentageController,
//                 decoration: const InputDecoration(labelText: 'Body Fat Percentage (%)'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter body fat percentage';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(labelText: 'Password'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter password';
//                   }
//                   return null;
//                 },
//                 obscureText: true,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _registerUser,
//                 child: const Text('Register User'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../services/json_utils.dart';
import 'client_management_page.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({super.key});

  @override
  _RegisterUserPageState createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _armCircumferenceController = TextEditingController();
  final TextEditingController _legCircumferenceController = TextEditingController();
  final TextEditingController _waistCircumferenceController = TextEditingController();
  final TextEditingController _backWidthController = TextEditingController();
  final TextEditingController _chestWidthController = TextEditingController();
  final TextEditingController _bodyFatPercentageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _emailError;

  Future<void> _writeUserToFile(User user) async {
    List<User> users = [];
    try {
      Map<String, dynamic> data = await JsonUtils.readFromLocalJson();
      if (data.containsKey('users')) {
        users = (data['users'] as List).map((userMap) => User.fromMap(userMap)).toList();
      }
    } catch (e) {
      print('Error reading JSON file: $e');
    }
    users.add(user);
    Map<String, dynamic> data = {'users': users.map((user) => user.toMap()).toList()};
    await JsonUtils.saveToLocalJson(data);
    await JsonUtils.uploadJsonToFirebase();
  }

  Future<bool> _emailExists(String email) async {
    try {
      Map<String, dynamic> data = await JsonUtils.readFromLocalJson();
      if (data.containsKey('users')) {
        List<User> users = (data['users'] as List).map((userMap) => User.fromMap(userMap)).toList();
        for (var user in users) {
          if (user.email == email) {
            return true;
          }
        }
      }
    } catch (e) {
      print('Error reading JSON file: $e');
    }
    return false;
  }

  Future<void> _registerUser() async {
    setState(() {
      _emailError = null;
    });

    if (_formKey.currentState!.validate()) {
      if (await _emailExists(_emailController.text)) {
        setState(() {
          _emailError = 'Email already exists';
        });
        return;
      }

      String hashedPassword = PasswordUtils.hashPassword(_passwordController.text);

      User newUser = User(
        id: const Uuid().v4(),
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneNumberController.text,
        photoUrl: '',
        weight: double.tryParse(_weightController.text) ?? 0.0,
        height: double.tryParse(_heightController.text) ?? 0.0,
        armCircumference: double.tryParse(_armCircumferenceController.text) ?? 0.0,
        legCircumference: double.tryParse(_legCircumferenceController.text) ?? 0.0,
        waistCircumference: double.tryParse(_waistCircumferenceController.text) ?? 0.0,
        backWidth: double.tryParse(_backWidthController.text) ?? 0.0,
        chestWidth: double.tryParse(_chestWidthController.text) ?? 0.0,
        bodyFatPercentage: double.tryParse(_bodyFatPercentageController.text) ?? 0.0,
        password: hashedPassword,
        userType: 'client',
      );

      await _writeUserToFile(newUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User registered successfully')),
      );

      // Redirect to ClientManagementPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ClientManagementPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: _emailError,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
                obscureText: true,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                obscureText: true,
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter weight';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter height';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _armCircumferenceController,
                decoration: const InputDecoration(labelText: 'Arm Circumference (cm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter arm circumference';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _legCircumferenceController,
                decoration: const InputDecoration(labelText: 'Leg Circumference (cm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter leg circumference';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _waistCircumferenceController,
                decoration: const InputDecoration(labelText: 'Waist Circumference (cm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter waist circumference';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _backWidthController,
                decoration: const InputDecoration(labelText: 'Back Width (cm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter back width';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _chestWidthController,
                decoration: const InputDecoration(labelText: 'Chest Width (cm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter chest width';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bodyFatPercentageController,
                decoration: const InputDecoration(labelText: 'Body Fat Percentage (%)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter body fat percentage';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Register User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
