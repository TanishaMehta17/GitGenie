import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gitgenie/auth/screens/register.dart';
import 'package:gitgenie/auth/services/authService.dart';
import 'package:gitgenie/common/colors.dart';
import 'package:gitgenie/common/typography.dart';
import 'package:gitgenie/screens/home_screen.dart';
import 'package:gitgenie/splash_screen.dart';
import 'package:gitgenie/utils/customTextFormField.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signin(BuildContext context) {
    authService.login(
      context: context,
      email: emailController.text,
      password: passwordController.text,
      callback: (bool success) {
        if (success) {
          print("Login Successful");
          Navigator.pushNamed(context, HomeScreen.routeName);
        } else {
          print("Password is Incorrect");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(seconds: 1),
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: CircleAvatar(
                          radius: 80,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/github.jpeg',
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Text(
                    'Welcome Back!',
                    style: SCRTypography.heading.copyWith(color: white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Login to continue',
                    style: SCRTypography.subHeading.copyWith(color: white70),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: emailController,
                          labelText: "Email",
                          hintText: "Enter your email",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        CustomTextField(
                          controller: passwordController,
                          labelText: "Password",
                          hintText: "Enter your password",
                          keyboardType: TextInputType.text,
                          obscureText:
                              !_passwordVisible, // This controls the visibility of the text
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              signin(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Log In',
                              style: SCRTypography.subHeading
                                  .copyWith(color: white),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(color: primaryColor),
                              children: [
                                TextSpan(
                                  text: 'Register',
                                  style: SCRTypography.subHeading.copyWith(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                          context, SignUpScreen.routeName);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
