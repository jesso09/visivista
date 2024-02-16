import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visivista/api/content_api.dart';
import 'package:visivista/main.dart';
import 'package:visivista/model/content.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/page/content/edit_content.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/page/layout/content_view.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class DetailContent extends StatefulWidget {
  const DetailContent({super.key, required this.id});

  final int id;

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  ContentApi contentApi = ContentApi();
  Content? content;
  late Future<Content> dataContent;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    dataContent = contentApi.getContent(widget.id);
    dataContent.then((value) {
      setState(() {
        content = value;
        isLoading = false;
      });
    });
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
                      ContentView(id: widget.id),
                      const SizedBox(height: 20),
                      Text(
                        TranslatedText().title,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        content?.title ?? "-",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.justify,
                      ),
                      //caption
                      const SizedBox(height: 20),
                      Text(
                        TranslatedText().caption,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        content?.caption ?? "-",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.justify,
                      ),
                      //hashtag
                      const SizedBox(height: 20),
                      Text(
                        TranslatedText().hashtag,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        content?.hashtag ?? "-",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      //team
                      const SizedBox(height: 20),
                      Text(
                        TranslatedText().team,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        content?.team ?? "-",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.justify,
                      ),
                      // Idea
                      const SizedBox(height: 20),
                      Text(
                        "From Plan",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        content?.idea?.title ?? "-",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.justify,
                      ),
                      //date info
                      const SizedBox(height: 20),
                      Text(
                        TranslatedText().date,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      content?.postScheduled == null
                          ? const Text("")
                          : Text(
                              "${TranslatedText().datePost} : ${DateFormat('HH:mm - dd MMMM yyyy').format(content?.postScheduled ?? DateTime.now())}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                      Text(
                        "${TranslatedText().updatedAt} : ${DateFormat('dd MMMM yyyy').format(content?.updatedAt ?? DateTime.now())}\n"
                        "${TranslatedText().createdAt} : ${DateFormat('dd MMMM yyyy').format(content?.createdAt ?? DateTime.now())}\n",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditContent(id: widget.id),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: ColorPalette.black,
                              backgroundColor: ColorPalette.blue,
                              fixedSize: const Size(95, 40),
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
                              ShareFunction.shareContent(content?.caption, GlobalItem.contentFilePath, GlobalItem.contentType);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: ColorPalette.black,
                              backgroundColor: ColorPalette.yellow,
                              fixedSize: const Size(100, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              // TranslatedText().post,
                              "Share",
                              style: StyleText.btnText,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              contentApi.delete(widget.id);
                              GlobalItem.indexPage = 1;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyHomePage()),
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
