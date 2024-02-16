import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:visivista/api/base_url.dart';
import 'package:visivista/api/content_api.dart';
import 'package:visivista/api/task_api.dart';
import 'package:visivista/api/user_api.dart';
import 'package:visivista/model/content.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/task.dart';
import 'package:visivista/model/user.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:visivista/page/user/edit_profile.dart';
import 'package:visivista/style/color_palete.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isChecked = false;
  bool isLoading = true;
  UserApi userApi = UserApi();
  User? user;
  late Future dataUser;
  String foto = "";
  String baseUrl = GlobalApi.getBaseUrl();
  TaskApi taskApi = TaskApi();
  late Future dataTask;
  List<Task> taskList = [];
  List<Task> checkedTask = [];
  ContentApi contentApi = ContentApi();
  late Future dataContent;
  List<Content> contentList = [];
  List<Content> postedContent = [];

  @override
  void initState() {
    dataUser = userApi.getDataUser().then((value) {
      setState(() {
        user = value;
        if (user?.profilePict != null) {
          foto = "${baseUrl}user/userPict/${user!.profilePict}";
          // foto = '${baseUrl}userPict/${user?.profilePict}';
        }
      });
    }).then((value) {
      dataTask = taskApi.getDataTask();
      dataTask.then((value) {
        setState(() {
          taskList = value;
        });
      });
      dataTask = taskApi.indexChecked();
      dataTask.then((value) {
        setState(() {
          checkedTask = value;
        });
      });
      dataContent = contentApi.getDataContent();
      dataContent.then((value) {
        setState(() {
          contentList = value;
        });
      });
      dataContent = contentApi.indexPosted();
      dataContent.then((value) {
        setState(() {
          postedContent = value;
        });
      });
    }).then((value) {
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: isLoading
            ? const LoadingPage()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 190,
                      width: 700,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 50),
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      ColorPalette.primary,
                                      ColorPalette.secondary,
                                      ColorPalette.secondary,
                                    ]),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                )),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ClipOval(
                              child: user?.profilePict == null
                                  ? Container(
                                      height: 130,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        shape: BoxShape
                                            .circle, // Untuk membuat kontainer berbentuk lingkaran
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor, // Warna border
                                          width: 5, // Lebar border
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/background/pp_default.png",
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 130,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        shape: BoxShape
                                            .circle, // Untuk membuat kontainer berbentuk lingkaran
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor, // Warna border
                                          width: 5, // Lebar border
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          foto,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          headers: {
                                            'Authorization':
                                                'Bearer ${GlobalItem.userToken}',
                                          },
                                        ),
                                      )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).bottomAppBarTheme.color,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: ColorPalette.black.withOpacity(1),
                            spreadRadius: 1.5,
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ListTile(
                        titleTextStyle: Theme.of(context).textTheme.labelMedium,
                        subtitleTextStyle:
                            Theme.of(context).textTheme.labelSmall,
                        title: Text(
                          user?.nama ?? 'User',
                        ),
                        subtitle: Text(
                          user?.email ?? 'Email',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const EditProfile(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // const SizedBox(height: 20),
                    // Text(
                    //   TranslatedText().uMedSos,
                    //   style: Theme.of(context).textTheme.labelMedium,
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.all(10),
                    //   width: 338,
                    //   height: 180,
                    //   decoration: const BoxDecoration(
                    //     color: Color.fromRGBO(42, 157, 143, 1),
                    //     borderRadius: BorderRadius.all(Radius.circular(15)),
                    //   ),
                    //   child: SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child: Row(
                    //       children: [
                    //         //insta
                    //         Container(
                    //           decoration: const BoxDecoration(
                    //             color: Color.fromRGBO(38, 70, 83, 1),
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(15)),
                    //           ),
                    //           margin: const EdgeInsets.all(10),
                    //           width: 200,
                    //           height: 120,
                    //           child: Column(
                    //             children: [
                    //               Row(
                    //                 children: [
                    //                   Container(
                    //                       margin: const EdgeInsets.all(10),
                    //                       width: 50,
                    //                       height: 40,
                    //                       child: Image.asset(
                    //                           "assets/icon_sosmed/iconInsta.png")),
                    //                   const Text(
                    //                     "Instagram",
                    //                     style: TextStyle(
                    //                       color:
                    //                           Color.fromRGBO(255, 255, 255, 1),
                    //                       fontSize: 25,
                    //                       fontWeight: FontWeight.bold,
                    //                       fontFamily: 'BalooChettan2',
                    //                     ),
                    //                   )
                    //                 ],
                    //               ),
                    //               ElevatedButton(
                    //                 onPressed: () {},
                    //                 style: ElevatedButton.styleFrom(
                    //                   foregroundColor: Colors.black,
                    //                   backgroundColor: ColorPalette.green,
                    //                   fixedSize: const Size(170, 10),
                    //                   shape: RoundedRectangleBorder(
                    //                     borderRadius: BorderRadius.circular(50),
                    //                   ),
                    //                   elevation: 5,
                    //                 ),
                    //                 child: const Text(
                    //                   "Connected",
                    //                   style: StyleText.boldBtnText,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),

                    //         //tiktok
                    //         Container(
                    //           decoration: const BoxDecoration(
                    //             color: Color.fromRGBO(38, 70, 83, 1),
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(15)),
                    //           ),
                    //           margin: const EdgeInsets.all(10),
                    //           width: 200,
                    //           height: 120,
                    //           child: Column(
                    //             children: [
                    //               Row(
                    //                 children: [
                    //                   Container(
                    //                       margin: const EdgeInsets.all(10),
                    //                       width: 50,
                    //                       height: 40,
                    //                       child: Image.asset(
                    //                           "assets/icon_sosmed/iconTiktok.png")),
                    //                   const Text(
                    //                     "TikTok",
                    //                     style: TextStyle(
                    //                       color:
                    //                           Color.fromRGBO(255, 255, 255, 1),
                    //                       fontSize: 25,
                    //                       fontWeight: FontWeight.bold,
                    //                       fontFamily: 'BalooChettan2',
                    //                     ),
                    //                   )
                    //                 ],
                    //               ),
                    //               ElevatedButton(
                    //                 onPressed: () {},
                    //                 style: ElevatedButton.styleFrom(
                    //                   foregroundColor: Colors.black,
                    //                   backgroundColor: ColorPalette.green,
                    //                   fixedSize: const Size(170, 10),
                    //                   shape: RoundedRectangleBorder(
                    //                     borderRadius: BorderRadius.circular(50),
                    //                   ),
                    //                   elevation: 5,
                    //                 ),
                    //                 child: const Text(
                    //                   "Connected",
                    //                   style: StyleText.boldBtnText,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    Text(
                      "Chart Task",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Container(
                      width: 338,
                      height: 270,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(38, 70, 83, 1),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1.3,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.circle,
                                    color: ColorPalette.burntSienna,
                                  ),
                                  Text(
                                    "Completed Task",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(width: 7),
                                  const Icon(
                                    Icons.circle,
                                    color: ColorPalette.saffron,
                                  ),
                                  Text(
                                    "Created Task",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  )
                                ]),
                            Expanded(
                              child: PieChart(PieChartData(
                                startDegreeOffset: 180,
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                // sectionsSpace: 1,
                                centerSpaceRadius: 50,
                                sections: [
                                  PieChartSectionData(
                                      value: checkedTask.length.toDouble(),
                                      title: checkedTask.length.toString(),
                                      color: ColorPalette.burntSienna,
                                      titleStyle: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  PieChartSectionData(
                                      value: taskList.length.toDouble(),
                                      title: taskList.length.toString(),
                                      color: ColorPalette.saffron,
                                      titleStyle: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                ],
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //chart content
                    const SizedBox(height: 20),
                    Text(
                      "Chart Content",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Container(
                      width: 338,
                      height: 270,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(38, 70, 83, 1),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1.3,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.circle,
                                    color: ColorPalette.green,
                                  ),
                                  Text(
                                    "Created Content",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(width: 7),
                                  const Icon(
                                    Icons.circle,
                                    color: ColorPalette.yellow,
                                  ),
                                  Text(
                                    "Posted Content",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  )
                                ]),
                            Expanded(
                              child: PieChart(PieChartData(
                                startDegreeOffset: 180,
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                centerSpaceRadius: 50,
                                sections: [
                                  PieChartSectionData(
                                      value: contentList.length.toDouble(),
                                      title: contentList.length.toString(),
                                      color: ColorPalette.green,
                                      titleStyle: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  PieChartSectionData(
                                      value: postedContent.length.toDouble(),
                                      title: postedContent.length.toString(),
                                      color: ColorPalette.yellow,
                                      titleStyle: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                ],
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
