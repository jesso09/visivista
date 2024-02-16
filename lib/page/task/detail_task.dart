import 'package:flutter/material.dart';
import 'package:visivista/api/task_api.dart';
import 'package:visivista/main.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/task.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:visivista/page/task/edit_task.dart';
import 'package:intl/intl.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class DetailTask extends StatefulWidget {
  const DetailTask({super.key, required this.id});

  final int id;

  @override
  State<DetailTask> createState() => _DetailTaskState();
}

class _DetailTaskState extends State<DetailTask> {
  TaskApi taskApi = TaskApi();
  Task? task;
  late Future dataTask;
  bool isLoading = true;

  @override
  void initState() {
    dataTask = taskApi.getTask(widget.id);
    dataTask.then((value) {
      setState(() {
        task = value;
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const AppBarWithBack(),
      body: isLoading
          ? const LoadingPage()
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Tittle
                      Text(
                        TranslatedText().title,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        task?.title ?? 'Title',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.justify,
                      ),
                      // Description
                      const SizedBox(height: 20),
                      Text(
                        TranslatedText().description,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        task?.description ?? "Description",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      //Actuator
                      const SizedBox(height: 20),
                      Text(
                        TranslatedText().actuator,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        task?.idActuator == null ? task?.actuator ?? "" : task?.actuatorUser?.nama ?? "",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.justify,
                      ),
                      //date info
                      const SizedBox(height: 20),
                      Text(
                        TranslatedText().date,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        "${TranslatedText().createdAt} : ${DateFormat('dd MMMM yyyy').format(task?.createdAt ?? DateTime.now())}\n"
                        "${TranslatedText().updatedAt} : ${DateFormat('dd MMMM yyyy').format(task?.updatedAt ?? DateTime.now())}\n"
                        "${TranslatedText().startDate} : ${DateFormat('dd MMMM yyyy - HH:mm').format(task?.start ?? DateTime.now())}\n"
                        "${TranslatedText().endDate} : ${DateFormat('dd MMMM yyyy - HH:mm').format(task?.end ?? DateTime.now())}",
                        // "${TranslatedText().createdAt}\t\t: ${DateFormat('dd MMMM yyyy').format(task?.createdAt ?? DateTime.now())}\n"
                        // "${TranslatedText().updatedAt}\t: ${DateFormat('dd MMMM yyyy').format(task?.updatedAt ?? DateTime.now())}\n"
                        // "${TranslatedText().startDate}\t\t\t\t\t\t\t\t\t\t\t\t: ${DateFormat('dd MMMM yyyy - HH:mm').format(task?.start ?? DateTime.now())}\n"
                        // "${TranslatedText().endDate}\t\t\t\t\t\t\t\t: ${DateFormat('dd MMMM yyyy - HH:mm').format(task?.end ?? DateTime.now())}",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "${TranslatedText().madeBy} : ${task?.user?.nama ?? "Owner"}",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditTask(
                                        id: task!.id,
                                      )));
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: ColorPalette.black,
                              backgroundColor: ColorPalette.blue,
                              fixedSize: const Size(85, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              TranslatedText().edit,
                              style: StyleText.btnText,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              taskApi.delete(task!.id).then((value) {
                                if (value) {
                                  GlobalItem.indexPage = 3;
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyHomePage()),
                                    (Route<dynamic> route) => false,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                      "Item deleted",
                                      style: StyleText.boldBtnText,
                                    ),
                                    backgroundColor: ColorPalette.green,
                                  ));
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: ColorPalette.black,
                              backgroundColor: ColorPalette.red,
                              fixedSize: const Size(105, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              TranslatedText().delete,
                              style: StyleText.btnText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
