import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/page/auth/login_page.dart';
import 'package:visivista/page/auth/register_page.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int currentPage = 0; // Menyimpan indeks halaman aktif

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (GlobalItem.isAlreadyLoggedIn == false) {
          SystemNavigator.pop();
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorPalette.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  height: 310,
                  width: 1200,
                  color: ColorPalette.white,
                  padding: const EdgeInsets.all(10),
                  child: PageView(
                    onPageChanged: (int page) {
                      setState(() {
                        currentPage = page;
                      });
                    },
                    children: const [Page1(), Page2(), Page3()],
                  ),
                ),
              ),
              Container(
                height: 40,
                color: ColorPalette.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    3,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: index == currentPage
                            ? ColorPalette.secondary
                            : ColorPalette.grey.withOpacity(.5),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginPage()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: ColorPalette.black,
                  backgroundColor: ColorPalette.secondary,
                  fixedSize: const Size(350, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: StyleText.btnText),
                    Text("Login", style: StyleText.boldBtnText),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RegisterPage()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: ColorPalette.black,
                  backgroundColor: ColorPalette.primary,
                  fixedSize: const Size(350, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10,
                ),
                child: const Text(
                  "Don't have an account yet?",
                  style: StyleText.btnText,
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Welcome to \nVisiVista",
          style: StyleText.landingTitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 50),
        SizedBox(
            width: 300,
            child: Image.asset(
              GlobalItem.logoApp,
            )),
      ],
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Plan your idea \nShare your task \nwith your team",
          style: StyleText.landingTitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 50),
        SizedBox(
            width: 300,
            child: Image.asset(
              "assets/background/4890274.jpg",
            )),
      ],
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Schedule your \nPost on\nSocial Media",
          style: StyleText.landingTitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 50),
        SizedBox(
            width: 300,
            child: Image.asset(
              "assets/background/3912429.jpg",
            )),
      ],
    );
  }
}
