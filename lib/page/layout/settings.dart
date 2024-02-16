import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visivista/api/user_api.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/notifications.dart';
import 'package:visivista/style/text_style.dart';
import 'package:visivista/style/theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin fLutterLocalNotificationPlugin =
    FlutterLocalNotificationsPlugin();

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ThemeMode? selectedTheme = ThemeMode.light;
  String language = '';
  TimeOfDay? selectedTime;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;

  @override
  void initState() {
    super.initState();
    loadCurrentTheme();
    NotificationService.initialize(fLutterLocalNotificationPlugin);
    language = GlobalItem.language;
  }

  void loadCurrentTheme() async {
    ThemeMode currentTheme =
        Provider.of<ThemeProvider>(context, listen: false).currentTheme;

    setState(() {
      selectedTheme = currentTheme;
    });
  }

  void themeRadio(ThemeMode? value) {
    setState(() {
      selectedTheme = value;
      Provider.of<ThemeProvider>(context, listen: false)
          .setCurrentTheme(value!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const AppBarWithBack(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //theme
              ListTile(
                title: Text(
                  TranslatedText().theme,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                trailing: PopupMenuButton(
                  color: Theme.of(context).bottomAppBarTheme.color,
                  icon: Icon(
                    Icons.menu_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: RadioListTile<ThemeMode>(
                        title: Text(
                          TranslatedText().light,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        value: ThemeMode.light,
                        groupValue: selectedTheme,
                        onChanged: (value) {
                          themeRadio(value);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: RadioListTile<ThemeMode>(
                        title: Text(
                          TranslatedText().dark,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        value: ThemeMode.dark,
                        groupValue: selectedTheme,
                        onChanged: (value) {
                          themeRadio(value);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: RadioListTile<ThemeMode>(
                        title: Text(
                          TranslatedText().followSystem,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        value: ThemeMode.system,
                        groupValue: selectedTheme,
                        onChanged: (value) {
                          themeRadio(value);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              //language
              ListTile(
                title: Text(
                  TranslatedText().language,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                trailing: PopupMenuButton(
                    color: Theme.of(context).bottomAppBarTheme.color,
                    icon: Icon(
                      Icons.menu_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: RadioListTile<String>(
                              title: Text(
                                "Indonesia",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              value: "id",
                              groupValue: language,
                              onChanged: (value) {
                                setState(() {
                                  language = value!;
                                  GlobalItem.language = language;
                                });
                                UserSettings().saveLanguage(value);
                                UserSettings().loadLanguage();
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          PopupMenuItem(
                            child: RadioListTile<String>(
                              title: Text(
                                "English",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              value: "en",
                              groupValue: language,
                              onChanged: (value) {
                                setState(() {
                                  language = value!;
                                  GlobalItem.language = language;
                                });
                                UserSettings().saveLanguage(value);
                                UserSettings().loadLanguage();
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ]),
              ),
              const SizedBox(height: 10),

              //notifications Timeline Task
              ListTile(
                title: Text(
                  TranslatedText().taskTL,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                trailing: Switch(
                  value: GlobalItem.taskTimelineNotif,
                  activeColor: ColorPalette.secondary,
                  onChanged: (bool value) {
                    setState(() {
                      GlobalItem.taskTimelineNotif = value;
                      UserSettings().saveTaskTimelineNotif(value);
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),

              //notifications timline content
              ListTile(
                title: Text(
                  TranslatedText().contentTL,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                trailing: Switch(
                  value: GlobalItem.contentTimelineNotif,
                  activeColor: ColorPalette.secondary,
                  onChanged: (bool value) {
                    setState(() {
                      UserSettings().saveContentTimelineNotif(value);
                      GlobalItem.contentTimelineNotif = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),

              //Team Notification
              ListTile(
                title: Text(
                  TranslatedText().teamNotification,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                trailing: Switch(
                  value: GlobalItem.teamInvitationNotif,
                  activeColor: ColorPalette.secondary,
                  onChanged: (bool value) async {
                    setState(() {
                      if (value) {
                        UserApi().updateDeviceToken(
                            GlobalItem.userID, GlobalItem.deviceToken!);
                      } else {
                        UserApi().updateDeviceToken(
                            GlobalItem.userID, "");
                      }
                      GlobalItem.teamInvitationNotif = value;
                      UserSettings().saveTeamNotif(value);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(
                  TranslatedText().notificationTime,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                subtitle: Text(
                  '${TranslatedText().timeSet} : ${GlobalItem.clockTimeNotif} : ${GlobalItem.minuteTimeNotif}',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                trailing: ElevatedButton(
                  child: Text(TranslatedText().setTime),
                  onPressed: () async {
                    final TimeOfDay? time = await showTimePicker(
                      helpText: "",
                      context: context,
                      initialTime: selectedTime ?? TimeOfDay.now(),
                      initialEntryMode: entryMode,
                      orientation: orientation,
                      builder: (BuildContext context, Widget? child) {
                        return Directionality(
                          textDirection: textDirection,
                          child: MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              alwaysUse24HourFormat: use24HourTime,
                            ),
                            child: child!,
                          ),
                        );
                      },
                    );
                    setState(() {
                      selectedTime = time;
                      if (selectedTime != null) {
                        GlobalItem.clockTimeNotif = selectedTime!.hour;
                        GlobalItem.minuteTimeNotif = selectedTime!.minute;
                        UserSettings().saveClock(selectedTime!.hour);
                        UserSettings().saveMinute(selectedTime!.minute);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
