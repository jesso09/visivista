import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalItem {
  static String message = "";
  static int userID = 0;
  static int indexPage = 0;
  static String videoUrl = '';
  static String photoUrl = '';
  static String imagePick = '';
  static String videoPick = '';
  static String? userToken;
  static String language = 'en';
  static bool isSettingsPage = false;
  static bool memberList = false;
  static int tempIndex = 0;
  static int newTeamId = 0;
  static bool taskTimelineNotif = true;
  static bool contentTimelineNotif = true;
  static bool teamInvitationNotif = true;
  static int clockTimeNotif = 7;
  static int minuteTimeNotif = 0;
  static String? deviceToken;
  static bool isAlreadyLoggedIn = false;
  static int createdTaskCount = 0;
  static int completedTaskCount = 0;
  static int createdContentCount = 0;
  static int postedContentCount = 0;
  static String logoApp = "assets/logo/logo.png";
  static String contentFilePath = "";
  static String contentType = "";
}

class ShareFunction {
  static Future<void> shareContent(
    String? caption,
    String backendFilePath,
    String contentType,
  ) async {
    try {
      // Example: Use HTTP to download the file from the Laravel backend.
      http.Response response = await http.get(
        Uri.parse(backendFilePath),
        headers: {
          'Authorization': 'Bearer ${GlobalItem.userToken}',
        },
      );

      if (response.statusCode == 200) {
        // Save the downloaded file to the device's local storage.
        String localFilePath = await _saveFileLocally(
          response.bodyBytes,
          contentType,
        );

        // Example: Use the share method to share the content to Instagram.
        // ignore: deprecated_member_use
        await Share.shareFiles([localFilePath],
            text: caption, subject: 'Instagram Feed');
      } else {
        // print('Failed to download file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error sharing to Instagram: $e');
      rethrow;
      // Handle the error, if any.
    }
  }

  // static Future<void> postToInsta(
  //     String? caption, String backendFilePath, String contentType) async {
  //   try {
  //     // Example: Use HTTP to download the file from the Laravel backend.
  //     http.Response response = await http.get(
  //       Uri.parse(backendFilePath),
  //       headers: {
  //         'Authorization': 'Bearer ${GlobalItem.userToken}',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       // Save the downloaded file to the device's local storage.
  //       String localFilePath =
  //           await _saveFileLocally(response.bodyBytes, contentType);

  //       // Launch Instagram app.
  //       await _launchInstagram(localFilePath, caption);
  //     } else {
  //       print('Failed to download file. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // Handle the error, if any.
  //   }
  // }

  static Future<String> _saveFileLocally(
      List<int> bytes, String contentType) async {
    // Get the directory for saving files locally.
    final appDirectory = await getApplicationDocumentsDirectory();

    // Generate a unique filename.
    String extension = contentType.contains('video') ? 'mp4' : 'jpg';
    String localFilePath =
        '${appDirectory.path}${DateTime.now().millisecondsSinceEpoch}.$extension';

    // Write the file.
    await File(localFilePath).writeAsBytes(bytes);

    return localFilePath;
  }

  // static Future<void> _launchInstagram(
  //     String localFilePath, String? caption) async {
  //   const url = 'instagram://app';

  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url));
  //   } else {
  //     // If Instagram app is not installed, open the Instagram website.
  //     // await launchUrl(Uri.parse('https://www.instagram.com/'));
  //     await launchUrl(
  //         Uri.parse('https://www.tiktok.com/creator-center/upload'));
  //   }
  // }
}

class UserSettings {
  Future<void> saveLanguage(String? languageCode) async {
    SharedPreferences languagePref = await SharedPreferences.getInstance();
    await languagePref.setString('language', languageCode!);
  }

  Future<void> loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    GlobalItem.language = prefs.getString('language') ?? 'en';
  }

  Future<void> loadTaskTimelineNotif() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    GlobalItem.taskTimelineNotif = prefs.getBool('notif_task_timeline') ?? true;
  }

  Future<void> saveTaskTimelineNotif(bool isNotif) async {
    SharedPreferences notifPref = await SharedPreferences.getInstance();
    await notifPref.setBool('notif_task_timeline', isNotif);
  }

  Future<void> saveContentTimelineNotif(bool isNotif) async {
    SharedPreferences notifPref = await SharedPreferences.getInstance();
    await notifPref.setBool('notif_content_timeline', isNotif);
  }

  Future<void> loadContentTimelineNotif() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    GlobalItem.contentTimelineNotif =
        prefs.getBool('notif_content_timeline') ?? true;
  }

  Future<void> saveTeamNotif(bool isNotif) async {
    SharedPreferences notifPref = await SharedPreferences.getInstance();
    await notifPref.setBool('notif_team', isNotif);
  }

  Future<void> loadTeamNotif() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    GlobalItem.teamInvitationNotif = prefs.getBool('notif_team') ?? true;
  }

  Future<void> saveClock(int clock) async {
    SharedPreferences timePref = await SharedPreferences.getInstance();
    await timePref.setInt('notif_clock', clock);
  }

  Future<void> loadClock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    GlobalItem.clockTimeNotif = prefs.getInt('notif_clock') ?? 7;
  }

  Future<void> saveMinute(int minute) async {
    SharedPreferences notifPref = await SharedPreferences.getInstance();
    await notifPref.setInt('notif_minute', minute);
  }

  Future<void> loadMinute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    GlobalItem.minuteTimeNotif = prefs.getInt('notif_minute') ?? 0;
  }
}

class StringUtils {
  static String truncateDescription(String text, int maxWords) {
    String description = text;

    String truncatedDescription =
        description.split(" ").take(maxWords).join(" ");
    if (description.split(" ").length > maxWords) {
      truncatedDescription += ". . . . ";
    }

    return truncatedDescription;
  }
}

class DateTimePicker {
  static Future<void> selectDateTime(
      BuildContext context, TextEditingController controller) async {
    DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime(2100),
    );

    if (datePicked != null) {
      // Tampilkan time picker jika tanggal sudah dipilih
      // ignore: use_build_context_synchronously
      TimeOfDay? timePicked = await showTimePicker(
        helpText: "",
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (timePicked != null) {
        // Gabungkan tanggal dan waktu menjadi DateTime
        DateTime dateTimePicked = DateTime(
          datePicked.year,
          datePicked.month,
          datePicked.day,
          timePicked.hour,
          timePicked.minute,
        );

        // Tampilkan hasil pada controller
        controller.text = DateFormat('yyyy-MM-dd HH:mm').format(dateTimePicked);
      }
    }
  }

  // static Future<void> selectDateTime(
  //     BuildContext context, TextEditingController controller) async {
  //   DateTime? dateTimePicked =
  //       await showOmniDateTimePicker(
  //         context: context,
  //         initialDate: DateTime.now(),
  //         firstDate: DateTime(1600),
  //         lastDate: DateTime(3600),
  //         is24HourMode: false,
  //         isShowSeconds: false,
  //         minutesInterval: 1,
  //         secondsInterval: 1,
  //         borderRadius: const BorderRadius.all(Radius.circular(16)),
  //         constraints: const BoxConstraints(
  //           maxWidth: 350,
  //           maxHeight: 650,
  //         ),
  //         transitionBuilder: (context, anim1, anim2, child) {
  //           return FadeTransition(
  //             opacity: anim1.drive(
  //               Tween(
  //                 begin: 0,
  //                 end: 1,
  //               ),
  //             ),
  //             child: child,
  //           );
  //         },
  //         transitionDuration: const Duration(milliseconds: 200),
  //         barrierDismissible: false,
  //         // selectableDayPredicate: (dateTime) {
  //         //   // Disable 25th Feb 2023
  //         //   if (dateTime == DateTime(2023, 2, 25)) {
  //         //     return false;
  //         //   } else {
  //         //     return true;
  //         //   }
  //         // },
  //       );
  //   if (dateTimePicked != null) {
  //     print(DateFormat('yyyy-MM-dd - HH:mm').format(dateTimePicked));
  //     controller.text = DateFormat('yyyy-MM-dd - HH:mm').format(dateTimePicked);
  //   }
  // }
}
