import 'package:flutter/material.dart';
import 'package:visivista/api/idea_api.dart';
import 'package:visivista/main.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/idea.dart';
import 'package:visivista/page/idea/edit_ide.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:intl/intl.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class DetailIdea extends StatefulWidget {
  const DetailIdea({super.key, required this.id});

  final int id;

  @override
  State<DetailIdea> createState() => _DetailIdeaState();
}

class _DetailIdeaState extends State<DetailIdea> {
  IdeaApi ideaApi = IdeaApi();
  Idea? idea;
  late Future dataIdea;
  bool isLoading = true;
  int lengthContent = 0;

  @override
  void initState() {
    dataIdea = ideaApi.getIdea(widget.id);
    dataIdea.then((value) {
      setState(() {
        idea = value;
        lengthContent = idea!.content.length;
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
                        idea?.title ?? 'Title',
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
                        idea?.description ?? "Description",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      //date info
                      const SizedBox(height: 20),
                      Text(
                        TranslatedText().date,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        "${TranslatedText().createdAt} : ${DateFormat('dd MMMM yyyy').format(idea?.createdAt ?? DateTime.now())}\n"
                        "${TranslatedText().updatedAt} : ${DateFormat('dd MMMM yyyy').format(idea?.updatedAt ?? DateTime.now())}\n"
                        "${TranslatedText().startDate} : ${DateFormat('dd MMMM yyyy - HH:mm').format(idea?.tglPelaksanaan ?? DateTime.now())}\n",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.justify,
                      ),
                      Text(
                        "Konten",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      idea!.content.isNotEmpty ? Container(
                        height: 126 * lengthContent.toDouble(),
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: idea?.content.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              color: Theme.of(context).cardColor,
                              child: ListTile(
                                title: Text(
                                  idea?.content[index].title ?? "-",
                                  style: StyleText.listTileTitle,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      idea?.content[index].caption ?? "-",
                                      style: StyleText.listTileSubtitle,
                                    ),
                                    Text(
                                      idea?.content[index].team ?? "-",
                                      style: StyleText.listTileSubtitle,
                                    ),
                                    Text(
                                      DateFormat('dd MMMM yyyy - HH:mm').format(
                                        idea?.content[index].postScheduled ??
                                            DateTime.now(),
                                      ),
                                      style: StyleText.listTileSubtitle,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ) : Text(
                        "Plan ini belum digunakan di konten manapun",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditIde(
                                    id: idea!.id,
                                  ),
                                ),
                              );
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
                              ideaApi.delete(idea!.id).then((value) {
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
