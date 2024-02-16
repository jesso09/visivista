import 'package:flutter/material.dart';
import 'package:visivista/api/content_api.dart';
import 'package:visivista/api/idea_api.dart';
import 'package:visivista/api/task_api.dart';
import 'package:visivista/main.dart';
import 'package:visivista/model/content.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/idea.dart';
import 'package:visivista/model/task.dart';
import 'package:visivista/page/layout/home_idea.dart';
import 'package:visivista/page/layout/home_new_content.dart';
import 'package:visivista/page/layout/home_task_today.dart';
import 'package:visivista/page/layout/loading_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future dataToko;
  late Future dataFav;
  late Future dataList;
  List<Idea> listIde = [];
  List<Task> listTask = [];
  List<Content> listContent = [];
  bool isLoading = true;

  void refreshData() async {
    try {
      // get all data toko
      List<Idea> dataIde = await IdeaApi().getDataIdea();
      // get all data favorite
      List<Task> dataTask = await TaskApi().getDataTask();
      // // get all data produk
      List<Content> dataContent = await ContentApi().getDataContent();

      setState(() {
        listIde = dataIde;
        listTask = dataTask;
        listContent = dataContent;
        isLoading = false;
      });
    } catch (error) {
      return;
    }
  }

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // appBar: AppBar(
        //   backgroundColor: ColorPalette.primary,
        //   titleTextStyle: StyleText.appBarFont,
        //   title: const Text("Discover"),
        //   elevation: 0,
        //   automaticallyImplyLeading: false,
        // ),
        body: isLoading
            ? const LoadingPage()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task Today
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rencanamu",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          GestureDetector(
                            onTap: () {
                              GlobalItem.indexPage = 2;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyHomePage(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text(
                              "Lihat Semua",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          )
                        ],
                      ),
                      HomeIdea(listIdea: listIde),
                      // Konten baru dibuat
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tugas Hari ini",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          GestureDetector(
                            onTap: () {
                              GlobalItem.indexPage = 3;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyHomePage(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text(
                              "Lihat Semua",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          )
                        ],
                      ),
                      TaskToday(listTask: listTask),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Konten baru dibuat",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          GestureDetector(
                            onTap: () {
                              GlobalItem.indexPage = 1;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyHomePage(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text(
                              "Lihat Semua",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          )
                        ],
                      ),
                      HomeNewContent(listContent: listContent),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
