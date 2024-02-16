import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:visivista/api/auth.dart';
import 'package:visivista/api/base_url.dart';
import 'package:visivista/api/user_api.dart';
import 'package:visivista/firebase_options.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/user.dart';
import 'package:visivista/page/content/add_content.dart';
import 'package:visivista/page/content/content_list_page.dart';
import 'package:visivista/page/content/content_timeline.dart';
import 'package:visivista/page/content/posted_content.dart';
import 'package:visivista/page/idea/add_ide.dart';
import 'package:visivista/page/idea/idea_list_page.dart';
import 'package:visivista/page/layout/landing_page.dart';
import 'package:visivista/page/layout/settings.dart';
import 'package:visivista/page/layout/splash.dart';
import 'package:visivista/page/task/add_task.dart';
import 'package:visivista/page/task/checked_task_page.dart';
import 'package:visivista/page/task/task_list_page.dart';
import 'package:visivista/page/teams/team_list_page.dart';
import 'package:visivista/page/task/task_timeline.dart';
import 'package:visivista/page/user/home_page.dart';
import 'package:visivista/page/user/profile_page.dart';
import 'package:visivista/style/alerts.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/notifications.dart';
import 'package:visivista/style/text_style.dart';
import 'package:visivista/style/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotification();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(), // Menyediakan ThemeProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context, listen: false).loadTheme();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: Provider.of<ThemeProvider>(context).currentTheme,
      theme: ThemeApp().lightTheme,
      darkTheme: ThemeApp().darkTheme,
      home: const Splash(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int selectedIndex = GlobalItem.indexPage;
  String iconNav = 'assets/icon/home_icon.png';
  late final List<bool> isPlayedIcon;
  String foto = "";
  UserApi userApi = UserApi();
  User? user;
  late Future dataUser;
  String baseUrl = GlobalApi.getBaseUrl();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isPlayedIcon = List<bool>.generate(5, (index) => false);
    dataUser = Authentication().getUserInfo(GlobalItem.userToken).then((value) {
      setState(() {
        user = value;
        if (user?.profilePict != null) {
          foto = "${baseUrl}user/userPict/${user!.profilePict}";
          isLoading = false;
        }
      });
    });
  }

  void onItemTapped(int index) {
    setState(() {
      isPlayedIcon[selectedIndex] = false;

      isPlayedIcon[index] = true;
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          isPlayedIcon[index] = false;
        });
      });
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (GlobalItem.isAlreadyLoggedIn == true) {
          SystemNavigator.pop();
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover, image: AssetImage(GlobalItem.logoApp)),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "VisiVista",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontFamily: StyleText.textFontFamily,
                ),
              ),
            ],
          ),
          elevation: 0.4,
          backgroundColor: Theme.of(context).bottomAppBarTheme.color,
          automaticallyImplyLeading: false,
        ),
        body: selectedIndex == 1
            ? const ListContent()
            : selectedIndex == 2
                ? const ListIdea()
                : selectedIndex == 3
                    ? const ListTask()
                    : selectedIndex == 4
                        ? const ProfilePage()
                        : const HomePage(),
        floatingActionButton:
            selectedIndex == 1 || selectedIndex == 2 || selectedIndex == 3
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => selectedIndex == 1
                              ? const AddContent()
                              : selectedIndex == 2
                                  ? const AddIde()
                                  : const AddTask()));
                    },
                    tooltip: selectedIndex == 1
                        ? TranslatedText().addContent
                        : selectedIndex == 2
                            ? TranslatedText().addPlan
                            : TranslatedText().addTask,
                    backgroundColor: ColorPalette.secondary,
                    child: Icon(
                      selectedIndex == 1 ? Icons.movie_edit : Icons.edit_square,
                      color: ColorPalette.white,
                    ),
                  )
                : null,
        endDrawer: Drawer(
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  padding: const EdgeInsets.all(0),
                  child: user?.profilePict == null
                      ? Image.asset(
                          "assets/background/pp_default.png",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          // : Image.asset(
                          foto,
                          // "assets/background/pp_default.png",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          headers: {
                            'Authorization': 'Bearer ${GlobalItem.userToken}',
                          },
                        ),
                ),
                ListTile(
                  titleTextStyle: Theme.of(context).textTheme.bodySmall,
                  title: Text(TranslatedText().postedContent),
                  onTap: () {
                    GlobalItem.tempIndex = selectedIndex;
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PostedContent()));
                  },
                ),
                ListTile(
                  titleTextStyle: Theme.of(context).textTheme.bodySmall,
                  title: Text(TranslatedText().completedTask),
                  onTap: () {
                    GlobalItem.tempIndex = selectedIndex;
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CheckedList()));
                  },
                ),
                ListTile(
                  titleTextStyle: Theme.of(context).textTheme.bodySmall,
                  title: Text(TranslatedText().contentCalendar),
                  onTap: () {
                    GlobalItem.tempIndex = selectedIndex;
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ContentTimeline()));
                  },
                ),
                ListTile(
                  titleTextStyle: Theme.of(context).textTheme.bodySmall,
                  title: const Text("Task Calendar"),
                  onTap: () {
                    GlobalItem.tempIndex = selectedIndex;
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TaskTimeline(),
                      ),
                    );
                  },
                ),
                ListTile(
                  titleTextStyle: Theme.of(context).textTheme.bodySmall,
                  title: Text(TranslatedText().team),
                  onTap: () {
                    GlobalItem.tempIndex = selectedIndex;
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TeamsListPage()));
                  },
                ),
                ListTile(
                  titleTextStyle: Theme.of(context).textTheme.bodySmall,
                  title: Text(TranslatedText().settings),
                  onTap: () {
                    GlobalItem.isSettingsPage = true;
                    GlobalItem.tempIndex = selectedIndex;
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Settings()));
                  },
                ),
                ListTile(
                    titleTextStyle: Theme.of(context).textTheme.labelSmall,
                    title: Text(TranslatedText().logout),
                    onTap: () {
                      AppAlert().showConfirmDialog(
                          context,
                          TranslatedText().logout,
                          TranslatedText().logoutConfrim, () {
                        Authentication().logout();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LandingPage()));
                      });
                    }
                    // onTap: () {
                    //   Authentication().logout();
                    //   Navigator.of(context).push(MaterialPageRoute(
                    //       builder: (context) => const LandingPage()));
                    // },
                    ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).bottomAppBarTheme.color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
            boxShadow: [
              BoxShadow(
                color: ColorPalette.black.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(
                  CupertinoIcons.house_fill,
                ),
                label: TranslatedText().home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.video_camera_back_sharp,
                ),
                label: TranslatedText().content,
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.lightbulb,
                ),
                label: TranslatedText().plan,
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.assignment,
                ),
                label: TranslatedText().task,
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.person,
                ),
                label: TranslatedText().profile,
              ),
            ],
            selectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'BalooChettan2',
            ),
            backgroundColor: Theme.of(context).bottomAppBarTheme.color,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            currentIndex: selectedIndex,
            onTap: onItemTapped,
          ),
        ),
      ),

      //   bottomNavigationBar: BottomNavigationBar(
      //     items: <BottomNavigationBarItem>[
      //       BottomNavigationBarItem(
      //         icon: const Icon(
      //           Icons.home,
      //         ),
      //         label: TranslatedText().home,
      //       ),
      //       BottomNavigationBarItem(
      //         icon: const Icon(
      //           Icons.video_camera_back_sharp,
      //         ),
      //         label: TranslatedText().content,
      //       ),
      //       BottomNavigationBarItem(
      //         icon: const Icon(
      //           Icons.lightbulb,
      //         ),
      //         label: TranslatedText().plan,
      //       ),
      //       BottomNavigationBarItem(
      //         icon: const Icon(
      //           Icons.assignment,
      //         ),
      //         label: TranslatedText().task,
      //       ),
      //       BottomNavigationBarItem(
      //         icon: const Icon(
      //           Icons.person,
      //         ),
      //         label: TranslatedText().profile,
      //       ),
      //     ],
      //     selectedLabelStyle: const TextStyle(
      //       fontSize: 16,
      //       fontWeight: FontWeight.bold,
      //       fontFamily: 'BalooChettan2',
      //     ),
      //     backgroundColor: Theme.of(context).bottomAppBarTheme.color,
      //     type: BottomNavigationBarType.fixed,
      //     selectedItemColor: Theme.of(context).colorScheme.primary,
      //     currentIndex: selectedIndex,
      //     showUnselectedLabels: false,
      //     onTap: onItemTapped,
      //   ),
      // ),

      //   bottomNavigationBar: BottomNavigationBar(
      //     items: <BottomNavigationBarItem>[
      //       BottomNavigationBarItem(
      //         icon: Lottie.asset(
      //           "assets/animated/home.json",
      //           width: 24,
      //           repeat: isPlayedIcon[0] ? true : false,
      //         ),
      //         label: TranslatedText().home,
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Lottie.asset(
      //           "assets/animated/content.json",
      //           width: 24,
      //           repeat: isPlayedIcon[1] ? true : false,
      //         ),
      //         label: TranslatedText().content,
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Lottie.asset(
      //           "assets/animated/bolt.json",
      //           width: 24,
      //           repeat: isPlayedIcon[2] ? true : false,
      //         ),
      //         label: TranslatedText().plan,
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Lottie.asset(
      //           "assets/animated/task.json",
      //           width: 24,
      //           repeat: isPlayedIcon[3] ? true : false,
      //         ),
      //         label: TranslatedText().task,
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Lottie.asset(
      //           "assets/animated/profile.json",
      //           width: 24,
      //           repeat: isPlayedIcon[4] ? true : false,
      //         ),
      //         label: TranslatedText().profile,
      //       ),
      //     ],
      //     selectedLabelStyle: const TextStyle(
      //       fontSize: 16,
      //       fontWeight: FontWeight.bold,
      //       fontFamily: 'BalooChettan2',
      //     ),
      //     backgroundColor: Theme.of(context).bottomAppBarTheme.color,
      //     type: BottomNavigationBarType.fixed,
      //     selectedItemColor: Theme.of(context).colorScheme.onPrimary,
      //     currentIndex: selectedIndex,
      //     showUnselectedLabels: false,
      //     onTap: onItemTapped,
      //   ),
      // ),

      // SalomonBottomBar(
      //   currentIndex: selectedIndex,
      //   onTap: onItemTapped,
      //   selectedItemColor: ColorPalette.secondary,
      //   unselectedItemColor: ColorPalette.secondary,
      //   items: [
      //     /// Home
      //     SalomonBottomBarItem(
      //       icon: const Icon(CupertinoIcons.house_fill),
      //       title: Text(TranslatedText().home),
      //     ),

      //     /// Likes
      //     SalomonBottomBarItem(
      //       icon: const Icon(Icons.video_camera_back_sharp),
      //       title: Text(TranslatedText().content),
      //     ),

      //     SalomonBottomBarItem(
      //       icon: const Icon(CupertinoIcons.lightbulb_fill),
      //       title: Text(TranslatedText().plan),
      //     ),

      //     /// Profile
      //     SalomonBottomBarItem(
      //       icon: const Icon(Icons.assignment),
      //       title: Text(TranslatedText().task),
      //     ),

      //     SalomonBottomBarItem(
      //       icon: const Icon(CupertinoIcons.person_circle_fill),
      //       title: Text(TranslatedText().profile),
      //     ),
      //   ],
      // ),
    );
  }
}
