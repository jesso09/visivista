import 'package:flutter/material.dart';
import 'package:visivista/main.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/page/teams/team_list_page.dart';

class AppBarWithBack extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithBack({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void doMove(BuildContext context) {
    if (GlobalItem.memberList == true) {
      GlobalItem.memberList = false;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const TeamsListPage()),
        (Route<dynamic> route) => false,
      );
    } else {
      GlobalItem.indexPage = GlobalItem.tempIndex;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.4,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(GlobalItem.logoApp)),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "VisiVista",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontFamily: 'BalooChettan2',
            ),
          ),
        ],
      ),
      leading: IconButton(
        onPressed: () {
          doMove(context);
        },
        icon: const Icon(Icons.arrow_back_ios_outlined),
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      backgroundColor: Theme.of(context).bottomAppBarTheme.color,
      automaticallyImplyLeading: false,
    );
  }
}
