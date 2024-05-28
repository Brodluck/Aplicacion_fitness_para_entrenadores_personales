// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventanas/client_home_screen.dart';
import 'trainer_home_screen.dart';
import 'models/user.dart';
import 'services/json_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<Map<String, dynamic>?> _getUserByEmail(String email) async {
    await JsonUtils.synchronizeJson('data');
    try {
      Map<String, dynamic> data =
          await JsonUtils.readFromLocalJson('data');
      print('Data from JSON file: $data');
      if (data.containsKey('users')) {
        for (var userMap in data['users']) {
          if (userMap['email'] == email) {
            print('User found in JSON file: $userMap');
            return userMap;
          }
        }
      }
    } catch (e) {
      print("Error reading JSON file: $e");
    }
    return null;
  }

  Future<void> _signInWithEmail() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    Map<String, dynamic>? user = await _getUserByEmail(email);
    if (user != null) {
      String hashedPassword = PasswordUtils.hashPassword(password);
      print('Hashed input password: $hashedPassword');
      print('Stored user password: ${user['password']}');

      if (user['password'] == hashedPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );
        print('Login successful');

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String userType = user['userType'];
        final String userId = user['id'];
        prefs.setString('userType', userType);
        prefs.setString('userId', userId);

        if (userType == 'trainer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TrainerHomeScreen(trainerId: userId)), // Pass trainerId
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ClientHomeScreen(userId: userId)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid password')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInWithEmail,
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
