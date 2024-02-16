import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visivista/model/global_function.dart';
import 'package:visivista/model/idea.dart';
import 'package:visivista/page/idea/detail_idea.dart';
import 'package:visivista/page/layout/empty_data_page.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class HomeIdea extends StatefulWidget {
  const HomeIdea({super.key, required this.listIdea});

  final List<Idea> listIdea;

  @override
  State<HomeIdea> createState() => _HomeIdeaState();
}

class _HomeIdeaState extends State<HomeIdea> {
  List<Idea> itemList = [];
  bool isLoading = true;

  void refreshData() {
    setState(() {
      itemList = widget.listIdea;
      isLoading = false;
    });
  }

  @override
  void initState() {
    setState(() {
      itemList = widget.listIdea;
    });
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
              ? const EmptyData()
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
                                    CupertinoIcons.lightbulb_fill,
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
                                  "Pelaksanaan :  ${DateFormat('dd/MM/yyyy').format(itemList[index].tglPelaksanaan)}",
                                  style: StyleText.listTileSubtitle,
                                ),
                                Text(
                                  GlobalFunction().truncateText(
                                    itemList[index].description ?? "-",
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
                                  builder: (context) =>
                                      DetailIdea(id: itemList[index].id),
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
