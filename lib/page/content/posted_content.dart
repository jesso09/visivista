import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visivista/api/content_api.dart';
import 'package:visivista/main.dart';
import 'package:visivista/model/content.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/page/content/detail_content.dart';
import 'package:visivista/page/content/edit_content.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/page/layout/content_view.dart';
import 'package:visivista/page/layout/empty_data_page.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class PostedContent extends StatefulWidget {
  const PostedContent({Key? key}) : super(key: key);

  @override
  State<PostedContent> createState() => _PostedContentState();
}

class _PostedContentState extends State<PostedContent> {
  bool isButtonVisible = false;
  bool isLoading = true;
  ContentApi contentApi = ContentApi();
  late Future dataContent;
  List<Content> itemList = [];

  void refreshData() {
    dataContent = contentApi.indexPosted();
    dataContent.then((value) {
      setState(() {
        itemList = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    dataContent = contentApi.indexPosted();
    dataContent.then((value) {
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
              : ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Theme.of(context).cardColor,
                      margin: const EdgeInsets.all(15),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    DetailContent(id: itemList[index].id)));
                          },
                          title: Center(
                              child: Column(
                            children: [
                              ContentView(id: itemList[index].id),
                              Text(
                                itemList[index].title ?? "",
                                style: StyleText.listTileTitle,
                              ),
                            ],
                          )),
                          subtitle: Column(children: [
                            Text(
                              StringUtils.truncateDescription(
                                  itemList[index].caption ?? "", 20),
                              style: StyleText.listTileSubtitle,
                            ),
                            const SizedBox(height: 10),
                            itemList[index].postScheduled == null
                                ? const Text("")
                                : Text(
                                    "${TranslatedText().datePost}\t\t\t\t\t\t: ${DateFormat('HH:mm - dd MMMM yyyy').format(itemList[index].postScheduled ?? DateTime.now())}",
                                    style: StyleText.listTileSubtitle,
                                  ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditContent(id: itemList[index].id),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: ColorPalette.black,
                                    backgroundColor: ColorPalette.blue,
                                    fixedSize: const Size(100, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: Text(
                                    TranslatedText().edit,
                                    style: StyleText.boldBtnText,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    contentApi.delete(itemList[index].id);
                                    GlobalItem.indexPage = 1;
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const MyHomePage(),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Item deleted"),
                                      backgroundColor: ColorPalette.secondary,
                                    ));
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
                                    style: StyleText.boldBtnText,
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    );
                  }),
    );
  }
}
