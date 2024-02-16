import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visivista/model/global_function.dart';
import 'package:visivista/model/task.dart';
import 'package:visivista/page/layout/empty_data_page.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:visivista/page/task/detail_task.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class TaskToday extends StatefulWidget {
  const TaskToday({super.key, required this.listTask});

  final List<Task> listTask;

  @override
  State<TaskToday> createState() => _TaskTodayState();
}

class _TaskTodayState extends State<TaskToday> {
  List<Task> itemList = [];
  bool isLoading = true;

  void refreshData() {
    DateTime today = DateTime.now();
    List<Task> todayTasks = widget.listTask.where((task) {
      return task.end.year == today.year &&
          task.end.month == today.month &&
          task.end.day == today.day;
    }).toList();

    setState(() {
      itemList = todayTasks;
      isLoading = false;
    });
  }

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: isLoading
          ? const LoadingPage()
          : itemList.isEmpty
              ? const SmallEmpty()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: itemList.length > 7 ? 7 : itemList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        width: 170,
                        child: Card(
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                const Center(
                                  child: Icon(
                                    Icons.assignment,
                                    size: 35,
                                    color: ColorPalette.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  itemList[index].title,
                                  style: StyleText.listTileTitle,
                                ),
                                Text(
                                  "Deadline :  ${DateFormat('dd/MM/yyyy').format(itemList[index].end)}",
                                  style: StyleText.listTileSubtitle,
                                ),
                                Text(
                                  GlobalFunction().truncateText(
                                    itemList[index].description,
                                    4,
                                  ),
                                  style: StyleText.listTileSubtitle,
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailTask(
                                    id: itemList[index].id,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
