import 'package:flutter/material.dart';
import 'package:gitgenie/auth/screens/login.dart';
import 'package:gitgenie/auth/screens/register.dart';
import 'package:gitgenie/screens/home_screen.dart';



Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SignUpScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  SignUpScreen(),
      );
      case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  LoginScreen(),
      );
      case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  HomeScreen(),
      );
   
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${routeSettings.name}'),
          ),
        ),
      );
  }
}
