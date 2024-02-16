import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visivista/model/content.dart';
import 'package:visivista/model/global_function.dart';
import 'package:visivista/page/content/detail_content.dart';
import 'package:visivista/page/layout/content_view.dart';
import 'package:visivista/page/layout/empty_data_page.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:visivista/style/text_style.dart';

class HomeNewContent extends StatefulWidget {
  const HomeNewContent({super.key, required this.listContent});

  final List<Content> listContent;

  @override
  State<HomeNewContent> createState() => _HomeNewContentState();
}

class _HomeNewContentState extends State<HomeNewContent> {
  List<Content> itemList = [];
  bool isLoading = true;

  void refreshData() {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);

    List<Content> thisMonthContent = widget.listContent.where((content) {
      DateTime? createdAt = content.createdAt;
      return createdAt != null &&
          createdAt.isAfter(startOfMonth) &&
          createdAt.isBefore(endOfMonth);
    }).toList();

    setState(() {
      itemList = thisMonthContent;
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
      height: 420,
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
                        width: 250,
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
                                Text(
                                  "Dibuat Pada :  ${DateFormat('dd/MM/yyyy').format(itemList[index].createdAt ?? DateTime.now())}",
                                  style: StyleText.listTileSubtitle,
                                ),
                                const SizedBox(height: 5),
                                SizedBox(height: 200, width: 200, child: ContentView(id: itemList[index].id)),
                                const SizedBox(height: 20),
                                Text(
                                  itemList[index].title ?? "-",
                                  style: StyleText.listTileTitle,
                                ),
                                Text(
                                  "Caption :  ${GlobalFunction().truncateText(
                                    itemList[index].caption ?? "-",
                                    4,
                                  )}",
                                  style: StyleText.listTileSubtitle,
                                ),
                                Text(
                                  GlobalFunction().truncateText(
                                    itemList[index].hashtag ?? "-",
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
                                  builder: (context) => DetailContent(
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
