// import 'package:flutter/material.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';
// import 'package:ventanas/client_home_screen.dart';
// import 'package:ventanas/sign_up_page.dart';
// import 'package:ventanas/trainer_home_screen.dart';

// enum UserType { client, trainer, none }

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   LoginPageState createState() => LoginPageState();
// }

// class LoginPageState extends State<LoginPage> {
//   UserType _userType = UserType.none;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) => SingleChildScrollView(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(minHeight: constraints.maxHeight),
//             child: IntrinsicHeight(
//               child: Column(
//                 children: <Widget>[
//                   if (_userType != UserType.none)
//                     SafeArea(
//                       child: Align(
//                         alignment: Alignment.topLeft,
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: TextButton(
//                             onPressed: () => setState(() => _userType = UserType.none),
//                             child: const Row(
//                               mainAxisSize: MainAxisSize.min, // Ensures the row takes only as much width as needed
//                               children: [
//                                 Icon(Icons.arrow_back, size: 20.0), // Arrow icon
//                                 Text('Go back'),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   Expanded(
//                     child: Center(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         width: constraints.maxWidth > 600 ? 600 : constraints.maxWidth,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: <Widget>[
//                             _userType == UserType.none ? _buildRoleSelection() : _buildLoginForm(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRoleSelection() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           const Text(
//             'Welcome! \n Firstly, tell me who you are',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () => setState(() => _userType = UserType.client),
//             child: const Text('I am a Client'),
//           ),
//           ElevatedButton(
//             onPressed: () => setState(() => _userType = UserType.trainer),
//             child: const Text('I am a Trainer'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoginForm() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           TextFormField(
//             controller: _emailController,
//             decoration: const InputDecoration(labelText: 'Email'),
//             keyboardType: TextInputType.emailAddress,
//           ),
//           TextFormField(
//             controller: _passwordController,
//             decoration: const InputDecoration(labelText: 'Password'),
//             obscureText: true,
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             child: const Text('Login'),
//             onPressed: () {
//               if (_userType == UserType.trainer) {
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TrainerHomeScreen()));
//               } else {
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientHomeScreen()));
//               }
//             },
//           ),
//           const SizedBox(height: 20),
//            if (_userType == UserType.client) ...[
//             SignInButton(
//               Buttons.Google,
//               text: "Sign in with Google",
//               onPressed: () {
//                 // Implement Google sign-in logic
//               },
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpPage()));
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.green,
//               ),
//               child: const Text('Don’t have an account? Register here'),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }


// login_page.dart
// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, avoid_print

//2ND try

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';
// import 'package:ventanas/client_home_screen.dart';
// import 'package:ventanas/sign_up_page.dart';
// import 'package:ventanas/trainer_home_screen.dart';

// enum UserType { client, trainer, none }

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   UserType _userType = UserType.none;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) => SingleChildScrollView(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(minHeight: constraints.maxHeight),
//             child: IntrinsicHeight(
//               child: Column(
//                 children: <Widget>[
//                   if (_userType != UserType.none)
//                     SafeArea(
//                       child: Align(
//                         alignment: Alignment.topLeft,
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: TextButton(
//                             onPressed: () => setState(() => _userType = UserType.none),
//                             child: const Row(
//                               mainAxisSize: MainAxisSize.min, // Ensures the row takes only as much width as needed
//                               children: [
//                                 Icon(Icons.arrow_back, size: 20.0), // Arrow icon
//                                 Text('Go back'),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   Expanded(
//                     child: Center(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         width: constraints.maxWidth > 600 ? 600 : constraints.maxWidth,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: <Widget>[
//                             _userType == UserType.none ? _buildRoleSelection() : _buildLoginForm(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRoleSelection() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           const Text(
//             'Welcome! \n Firstly, tell me who you are',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () => setState(() => _userType = UserType.client),
//             child: const Text('I am a Client'),
//           ),
//           ElevatedButton(
//             onPressed: () => setState(() => _userType = UserType.trainer),
//             child: const Text('I am a Trainer'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoginForm() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           TextFormField(
//             controller: _emailController,
//             decoration: const InputDecoration(labelText: 'Email'),
//             keyboardType: TextInputType.emailAddress,
//           ),
//           TextFormField(
//             controller: _passwordController,
//             decoration: const InputDecoration(labelText: 'Password'),
//             obscureText: true,
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _signIn,
//             child: const Text('Login'),
//           ),
//           const SizedBox(height: 20),
//           if (_userType == UserType.client) ...[
//             SignInButton(
//               Buttons.Google,
//               text: "Sign in with Google",
//               onPressed: () {
//                 // Implement Google sign-in logic
//               },
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpPage()));
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.green,
//               ),
//               child: const Text('Don’t have an account? Register here'),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Future<void> _signIn() async {
//     try {
//       await _auth.signInWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );
//       if (_userType == UserType.trainer) {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TrainerHomeScreen()));
//       } else {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientHomeScreen()));
//       }
//     } catch (e) {
//       // Handle error
//       print(e);
//     }
//   }
// }

//3rd try
// import 'package:flutter/material.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ventanas/client_home_screen.dart';
// import 'client_management_page.dart';
// import 'models/user.dart';
// import 'services/json_utils.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   LoginPageState createState() => LoginPageState();
// }

// class LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   Future<void> _downloadJsonFromCloud() async {
//     try {
//       await JsonUtils.downloadJsonFromFirebase();
//       print('File downloaded from cloud storage.');
//     } catch (e) {
//       print('Error downloading file: $e');
//     }
//   }

//   Future<Map<String, dynamic>?> _getUserByEmail(String email) async {
//     var connectivityResult = await Connectivity().checkConnectivity(); // Check connectivity
//     bool connected = connectivityResult != ConnectivityResult.none;

//     if (connected) {
//       print('Connected to the internet. Downloading file from cloud storage.');
//       await _downloadJsonFromCloud();
//     } else {
//       print('No internet connection. Using local JSON file.');
//     }

//     try {
//       Map<String, dynamic> data = await JsonUtils.readFromLocalJson();
//       if (data.containsKey('users')) {
//         for (var userMap in data['users']) {
//           if (userMap['email'] == email) {
//             print('User found in JSON file: $userMap'); // Debugging statement
//             return userMap;
//           }
//         }
//       }
//     } catch (e) {
//       print("Error reading JSON file: $e");
//     }
//     return null;
//   }

//   Future<void> _signInWithEmail() async {
//     String email = _emailController.text;
//     String password = _passwordController.text;

//     Map<String, dynamic>? user = await _getUserByEmail(email);
//     if (user != null) {
//       String hashedPassword = PasswordUtils.hashPassword(password);
//       print('Hashed input password: $hashedPassword'); // Debugging statement
//       print('Stored user password: ${user['password']}'); // Debugging statement
      
//       if (user['password'] == hashedPassword) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Login successful')),
//         );
//         print('Login successful'); // Debugging statement

//         final SharedPreferences prefs = await SharedPreferences.getInstance();
//         final String userType = user['userType']; // Get the user type from the user data
//         prefs.setString('userType', userType);

//         if (userType == 'trainer') {
//           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ClientManagementPage()));
//         } else {
//           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientHomeScreen()));
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Invalid password')),
//         );
//         print('Invalid password'); // Debugging statement
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User not found')),
//       );
//       print('User not found'); // Debugging statement
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _signInWithEmail,
//               child: const Text('Sign in with Email'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


//4th try
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventanas/client_home_screen.dart';
import 'trainer_home_screen.dart'; // Ensure this is imported
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
    await JsonUtils.synchronizeJson();

    try {
      Map<String, dynamic> data = await JsonUtils.readFromLocalJson();
      if (data.containsKey('users')) {
        for (var userMap in data['users']) {
          if (userMap['email'] == email) {
            print('User found in JSON file: $userMap'); // Debugging statement
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
      print('Hashed input password: $hashedPassword'); // Debugging statement
      print('Stored user password: ${user['password']}'); // Debugging statement
      
      if (user['password'] == hashedPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );
        print('Login successful'); // Debugging statement

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String userType = user['userType']; // Get the user type from the user data
        prefs.setString('userType', userType);

        if (userType == 'trainer') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TrainerHomeScreen()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientHomeScreen()));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid password')),
        );
        print('Invalid password'); // Debugging statement
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found')),
      );
      print('User not found'); // Debugging statement
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
              child: const Text('Sign in with Email'),
            ),
          ],
        ),
      ),
    );
  }
}
