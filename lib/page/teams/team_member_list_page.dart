import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:visivista/api/base_url.dart';
import 'package:visivista/api/teams_api.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/team_member.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/page/layout/empty_data_page.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:visivista/page/task/task_by_team.dart';
import 'package:visivista/page/teams/search_user.dart';
import 'package:visivista/page/teams/team_list_page.dart';
import 'package:visivista/style/alerts.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class TeamMemberListPage extends StatefulWidget {
  const TeamMemberListPage(
      {super.key, required this.idTeam, required this.teamName});

  final int idTeam;
  final String teamName;

  @override
  State<TeamMemberListPage> createState() => _TeamMemberListPageState();
}

class _TeamMemberListPageState extends State<TeamMemberListPage> {
  bool isButtonVisible = false;
  TeamsApi teamApi = TeamsApi();
  late Future dataTeamMember;
  List<TeamMember> itemList = [];
  bool isLoading = true;
  bool isOwner = false;
  String nama = "";

  void refreshData() {
    dataTeamMember = teamApi.indexMemberByTeam(widget.idTeam);
    dataTeamMember.then((value) {
      setState(() {
        itemList = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    dataTeamMember = teamApi.indexMemberByTeam(widget.idTeam);
    dataTeamMember.then((value) {
      setState(() {
        itemList = value;
        for (var i = 0; i < itemList.length; i++) {
          //hosting
          if (GlobalItem.userID == int.parse(itemList[i].team!.idOwner)) {
            // localHost
            // if (GlobalItem.userID == itemList[i].team!.idOwner) {
            nama = itemList[i].team?.user!.nama ?? "";
            isOwner = true;
          }
        }
        refreshData();
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      child: Scaffold(
        appBar: const AppBarWithBack(),
        body: DefaultTabController(
          length: 2, // Jumlah tab yang ingin ditampilkan
          child: Column(
            children: [
              const TabBar(
                indicatorColor: ColorPalette.secondary,
                labelColor: ColorPalette.secondary,
                tabs: [
                  Tab(
                      icon: Icon(
                    Icons.assignment,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.group_sharp,
                  )),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    TeamTaskList(
                      idTeam: widget.idTeam,
                    ),
                    isLoading
                        ? const LoadingPage()
                        : itemList.isEmpty
                            ? const EmptyData()
                            : SlidableAutoCloseBehavior(
                                child: ListView.builder(
                                    itemCount: itemList.length,
                                    itemBuilder: (context, index) {
                                      // hosting
                                      return GlobalItem.userID ==
                                              int.parse(
                                                  itemList[index].team!.idOwner)
                                          // localHost
                                          // return GlobalItem.userID == itemList[index].team!.idOwner
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Slidable(
                                                endActionPane: ActionPane(
                                                    motion:
                                                        const ScrollMotion(),
                                                    children: [
                                                      SlidableAction(
                                                        backgroundColor:
                                                            ColorPalette.red,
                                                        icon: Icons
                                                            .person_remove_rounded,
                                                        label: TranslatedText()
                                                            .kick,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        onPressed: (context) {
                                                          // String idUser = "";
                                                          // setState(() {
                                                          //   idUser = itemList[index].idUser;
                                                          // });
                                                          // print(idUser);
                                                          if (int.parse(itemList[
                                                                      index]
                                                                  .idUser) ==
                                                              GlobalItem
                                                                  .userID) {
                                                            teamApi.delete(
                                                                widget.idTeam);
                                                            AppAlert().showSuccessAlert(
                                                                context,
                                                                TranslatedText()
                                                                    .teamDeleted);
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const TeamsListPage()),
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false,
                                                            );
                                                          } else {
                                                            TeamsApi().sendNotification(
                                                                widget.idTeam,
                                                                int.parse(itemList[
                                                                        index]
                                                                    .idUser),
                                                                "You are kicked from team ${widget.teamName}",
                                                                "Kicked From Team");
                                                            teamApi
                                                                .quit(itemList[
                                                                        index]
                                                                    .id)
                                                                .then((value) {
                                                              refreshData();
                                                            });
                                                            AppAlert().showSuccessAlert(
                                                                context,
                                                                TranslatedText()
                                                                    .kickMember);
                                                          }
                                                        },
                                                      ),
                                                    ]),
                                                child: Card(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                  ),
                                                  child: ListTile(
                                                    leading: ClipOval(
                                                      child: itemList[index]
                                                                  .user
                                                                  ?.profilePict ==
                                                              null
                                                          ? Image.asset(
                                                              "assets/background/pp_default.png",
                                                              width: 37,
                                                              height: 37,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.network(
                                                              "${GlobalApi.getBaseUrl()}user/userPict/${itemList[index].user?.profilePict}",
                                                              width: 37,
                                                              height: 37,
                                                              fit: BoxFit.cover,
                                                              headers: {
                                                                'Authorization':
                                                                    'Bearer ${GlobalItem.userToken}',
                                                              },
                                                            ),
                                                    ),
                                                    title: Text(
                                                      itemList[index]
                                                          .user!
                                                          .nama,
                                                      style: StyleText
                                                          .listTileTitle,
                                                    ),
                                                    subtitle: Text(
                                                      itemList[index]
                                                          .user!
                                                          .email,
                                                      style: StyleText
                                                          .listTileSubtitle,
                                                    ),
                                                    // Hosting
                                                    trailing: itemList[index]
                                                                .user!
                                                                .id ==
                                                            int.parse(
                                                                itemList[index]
                                                                    .team!
                                                                    .idOwner)
                                                        // localHost
                                                        // trailing: itemList[index].user!.id == itemList[index].team!.idOwner
                                                        ? const Text(
                                                            "Owner",
                                                            style: StyleText
                                                                .listTileSubtitle,
                                                          )
                                                        : null,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Card(
                                                color:
                                                    Theme.of(context).cardColor,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                ),
                                                child: ListTile(
                                                  leading: ClipOval(
                                                    child: itemList[index]
                                                                .user
                                                                ?.profilePict ==
                                                            null
                                                        ? Image.asset(
                                                            "assets/background/pp_default.png",
                                                            width: 37,
                                                            height: 37,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.network(
                                                            "${GlobalApi.getBaseUrl()}userPict/${itemList[index].user?.profilePict}",
                                                            width: 37,
                                                            height: 37,
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                  title: Text(
                                                    itemList[index].user!.nama,
                                                    style:
                                                        StyleText.listTileTitle,
                                                  ),
                                                  subtitle: Text(
                                                    itemList[index].user!.email,
                                                    style: StyleText
                                                        .listTileSubtitle,
                                                  ),
                                                  // Hosting
                                                  trailing: itemList[index]
                                                              .user!
                                                              .id ==
                                                          int.parse(
                                                              itemList[index]
                                                                  .team!
                                                                  .idOwner)
                                                      // localHost
                                                      // trailing: itemList[index].user!.id == itemList[index].team!.idOwner
                                                      ? Text(
                                                          TranslatedText()
                                                              .owner,
                                                          style: StyleText
                                                              .listTileSubtitle,
                                                        )
                                                      : null,
                                                ),
                                              ),
                                            );
                                    }),
                              ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: !isOwner
            ? null
            : FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchUser(
                            idTeam: widget.idTeam,
                            nama: nama,
                            teamName: widget.teamName,
                          )));
                },
                tooltip: TranslatedText().inviteUser,
                child: const Icon(
                  Icons.person_add_alt_1_sharp,
                  color: ColorPalette.white,
                ),
              ),
      ),
    );
  }
}
