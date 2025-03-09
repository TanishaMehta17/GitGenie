import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gitgenie/auth/screens/login.dart';
import 'package:gitgenie/auth/services/authService.dart';
import 'package:gitgenie/providers/userProvider.dart';
import 'package:gitgenie/routes.dart';
import 'package:gitgenie/splash_screen.dart';
import 'package:provider/provider.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await Permission.storage.request();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  //await dotenv.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<UserProvider>(context).user.id);
    bool isUserLoggedIn =
        Provider.of<UserProvider>(context).user.token.isNotEmpty;
    print(isUserLoggedIn);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: isUserLoggedIn
          ? SplashScreen()
          :  LoginScreen(),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
