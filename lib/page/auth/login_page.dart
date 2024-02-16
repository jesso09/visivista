import 'package:flutter/material.dart';
import 'package:visivista/api/auth.dart';
import 'package:visivista/page/layout/landing_page.dart';
import 'package:visivista/main.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/page/auth/register_page.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String message;
  bool hidePass = true;
  final url = Uri.parse('https://visivista.ppcdeveloper.com/');
  Authentication login = Authentication();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.secondary,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Login',
                    style: StyleText.pageTitle,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 88.58,
                    child: Image.asset(GlobalItem.logoApp),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
              Center(
                child: SizedBox(
                  width: 350,
                  child: Form(
                      child: Column(
                    children: [
                      Theme(
                          data: ThemeData(
                              inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: ColorPalette.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: ColorPalette.black.withOpacity(1),
                                width: 2,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: ColorPalette.black.withOpacity(1),
                                width: 2,
                              ),
                            ),
                          )),
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "Email",
                                    labelStyle: StyleText.formLabelStyle),
                                textInputAction: TextInputAction.next,
                                controller: emailController,
                                cursorColor: ColorPalette.grey,
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                obscureText: hidePass,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle: StyleText.formLabelStyle,
                                  suffixIcon: IconButton(
                                    color: ColorPalette.secondary,
                                    onPressed: () {
                                      setState(() {
                                        hidePass = !hidePass;
                                      });
                                    },
                                    icon: hidePass
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                controller: passwordController,
                                cursorColor: ColorPalette.grey,
                              ),
                            ],
                          )),
                      const SizedBox(height: 100),
                      ElevatedButton(
                        onPressed: () {
                          login
                              .doLogin(
                                  emailController.text, passwordController.text)
                              .then((value) {
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Login Successfully",
                                    style: StyleText.boldBtnText,
                                  ),
                                  duration: Duration(milliseconds: 1000),
                                  backgroundColor: ColorPalette.green,
                                ),
                              );
                              login.getUserInfo(GlobalItem.userToken!);
                              GlobalItem.indexPage = 0;
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyHomePage()));
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    GlobalItem.message,
                                    style: StyleText.boldBtnText,
                                  ),
                                  backgroundColor: ColorPalette.red,
                                ),
                              );
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: ColorPalette.black,
                          backgroundColor: ColorPalette.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "Log in",
                          style: StyleText.boldBtnText,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Forgot your password? ",
                            style: StyleText.questionAccount,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LandingPage()),
                              );
                            },
                            child: const Text(
                              "Reset password",
                              style: StyleText.boldQuestionAccount,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: StyleText.questionAccount,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegisterPage()),
                              );
                            },
                            child: const Text(
                              "Sign Up",
                              style: StyleText.boldQuestionAccount,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                        child: const Text(
                          "Privacy Policy",
                          style: StyleText.boldQuestionAccount,
                        ),
                      ),
                    ],
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
