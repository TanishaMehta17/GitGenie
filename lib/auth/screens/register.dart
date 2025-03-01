import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gitgenie/auth/screens/login.dart';
import 'package:gitgenie/auth/services/authService.dart';
import 'package:gitgenie/common/colors.dart';
import 'package:gitgenie/common/typography.dart';
import 'package:gitgenie/utils/customTextFormField.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

bool _passwordVisible = false;
bool _confirmPasswordVisible = false;
final AuthService authService = AuthService();
final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();

class _SignUpScreenState extends State<SignUpScreen> {
  Future<bool> Signup() async {
    bool result = await authService.register(
      context: context,
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      confirmpas: confirmPasswordController.text,
    );
    if (result) {
      Navigator.pushNamed(context, LoginScreen.routeName);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dark Theme Background with GitHub-Inspired Colors
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Main content
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
                    'Welcome to  GitGenie!',
                    style: SCRTypography.heading.copyWith(color: white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Sign up to continue',
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
                        // Full Name Field
                        CustomTextField(
                          controller: nameController,
                          labelText: "Name",
                          hintText: "Enter your name",
                          keyboardType: TextInputType.name,
                        ),
                        SizedBox(height: 15),

                        CustomTextField(
                          controller: emailController,
                          labelText: "Email",
                          hintText: "Enter your email",
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 15),

                        CustomTextField(
                          controller: passwordController,
                          labelText: "Password",
                          hintText: "Enter your password",
                          obscureText: !_passwordVisible,
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
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: confirmPasswordController,
                          labelText: "Confirm Password",
                          hintText: "Re-enter your password",
                          obscureText: !_confirmPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _confirmPasswordVisible =
                                    !_confirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 25),

                        // Get Started Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Signup();
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
                              'Get Started',
                              style: SCRTypography.subHeading
                                  .copyWith(color: white),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),

                        // Footer Text
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(color: primaryColor),
                              children: [
                                TextSpan(
                                  text: 'Log In',
                                  style: SCRTypography.subHeading.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                          context, LoginScreen.routeName);
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
