import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visivista/api/auth.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/page/auth/login_page.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String message;
  bool hideText = true;
  bool hidePass = true;
  Authentication registerApi = Authentication();
  final url = Uri.parse('https://visivista.ppcdeveloper.com/');
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.secondary,
      // appBar: AppBar(

      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.arrow_back_ios_new_rounded,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Register',
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
                              borderSide: const BorderSide(
                                color: ColorPalette.black,
                                width: 2,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: ColorPalette.black,
                                width: 2,
                              ),
                            ),
                          )),
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "Nama",
                                    labelStyle: StyleText.formLabelStyle),
                                textInputAction: TextInputAction.next,
                                controller: namaController,
                                textCapitalization: TextCapitalization.words,
                                cursorColor: ColorPalette.grey,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "Email",
                                    labelStyle: StyleText.formLabelStyle),
                                textInputAction: TextInputAction.next,
                                controller: emailController,
                                cursorColor: ColorPalette.grey,
                              ),
                              const SizedBox(height: 10),
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
                              const SizedBox(height: 10),
                              TextFormField(
                                obscureText: hideText,
                                decoration: InputDecoration(
                                  labelText: "Confirm Password",
                                  labelStyle: StyleText.formLabelStyle,
                                  suffixIcon: IconButton(
                                    color: ColorPalette.secondary,
                                    onPressed: () {
                                      setState(() {
                                        hideText = !hideText;
                                      });
                                    },
                                    icon: hideText
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                controller: confirmPassController,
                                cursorColor: ColorPalette.grey,
                              ),
                            ],
                          )),
                      const SizedBox(height: 45),
                      ElevatedButton(
                        onPressed: () {
                          if (confirmPassController.text !=
                              passwordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Passwords are not the same",
                                  style: StyleText.boldBtnText,
                                ),
                                backgroundColor: ColorPalette.red,
                              ),
                            );
                          } else if (namaController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Error empty fileds",
                                  style: StyleText.boldBtnText,
                                ),
                                backgroundColor: ColorPalette.red,
                              ),
                            );
                          } else {
                            registerApi
                                .registerUser(
                                    namaController.text,
                                    emailController.text,
                                    passwordController.text)
                                .then((value) {
                              if (value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Account created successfully",
                                      style: StyleText.boldBtnText,
                                    ),
                                    duration: Duration(milliseconds: 1000),
                                    backgroundColor: ColorPalette.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      GlobalItem.message,
                                      style: StyleText.boldBtnText,
                                    ),
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    backgroundColor: ColorPalette.red,
                                  ),
                                );
                              }
                            });
                          }
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
                          "Create Account",
                          style: StyleText.boldBtnText,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: StyleText.questionAccount,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            },
                            child: const Text(
                              "Log in",
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
