import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:visivista/api/auth.dart';
import 'package:visivista/api/content_api.dart';
import 'package:visivista/api/task_api.dart';
import 'package:visivista/api/user_api.dart';
import 'package:visivista/model/content.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/task.dart';
import 'package:visivista/model/user.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:visivista/page/task/detail_task.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/notifications.dart';
import 'package:visivista/style/text_style.dart';

final FlutterLocalNotificationsPlugin fLutterLocalNotificationPlugin =
    FlutterLocalNotificationsPlugin();

class TaskTimeline extends StatefulWidget {
  const TaskTimeline({Key? key}) : super(key: key);

  @override
  State<TaskTimeline> createState() => _TaskTimelineState();
}

class _TaskTimelineState extends State<TaskTimeline> {
  DateTime today = DateTime.now();
  bool isChecked = false;
  bool isLoading = true;
  TaskApi taskApi = TaskApi();
  late Future dataTask;
  List<Task> itemList = [];
  UserApi userApi = UserApi();
  User? user;
  late Future dataUser;
  Map<DateTime, List<Task>> events = {};
  late final ValueNotifier<List<Task>> selectedEvent;
  DateTime? daySelected;
  bool isButtonVisible = false;
  ContentApi contentApi = ContentApi();
  List<Content> contentList = [];

  @override
  void initState() {
    selectedEvent =
        ValueNotifier(getEventForDay(daySelected ?? DateTime.now()));
    dataUser = Authentication().getUserInfo(GlobalItem.userToken).then((value) {
      setState(() {
        user = value;
      });
    }).then((value) {
      if (user != null) {
        // cuman buat keperluan notifikasi
        dataTask = contentApi.getDataContent();
        dataTask.then((value) {
          setState(() {
            contentList = value;
            if (GlobalItem.contentTimelineNotif) {
              contentPostNotification(contentList);
            }
          });
        });
        dataTask = taskApi.getTaskWithActuator();
        dataTask.then((value) {
          setState(() {
            itemList = value;
            selectedEvent.value = getEventForDay(DateTime.now());
            isLoading = false;
            if (GlobalItem.taskTimelineNotif) {
              taskEndNotification(itemList);
            }
          });
        });
      }
    });
    NotificationService.initialize(fLutterLocalNotificationPlugin);
    today = DateTime.now();
    super.initState();
  }

  Future<void> taskEndNotification(List<Task> tasks) async {
    final DateTime now = DateTime.now();
    final notificationTime = DateTime(now.year, now.month, now.day,
        GlobalItem.clockTimeNotif, GlobalItem.minuteTimeNotif);
    bool hasTasksEndingToday = tasks.any((task) => isSameDay(task.end, now));
    List<Task> nowTask = itemList.where((task) {
      return isSameDay(task.end, now);
    }).toList();

    if (hasTasksEndingToday) {
      await NotificationService.scheduleNotifications(
        fLutterLocalNotificationPlugin,
        tasks,
        nowTask.length,
        notificationTime,
      );
    }
  }

  void getDay(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(daySelected, selectedDay)) {
      setState(() {
        daySelected = selectedDay;
        today = focusedDay;
        selectedEvent.value = getEventForDay(selectedDay);
      });
    }
  }

  Future<void> contentPostNotification(List<Content> contents) async {
    final DateTime now = DateTime.now();
    final notificationTime = DateTime(now.year, now.month, now.day,
        GlobalItem.clockTimeNotif, GlobalItem.minuteTimeNotif);
    bool hasContentPostNow =
        contents.any((item) => isSameDay(item.postScheduled, now));
    List<Content> nowContent = contentList.where((content) {
      return isSameDay(content.postScheduled, now);
    }).toList();

    if (hasContentPostNow) {
      await NotificationService.contentNotif(
        fLutterLocalNotificationPlugin,
        contents,
        nowContent.length,
        notificationTime,
      );
    }
  }

  List<Task> getEventForDay(DateTime day) {
    return itemList.where((task) {
      return isSameDay(task.end, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingPage()
        : Scaffold(
            appBar: const AppBarWithBack(),
            body: Column(children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  // padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(15),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: ColorPalette.black.withOpacity(0.5),
                    //     spreadRadius: 1,
                    //     blurRadius: 1,
                    //     offset: const Offset(0, 3),
                    //   ),
                    // ],
                  ),
                  child: TableCalendar(
                    headerStyle: HeaderStyle(
                      titleTextStyle: Theme.of(context).textTheme.titleSmall!,
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    calendarStyle: CalendarStyle(
                      defaultTextStyle:
                          Theme.of(context).textTheme.displaySmall!,
                      markerDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: ColorPalette.secondary.withOpacity(.5),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: ColorPalette.secondary,
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: Theme.of(context).textTheme.labelSmall!,
                    ),
                    weekendDays: const [DateTime.sunday],
                    selectedDayPredicate: (day) => isSameDay(day, today),
                    focusedDay: today,
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    onDaySelected: getDay,
                    eventLoader: getEventForDay,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: isLoading
                    ? const LoadingPage()
                    : ValueListenableBuilder<List<Task>>(
                        valueListenable: selectedEvent,
                        builder: (context, value, _) {
                          return ListView.builder(
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 22, vertical: 4),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  color: Theme.of(context).cardColor,
                                  elevation: 3,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => DetailTask(
                                                    id: value[index].id,
                                                  )));
                                    },
                                    title: Text(
                                      value[index].title,
                                      style: StyleText.listTileTitle,
                                    ),
                                    subtitle: Text(
                                      DateFormat('HH:mm').format(
                                        value[index].end,
                                      ),
                                      style: StyleText.listTileSubtitle,
                                    ),
                                  ),
                                );
                              });
                        }),
              ),
            ]),
          );
  }
}
