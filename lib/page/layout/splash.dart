import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:visivista/api/auth.dart';
import 'package:visivista/main.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/page/layout/landing_page.dart';
import 'package:visivista/style/color_palete.dart';

final FlutterLocalNotificationsPlugin fLutterLocalNotificationPlugin =
    FlutterLocalNotificationsPlugin();

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double opacityValue = 0.0;

  @override
  void initState() {
    super.initState();
    nextPage();
  }

  void nextPage() {
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        opacityValue = 1.0;
      });
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      // DeviceIdManager().loadDeviceId().then((value) {
      //   if (GlobalItem.deviceId == null) {
      //     DeviceIdManager().generateDeviceId();
      //   }
      // });
      Authentication().autoLogin().then((value) {
        UserSettings().loadLanguage();
        UserSettings().loadTaskTimelineNotif();
        UserSettings().loadContentTimelineNotif();
        UserSettings().loadTeamNotif();
        UserSettings().loadClock();
        UserSettings().loadMinute();
        if (GlobalItem.userToken != null) {
          Authentication().getUserInfo(GlobalItem.userToken);
          GlobalItem.isAlreadyLoggedIn = true;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
            (Route<dynamic> route) => false,
          );
        } else {
          GlobalItem.isAlreadyLoggedIn = false;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LandingPage()),
            (Route<dynamic> route) => false,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: AnimatedOpacity(
            opacity: opacityValue,
            duration: const Duration(milliseconds: 800),
            child: Image.asset(GlobalItem.logoApp),
          ),
        ),
      ),
    );
  }
}
