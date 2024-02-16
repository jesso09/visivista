import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:visivista/api/task_api.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/task.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/page/layout/empty_data_page.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:visivista/page/task/detail_task.dart';
import 'package:visivista/page/task/edit_task.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class CheckedList extends StatefulWidget {
  const CheckedList({Key? key}) : super(key: key);

  @override
  State<CheckedList> createState() => _CheckedListState();
}

class _CheckedListState extends State<CheckedList> {
  bool isChecked = false;
  bool isButtonVisible = false;
  TaskApi taskApi = TaskApi();
  late Future dataTask;
  List<Task> itemList = [];
  bool isLoading = true;

  void refreshData() {
    dataTask = taskApi.indexChecked();
    dataTask.then((value) {
      setState(() {
        itemList = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    dataTask = taskApi.indexChecked();
    dataTask.then((value) {
      setState(() {
        itemList = value;
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
          : itemList.isEmpty
              ? const EmptyData()
              : SlidableAutoCloseBehavior(
                  child: ListView.builder(
                      itemCount: itemList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: Slidable(
                            endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    backgroundColor: ColorPalette.red,
                                    icon: Icons.delete_forever_rounded,
                                    label: TranslatedText().delete,
                                    borderRadius: BorderRadius.circular(15),
                                    onPressed: (context) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      taskApi.delete(itemList[index].id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                          "Item deleted",
                                          style: StyleText.boldBtnText,
                                        ),
                                        backgroundColor: ColorPalette.green,
                                      ));
                                      refreshData();
                                    },
                                  ),
                                  const SizedBox(width: 6),
                                  SlidableAction(
                                    backgroundColor: ColorPalette.blue,
                                    icon: Icons.edit,
                                    foregroundColor: ColorPalette.white,
                                    label: TranslatedText().edit,
                                    borderRadius: BorderRadius.circular(15),
                                    onPressed: (context) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => EditTask(
                                                  id: itemList[index].id)));
                                    },
                                  ),
                                ]),
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              color: Theme.of(context).cardColor,
                              elevation: 3,
                              child: ListTile(
                                trailing: RoundCheckBox(
                                  isRound: true,
                                  borderColor: ColorPalette.black,
                                  animationDuration:
                                      const Duration(milliseconds: 300),
                                  size: 30,
                                  isChecked: true,
                                  checkedColor: ColorPalette.secondary,
                                  uncheckedColor: ColorPalette.white,
                                  onTap: (selected) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    taskApi.changeStatus(itemList[index].id);
                                    refreshData();
                                  },
                                ),
                                title: Text(
                                  StringUtils.truncateDescription(
                                      itemList[index].title, 5),
                                  style: StyleText.listTileTitle,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      StringUtils.truncateDescription(
                                          itemList[index].description, 5),
                                      // itemList[index].description,
                                      style: StyleText.listTileSubtitle,
                                    ),
                                    Text(
                                      StringUtils.truncateDescription(
                                          itemList[index].actuator ?? "", 5),
                                      style: StyleText.listTileSubtitle,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          DetailTask(id: itemList[index].id)));
                                },
                              ),
                            ),
                          ),
                        );
                      }),
                ),
    );
  }
}
