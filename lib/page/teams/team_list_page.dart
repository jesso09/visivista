import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:visivista/api/teams_api.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/team_member.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/page/layout/empty_data_page.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:visivista/page/teams/team_member_list_page.dart';
import 'package:visivista/style/alerts.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class TeamsListPage extends StatefulWidget {
  const TeamsListPage({super.key});

  @override
  State<TeamsListPage> createState() => _TeamsListPageState();
}

class _TeamsListPageState extends State<TeamsListPage> {
  final TextEditingController nameTeamController = TextEditingController();
  bool isButtonVisible = false;
  TeamsApi teamsApi = TeamsApi();
  late Future dataTeams;
  List<TeamMember> itemList = [];
  bool isLoading = true;
  int teamId = 0;
  String teamName = "";
  String nama = "";

  void refreshData() {
    dataTeams = teamsApi.indexTeamByMember();
    dataTeams.then((value) {
      setState(() {
        itemList = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    dataTeams = teamsApi.indexTeamByMember();
    dataTeams.then((value) {
      setState(() {
        itemList = value;
        isLoading = false;
      });
    }).then((value) {
      for (var i = 0; i < itemList.length; i++) {
        if (GlobalItem.userID == itemList[i].user!.id) {
          setState(() {
            nama = itemList[i].user!.nama;
          });
        }
      }
    });
    super.initState();
  }

  void teamBottomSheet(BuildContext context, String action) {
    if (action == "add") {
      nameTeamController.text = '';
    } else {
      nameTeamController.text = teamName;
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Form(
                        child: Theme(
                          data: ThemeData(
                            inputDecorationTheme:
                                Theme.of(context).inputDecorationTheme,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Team Name
                              Text(
                                TranslatedText().teamName,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              TextFormField(
                                maxLines: 5,
                                minLines: 1,
                                decoration: const InputDecoration(
                                  labelText: 'Enter Team Name',
                                ),
                                textInputAction: TextInputAction.next,
                                controller: nameTeamController,
                                cursorColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (action == "add") {
                          teamsApi
                              .addTeam(
                            nameTeamController.text,
                          )
                              .then((value) {
                            if (value) {
                              teamsApi
                                  .addOwnertoTeam(
                                GlobalItem.newTeamId,
                              )
                                  .then((value) {
                                refreshData();
                              });
                              Navigator.pop(context);
                              nameTeamController.text = "";
                              AppAlert().showSuccessAlert(
                                  context, TranslatedText().successAddTeam);
                            } else {
                              Navigator.pop(context);
                              AppAlert().showFailedAlert(
                                  context, TranslatedText().failedAddTeam);
                            }
                          });
                          refreshData();
                        } else if (action == "edit") {
                          teamsApi
                              .editTeam(
                            teamId,
                            nameTeamController.text,
                          )
                              .then((value) {
                            if (value) {
                              teamsApi.addOwnertoTeam(
                                GlobalItem.newTeamId,
                              );
                              Navigator.pop(context);
                              nameTeamController.text = "";
                              AppAlert().showSuccessAlert(
                                  context, TranslatedText().successEditTeam);
                            } else {
                              Navigator.pop(context);
                              AppAlert().showFailedAlert(
                                  context, TranslatedText().failedEditTeam);
                            }
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ColorPalette.black,
                        backgroundColor: ColorPalette.green,
                        fixedSize: const Size(100, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        TranslatedText().save,
                        style: StyleText.btnText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      child: Scaffold(
        appBar: const AppBarWithBack(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: isLoading
            ? const LoadingPage()
            : itemList.isEmpty
                ? const EmptyData()
                : SlidableAutoCloseBehavior(
                    child: ListView.builder(
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Slidable(
                              endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: ColorPalette.red,
                                      icon: Icons.delete_forever_rounded,
                                      label: GlobalItem.userID ==
                                              int.parse(
                                                  itemList[index].team!.idOwner)
                                          ? TranslatedText().delete
                                          : TranslatedText().quit,
                                      borderRadius: BorderRadius.circular(15),
                                      onPressed: (context) {
                                        if (GlobalItem.userID ==
                                            int.parse(itemList[index]
                                                .team!
                                                .idOwner)) {
                                          teamsApi
                                              .delete(itemList[index].team!.id)
                                              .then((value) {
                                            refreshData();
                                          });
                                          AppAlert().showSuccessAlert(context,
                                              TranslatedText().teamDeleted);
                                        } else if (GlobalItem.userID !=
                                            int.parse(itemList[index]
                                                .team!
                                                .idOwner)) {
                                          teamsApi
                                              .quit(itemList[index].id)
                                              .then((value) {
                                            TeamsApi().sendNotification(
                                                int.parse(
                                                    itemList[index].idTeam),
                                                int.parse(itemList[index]
                                                    .team!
                                                    .idOwner),
                                                "$nama has left the team ${itemList[index].team?.teamName}",
                                                "Team Member leave");
                                            refreshData();
                                          });
                                          AppAlert().showSuccessAlert(context,
                                              TranslatedText().quitFromTeam);
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 6),
                                    //hosting
                                    GlobalItem.userID ==
                                            int.parse(
                                                itemList[index].team!.idOwner)
                                        //localHost
                                        // GlobalItem.userID == itemList[index].team!.idOwner
                                        ? SlidableAction(
                                            backgroundColor: ColorPalette.blue,
                                            icon: Icons.edit,
                                            foregroundColor: ColorPalette.white,
                                            label: TranslatedText().edit,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            onPressed: (context) {
                                              teamId = itemList[index].team!.id;
                                              teamName = itemList[index]
                                                  .team!
                                                  .teamName;
                                              teamBottomSheet(context, "edit");
                                            },
                                          )
                                        : Container(),
                                  ]),
                              child: Card(
                                color: Theme.of(context).cardColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                child: ListTile(
                                  title: Text(
                                    itemList[index].team!.teamName,
                                    style: StyleText.listTileTitle,
                                  ),
                                  subtitle: Text(
                                    "${TranslatedText().owner} : ${itemList[index].team!.user!.nama}",
                                    style: StyleText.listTileSubtitle,
                                  ),
                                  onTap: () {
                                    GlobalItem.memberList = true;
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TeamMemberListPage(
                                                  idTeam:
                                                      itemList[index].team!.id,
                                                  teamName: itemList[index]
                                                      .team!
                                                      .teamName,
                                                )));
                                  },
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            teamBottomSheet(context, "add");
            refreshData();
          },
          tooltip: TranslatedText().addTeam,
          child: const Icon(
            Icons.groups_3,
            color: ColorPalette.white,
          ),
        ),
      ),
    );
  }
}
