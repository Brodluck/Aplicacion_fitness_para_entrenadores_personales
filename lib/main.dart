// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ventanas/client_home_screen.dart';
import 'models/user.dart';
import 'login_page.dart';
import 'services/chat_service.dart';
import 'services/json_utils.dart';
import 'services/progress_service.dart';
import 'trainer_home_screen.dart';
import 'app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await JsonUtils.synchronizeJson('data');
  await JsonUtils.synchronizeJson('chats');
  await JsonUtils.synchronizeJson('exercises');
  await JsonUtils.synchronizeJson('diets');
  await createDefaultTrainerUser();
  runApp(const MyApp());
}

Future<void> createDefaultTrainerUser() async {
  bool userExists = false;

  try {
    Map<String, dynamic> data = await JsonUtils.readFromLocalJson('data');
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
      assignedExercises: [],
      assignedDiets: [],
    );

    Map<String, dynamic> data = {'users': [defaultTrainer.toMap()]};
    await JsonUtils.saveToLocalJson('data', data);
    await JsonUtils.uploadJsonToFirebase('data');
    print('Default trainer user added to JSON file.');
  } else {
    print('DefaultTrainer already exists in the JSON file.');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState(numberOfTabs: 3)),
        Provider<ChatService>(create: (_) => ChatService()),
        Provider<ProgressService>(create: (_) => ProgressService()),
      ],
      child: MaterialApp(
        title: 'Fitness App',
        theme: darkTheme,
        home: const LoginPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

ThemeData darkTheme = ThemeData(
  useMaterial3: true, 
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey[900],
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white70,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
  ),
);

void checkUserSession(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userType = prefs.getString('userType');
  final String? userId = prefs.getString('userId'); 

  if (userType != null && userId != null) {
    if (userType == 'trainer') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TrainerHomeScreen(trainerId: userId)));
    } else if (userType == 'client') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientHomeScreen(userId: userId)));
    }
  }
}
