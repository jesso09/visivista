import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:visivista/api/idea_api.dart';
import 'package:visivista/model/idea.dart';
import 'package:visivista/page/idea/detail_idea.dart';
import 'package:visivista/page/idea/edit_ide.dart';
import 'package:visivista/page/layout/empty_data_page.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class ListIdea extends StatefulWidget {
  const ListIdea({Key? key}) : super(key: key);

  @override
  State<ListIdea> createState() => _ListIdeaState();
}

class _ListIdeaState extends State<ListIdea> {
  bool isButtonVisible = false;
  IdeaApi ideaApi = IdeaApi();
  late Future dataTask;
  List<Idea> itemList = [];
  bool isLoading = true;

  void refreshData() {
    dataTask = ideaApi.getDataIdea();
    dataTask.then((value) {
      setState(() {
        itemList = value;
      });
      isLoading = false;
    });
  }

  @override
  void initState() {
    dataTask = ideaApi.getDataIdea();
    dataTask.then((value) {
      setState(() {
        itemList = value;
      });
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: isLoading
            ? const LoadingPage()
            : itemList.isEmpty
                ? const EmptyData()
                : SlidableAutoCloseBehavior(
                    child: ListView.builder(
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
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
                                        ideaApi.delete(itemList[index].id);
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
                                            builder: (context) =>
                                                EditIde(id: itemList[index].id),
                                          ),
                                        );
                                      },
                                    ),
                                  ]),
                              child: Card(
                                color: Theme.of(context).cardColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                child: ListTile(
                                  title: Text(
                                    itemList[index].title,
                                    style: StyleText.listTileTitle,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // const Text(
                                      //   "Medsos",
                                      //   style: StyleText.listTileSubtitle,
                                      // ),
                                      // const SizedBox(height: 5),
                                      Text(
                                        itemList[index].description ?? "",
                                        style: StyleText.listTileSubtitle,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        DateFormat('dd MMMM yyyy').format(
                                            itemList[index].tglPelaksanaan),
                                        style: StyleText.listTileSubtitle,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailIdea(id: itemList[index].id),
                                      ),
                                    );
                                  },
                                  isThreeLine: true,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
      ),
    );
  }
}
