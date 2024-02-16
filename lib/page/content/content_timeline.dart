import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:visivista/api/content_api.dart';
import 'package:visivista/model/content.dart';
import 'package:visivista/page/content/detail_content.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class ContentTimeline extends StatefulWidget {
  const ContentTimeline({Key? key}) : super(key: key);

  @override
  State<ContentTimeline> createState() => _ContentTimelineState();
}

class _ContentTimelineState extends State<ContentTimeline> {
  DateTime today = DateTime.now();
  bool isLoading = true;
  ContentApi contentApi = ContentApi();
  late Future dataContent;
  List<Content> itemList = [];
  Map<DateTime, List<Content>> events = {};
  late final ValueNotifier<List<Content>> selectedEvent;
  DateTime? daySelected;

  @override
  void initState() {
    selectedEvent =
        ValueNotifier(getEventForDay(daySelected ?? DateTime.now()));
    dataContent = contentApi.getDataContent();
    dataContent.then((value) {
      setState(() {
        itemList = value;
        selectedEvent.value = getEventForDay(DateTime.now());
        isLoading = false;
      });
    });
    today = DateTime.now();
    super.initState();
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

  List<Content> getEventForDay(DateTime day) {
    return itemList.where((content) {
      return isSameDay(content.postScheduled, day);
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: ColorPalette.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  width: 350,
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
                child: ValueListenableBuilder<List<Content>>(
                    valueListenable: selectedEvent,
                    builder: (context, value, _) {
                      return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              color: Theme.of(context).cardColor,
                              elevation: 3,
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailContent(
                                            id: value[index].id,
                                          )));
                                },
                                title: Text(
                                  value[index].title ?? "-",
                                  style: StyleText.listTileTitle,
                                ),
                                subtitle: Text(
                                  DateFormat('HH:mm').format(
                                    value[index].postScheduled ??
                                        DateTime.now(),
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
