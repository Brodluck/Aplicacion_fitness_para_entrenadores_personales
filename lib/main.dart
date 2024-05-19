// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:ventanas/client_home_screen.dart';
// // import 'package:ventanas/login_page.dart';
// // import 'package:ventanas/trainer_home_screen.dart';
// // import 'app_state.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return ChangeNotifierProvider<AppState>(
// //       create: (_) => AppState(),
// //       child: MaterialApp(
// //         title: 'Fitness App',
// //         theme: darkTheme, // Apply the dark theme here
// //         home: const LoginPage(), // Start with the LoginPage
// //         debugShowCheckedModeBanner: false,
// //       ),
// //     );
// //   }

// // }

// // void checkUserSession() async {
// //   final SharedPreferences prefs = await SharedPreferences.getInstance();
// //   final String? userType = prefs.getString('userType');

// //   if (userType != null) {
// //     if (userType == 'trainer') {
// //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TrainerHomeScreen()));
// //     } else if (userType == 'client') {
// //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientHomeScreen()));
// //     }
// //   }
// // }

// // ThemeData darkTheme = ThemeData(
// //   useMaterial3: true, // Enables Material 3
// //   brightness: Brightness.dark,
// //   colorScheme: ColorScheme.fromSeed(
// //     seedColor: Colors.blue, // Replace with your primary color
// //     brightness: Brightness.dark,
// //   ),
// //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
// //     backgroundColor: Colors.grey[900],
// //     selectedItemColor: Colors.white,
// //     unselectedItemColor: Colors.white70,
// //   ),
// //   textTheme: const TextTheme(
// //     bodyLarge: TextStyle(color: Colors.white),
// //     // bodyLarge2: TextStyle(color: Colors.white70),
// //   ),
// //   // Add other theming attributes as necessary
// // );

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ventanas/client_home_screen.dart';
// import 'package:ventanas/login_page.dart';
// import 'package:ventanas/trainer_home_screen.dart';
// import 'app_state.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   MyAppState createState() => MyAppState();
// }

// class MyAppState extends State<MyApp> {
//   // Initialize a widget to display while determining the initial route.
//   Widget _initialRoute = const LoginPage();

//   @override
//   void initState() {
//     super.initState();
//     checkUserSession();
//   }

//   void checkUserSession() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? userType = prefs.getString('userType');

//     Widget nextPage = const LoginPage(); // Default to login page if no user session.

//     if (userType != null) {
//       if (userType == 'trainer') {
//         nextPage = TrainerHomeScreen();
//       } else if (userType == 'client') {
//         nextPage = ClientHomeScreen();
//       }
//     }

//     setState(() {
//       _initialRoute = nextPage;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<AppState>(
//       create: (_) => AppState(),
//       child: MaterialApp(
//         title: 'Fitness App',
//         theme: darkTheme,
//         home: _initialRoute, // Use the dynamically determined initial route.
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }

// ThemeData darkTheme = ThemeData(
//   useMaterial3: true,
//   brightness: Brightness.dark,
//   colorScheme: ColorScheme.fromSeed(
//     seedColor: Colors.blue,
//     brightness: Brightness.dark,
//   ),
//   bottomNavigationBarTheme: BottomNavigationBarThemeData(
//     backgroundColor: Colors.grey[900],
//     selectedItemColor: Colors.white,
//     unselectedItemColor: Colors.white70,
//   ),
//   textTheme: const TextTheme(
//     bodyLarge: TextStyle(color: Colors.white),
//   ),
// );

// ignore_for_file: unused_element, avoid_print, use_build_context_synchronously
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'client_management_page.dart';
// import 'login_page.dart';
// import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'User Management Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const AuthWrapper(),
//     );
//   }
// }

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           User? user = snapshot.data;
//           if (user == null) {
//             return const LoginPage();
//           } else {
//             return const ClientManagementPage();
//           }
//         } else {
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//       },
//     );
//   }
// }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:ventanas/tabs/dashboard_tab.dart';
// import 'package:ventanas/tabs/trainer_dashboard_tab.dart';
// import 'client_management_page.dart';
// import 'models/user.dart';
// import 'login_page.dart';
// import 'register_user_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await createDefaultTrainerUser();
//   runApp(const MyApp());
// }

// Future<String> _localPath() async {
//   final directory = await getApplicationDocumentsDirectory();
//   print('Directory: ${directory.path}');
//   return directory.path;
// }

// Future<File> _localFile() async {
//   final path = await _localPath();
//   final file = File('$path/users.csv');
//   print('CSV File Path: ${file.path}');
//   return file;
// }

// Future<void> _uploadFileToCloud(File file) async {
//   try {
//     final storageRef = FirebaseStorage.instance.ref().child('users.csv');
//     await storageRef.putFile(file);
//     print('File uploaded to cloud storage.');
//   } catch (e) {
//     print('Error uploading file: $e');
//   }
// }

// Future<void> createDefaultTrainerUser() async {
//   final file = await _localFile();
//   bool fileExists = await file.exists();
//   print('File exists: $fileExists');
//   bool userExists = false;

//   if (fileExists) {
//     print('CSV file exists.');
//     List<String> lines = await file.readAsLines();
//     if (lines.isNotEmpty) {
//       userExists = true;
//     }
//   } else {
//     print('CSV file does not exist. Creating a new one.');
//   }

//   if (!userExists) {
//     print('No users found. Creating a default trainer user.');
//     String defaultPassword = Trainer.hashPassword('defaultTrainerPassword');
//     Trainer defaultTrainer = Trainer(
//       id: const Uuid().v4(),
//       firstName: 'Default',
//       lastName: 'Trainer',
//       email: 'trainer@example.com',
//       phoneNumber: '123456789',
//       photoUrl: '',
//       password: defaultPassword,
//     );

//     String csvRow = '${defaultTrainer.id},${defaultTrainer.firstName},${defaultTrainer.lastName},${defaultTrainer.email},${defaultTrainer.phoneNumber},${defaultTrainer.photoUrl},${defaultTrainer.password},${defaultTrainer.userType}\n';
//     await file.writeAsString(csvRow, mode: FileMode.append);
//     print('Default trainer user added to CSV file. Content: $csvRow');
//     await _uploadFileToCloud(file);
//   } else {
//       print('DefaultTrainer already exist in the CSV file.');
//       List<String> lines = await file.readAsLines();
//       print('Current users in the CSV file:');
//       lines.forEach(print); // Print each line (each user) in the CSV file
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<AppState>(
//       create: (_) => AppState(),
//       child: MaterialApp(
//         title: 'Fitness App',
//         theme: darkTheme, // Apply the dark theme here
//         home: const LoginPage(), // Start with the LoginPage
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }

// class AppState extends ChangeNotifier {
//   // Add your app state logic here if needed
// }

// ThemeData darkTheme = ThemeData(
//   useMaterial3: true, // Enables Material 3
//   brightness: Brightness.dark,
//   colorScheme: ColorScheme.fromSeed(
//     seedColor: Colors.blue, // Replace with your primary color
//     brightness: Brightness.dark,
//   ),
//   bottomNavigationBarTheme: BottomNavigationBarThemeData(
//     backgroundColor: Colors.grey[900],
//     selectedItemColor: Colors.white,
//     unselectedItemColor: Colors.white70,
//   ),
//   textTheme: const TextTheme(
//     bodyLarge: TextStyle(color: Colors.white),
//     // bodyLarge2: TextStyle(color: Colors.white70),
//   ),
//   // Add other theming attributes as necessary
// );

// void checkUserSession(BuildContext context) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final String? userType = prefs.getString('userType');

//   if (userType != null) {
//     if (userType == 'trainer') {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ClientManagementPage()));
//     } else if (userType == 'client') {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardTab()));
//     }
//   }
// }


//main.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'client_management_page.dart';
// import 'models/user.dart';
// import 'login_page.dart';
// import 'tabs/dashboard_tab.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await createDefaultTrainerUser();
//   runApp(const MyApp());
// }

// Future<String> _localPath() async {
//   final directory = await getExternalStorageDirectory();
//   return directory!.path;
// }

// Future<File> _localFile() async {
//   final path = await _localPath();
//   final file = File('$path/users.csv');
//   print('CSV File Path: ${file.path}');
//   return file;
// }

// Future<void> _uploadFileToCloud(File file) async {
//   try {
//     final storageRef = FirebaseStorage.instance.ref().child('users.csv');
//     await storageRef.putFile(file);
//     print('File uploaded to cloud storage.');
//   } catch (e) {
//     print('Error uploading file: $e');
//   }
// }

// Future<void> createDefaultTrainerUser() async {
//   final file = await _localFile();
//   bool fileExists = await file.exists();
//   print('File exists: $fileExists');
//   bool userExists = false;

//   if (fileExists) {
//     print('CSV file exists.');
//     List<String> lines = await file.readAsLines();
//     if (lines.isNotEmpty) {
//       userExists = true;
//     }
//   } else {
//     print('CSV file does not exist. Creating a new one.');
//     String headerComment = '# id,firstName,lastName,email,phoneNumber,photoUrl,weight,height,armCircumference,legCircumference,waistCircumference,backWidth,chestWidth,bodyFatPercentage,password,userType\n';
//     await file.writeAsString(headerComment, mode: FileMode.append);
//   }

//   if (!userExists) {
//     print('No users found. Creating a default trainer user.');
//     String defaultPassword = User.hashPassword('defaultTrainerPassword');
//     User defaultTrainer = User(
//       id: const Uuid().v4(),
//       firstName: 'Default',
//       lastName: 'Trainer',
//       email: 'trainer@example.com',
//       phoneNumber: '123456789',
//       photoUrl: '',
//       weight: 0.0,
//       height: 0.0,
//       armCircumference: 0.0,
//       legCircumference: 0.0,
//       waistCircumference: 0.0,
//       backWidth: 0.0,
//       chestWidth: 0.0,
//       bodyFatPercentage: 0.0,
//       password: defaultPassword,
//       userType: 'trainer',
//     );

//     String csvRow = '${defaultTrainer.id},${defaultTrainer.firstName},${defaultTrainer.lastName},${defaultTrainer.email},${defaultTrainer.phoneNumber},${defaultTrainer.photoUrl},${defaultTrainer.weight},${defaultTrainer.height},${defaultTrainer.armCircumference},${defaultTrainer.legCircumference},${defaultTrainer.waistCircumference},${defaultTrainer.backWidth},${defaultTrainer.chestWidth},${defaultTrainer.bodyFatPercentage},${defaultTrainer.password},${defaultTrainer.userType}\n';
//     await file.writeAsString(csvRow, mode: FileMode.append);
//     print('Default trainer user added to CSV file. Content: $csvRow');
//     await _uploadFileToCloud(file);
//   } else {
//     print('DefaultTrainer already exists in the CSV file.');
//     List<String> lines = await file.readAsLines();
//     print('Current users in the CSV file:');
//     lines.forEach(print); // Print each line (each user) in the CSV file
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<AppState>(
//       create: (_) => AppState(),
//       child: MaterialApp(
//         title: 'Fitness App',
//         theme: darkTheme, // Apply the dark theme here
//         home: const LoginPage(), // Start with the LoginPage
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }

// class AppState extends ChangeNotifier {
//   // Add your app state logic here if needed
// }

// ThemeData darkTheme = ThemeData(
//   useMaterial3: true, // Enables Material 3
//   brightness: Brightness.dark,
//   colorScheme: ColorScheme.fromSeed(
//     seedColor: Colors.blue, // Replace with your primary color
//     brightness: Brightness.dark,
//   ),
//   bottomNavigationBarTheme: BottomNavigationBarThemeData(
//     backgroundColor: Colors.grey[900],
//     selectedItemColor: Colors.white,
//     unselectedItemColor: Colors.white70,
//   ),
//   textTheme: const TextTheme(
//     bodyLarge: TextStyle(color: Colors.white),
//     // bodyLarge2: TextStyle(color: Colors.white70),
//   ),
//   // Add other theming attributes as necessary
// );

// void checkUserSession(BuildContext context) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final String? userType = prefs.getString('userType');

//   if (userType != null) {
//     if (userType == 'trainer') {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ClientManagementPage()));
//     } else if (userType == 'client') {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardTab()));
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'models/user.dart';
// import 'login_page.dart';
// import 'tabs/dashboard_tab.dart';
// import 'services/json_utils.dart'; // Import json_utils
// import 'trainer_home_screen.dart'; // Import TrainerHomeScreen

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await JsonUtils.synchronizeJson(); // Ensure synchronization
//   await createDefaultTrainerUser();
//   runApp(const MyApp());
// }

// Future<void> createDefaultTrainerUser() async {
//   bool userExists = false;

//   try {
//     Map<String, dynamic> data = await JsonUtils.readFromLocalJson();
//     if (data.containsKey('users') && (data['users'] as List).isNotEmpty) {
//       userExists = true;
//     }
//   } catch (e) {
//     print('Error reading JSON file: $e');
//   }

//   if (!userExists) {
//     print('No users found. Creating a default trainer user.');
//     String defaultPassword = PasswordUtils.hashPassword('defaultTrainerPassword');
//     User defaultTrainer = User(
//       id: const Uuid().v4(),
//       firstName: 'Default',
//       lastName: 'Trainer',
//       email: 'trainer@example.com',
//       phoneNumber: '123456789',
//       photoUrl: '',
//       weight: 0.0,
//       height: 0.0,
//       armCircumference: 0.0,
//       legCircumference: 0.0,
//       waistCircumference: 0.0,
//       backWidth: 0.0,
//       chestWidth: 0.0,
//       bodyFatPercentage: 0.0,
//       password: defaultPassword,
//       userType: 'trainer',
//     );

//     Map<String, dynamic> data = {'users': [defaultTrainer.toMap()]};
//     await JsonUtils.saveToLocalJson(data);
//     await JsonUtils.uploadJsonToFirebase();
//     print('Default trainer user added to JSON file.');
//   } else {
//     print('DefaultTrainer already exists in the JSON file.');
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<AppState>(
//       create: (_) => AppState(),
//       child: MaterialApp(
//         title: 'Fitness App',
//         theme: darkTheme, // Apply the dark theme here
//         home: const LoginPage(), // Start with the LoginPage
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }

// class AppState extends ChangeNotifier {
//   int _selectedIndex = 0;

//   int get selectedIndex => _selectedIndex;

//   void setIndex(int index) {
//     _selectedIndex = index;
//     notifyListeners();
//   }
// }

// ThemeData darkTheme = ThemeData(
//   useMaterial3: true, // Enables Material 3
//   brightness: Brightness.dark,
//   colorScheme: ColorScheme.fromSeed(
//     seedColor: Colors.blue, // Replace with your primary color
//     brightness: Brightness.dark,
//   ),
//   bottomNavigationBarTheme: BottomNavigationBarThemeData(
//     backgroundColor: Colors.grey[900],
//     selectedItemColor: Colors.white,
//     unselectedItemColor: Colors.white70,
//   ),
//   textTheme: const TextTheme(
//     bodyLarge: TextStyle(color: Colors.white),
//     // bodyLarge2: TextStyle(color: Colors.white70),
//   ),
//   // Add other theming attributes as necessary
// );

// void checkUserSession(BuildContext context) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final String? userType = prefs.getString('userType');

//   if (userType != null) {
//     if (userType == 'trainer') {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TrainerHomeScreen()));
//     } else if (userType == 'client') {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardTab()));
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/user.dart';
import 'login_page.dart';
import 'tabs/dashboard_tab.dart';
import 'services/json_utils.dart'; 
import 'trainer_home_screen.dart'; 
import 'app_state.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await JsonUtils.synchronizeJson(); // Ensure synchronization
  await createDefaultTrainerUser();
  runApp(const MyApp());
}

Future<void> createDefaultTrainerUser() async {
  bool userExists = false;

  try {
    Map<String, dynamic> data = await JsonUtils.readFromLocalJson();
    if (data.containsKey('users') && (data['users'] as List).isNotEmpty) {
      userExists = true;
    }
  } catch (e) {
    print('Error reading JSON file: $e');
  }

  if (!userExists) {
    print('No users found. Creating a default trainer user.');
    String defaultPassword = PasswordUtils.hashPassword('defaultTrainerPassword');
    User defaultTrainer = User(
      id: const Uuid().v4(),
      firstName: 'Default',
      lastName: 'Trainer',
      email: 'trainer@example.com',
      phoneNumber: '123456789',
      photoUrl: '',
      weight: 0.0,
      height: 0.0,
      armCircumference: 0.0,
      legCircumference: 0.0,
      waistCircumference: 0.0,
      backWidth: 0.0,
      chestWidth: 0.0,
      bodyFatPercentage: 0.0,
      password: defaultPassword,
      userType: 'trainer',
    );

    Map<String, dynamic> data = {'users': [defaultTrainer.toMap()]};
    await JsonUtils.saveToLocalJson(data);
    await JsonUtils.uploadJsonToFirebase();
    print('Default trainer user added to JSON file.');
  } else {
    print('DefaultTrainer already exists in the JSON file.');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Fitness App',
        theme: darkTheme, // Apply the dark theme here
        home: const LoginPage(), // Start with the LoginPage
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

ThemeData darkTheme = ThemeData(
  useMaterial3: true, // Enables Material 3
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue, // Replace with your primary color
    brightness: Brightness.dark,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey[900],
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white70,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    // bodyLarge2: TextStyle(color: Colors.white70),
  ),
  // Add other theming attributes as necessary
);

void checkUserSession(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userType = prefs.getString('userType');

  if (userType != null) {
    if (userType == 'trainer') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TrainerHomeScreen()));
    } else if (userType == 'client') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardTab()));
    }
  }
}
