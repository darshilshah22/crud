import 'package:crud/Provider/home_provider.dart';
import 'package:crud/firebase_options.dart';
import 'package:crud/screens/home.dart';
import 'package:crud/screens/login.dart';
import 'package:crud/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  User? user;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: MyColor.bgColor,
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        home: user != null ? const HomeScreen() : const Login(),
      ),
    );
  }
}
