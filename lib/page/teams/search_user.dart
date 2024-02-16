import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:visivista/api/base_url.dart';
import 'package:visivista/api/teams_api.dart';
import 'package:visivista/api/user_api.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/team_member.dart';
import 'package:visivista/model/user.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/page/teams/team_member_list_page.dart';
import 'package:visivista/style/alerts.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

final FlutterLocalNotificationsPlugin fLutterLocalNotificationPlugin =
    FlutterLocalNotificationsPlugin();

class SearchUser extends StatefulWidget {
  const SearchUser(
      {super.key,
      required this.idTeam,
      required this.nama,
      required this.teamName});

  final int idTeam;
  final String nama;
  final String teamName;

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  bool isButtonVisible = false;
  UserApi userApi = UserApi();
  late Future dataUser;
  List<User> itemList = [];
  List<User> selectedUsers = [];
  bool isLoading = true;
  TeamsApi teamApi = TeamsApi();
  late Future dataTeamMember;
  List<TeamMember> memberOnTeam = [];

  void search(String search) {
    if (search.isEmpty) {
      itemList = [];
    } else {
      dataUser = userApi.searchUser(search);
      dataUser.then((value) {
        setState(() {
          itemList = value;
          isLoading = false;
        });
      });
    }
  }

  @override
  void initState() {
    dataTeamMember = teamApi.indexMemberByTeam(widget.idTeam);
    dataTeamMember.then((value) {
      setState(() {
        memberOnTeam = value;
        isLoading = false;
      });
    });
    super.initState();
  }

  void handleCheckbox(User user, bool isChecked) {
    setState(() {
      if (isChecked) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBack(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                search(value);
              },
              decoration: InputDecoration(
                  labelText: TranslatedText().searchUser,
                  prefixIcon: const Icon(Icons.search)),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      color: Theme.of(context).cardColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: ListTile(
                        leading: ClipOval(
                          child: itemList[index].profilePict == null
                              ? Image.asset(
                                  "assets/background/pp_default.png",
                                  width: 37,
                                  height: 37,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  "${GlobalApi.getBaseUrl()}user/userPict/${itemList[index].profilePict}",
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
                          itemList[index].nama,
                          style: StyleText.listTileTitle,
                        ),
                        subtitle: Text(
                          itemList[index].email,
                          style: StyleText.listTileSubtitle,
                        ),
                        trailing: RoundCheckBox(
                          isRound: true,
                          borderColor: ColorPalette.black,
                          animationDuration: const Duration(milliseconds: 300),
                          size: 30,
                          isChecked: selectedUsers
                              .any((user) => user.id == itemList[index].id),
                          checkedColor: ColorPalette.secondary,
                          uncheckedColor: ColorPalette.white,
                          onTap: (selected) {
                            handleCheckbox(itemList[index], selected!);
                          },
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: selectedUsers.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                for (var i = 0; i < selectedUsers.length; i++) {
                  bool isUserInTeam = memberOnTeam.any((member) =>
                      member.idUser == selectedUsers[i].id.toString());
                  if (!isUserInTeam) {
                    await TeamsApi()
                        .inviteToTeam(widget.idTeam, selectedUsers[i].id);
                    TeamsApi().sendNotification(
                        widget.idTeam,
                        selectedUsers[i].id,
                        "${widget.nama} has invited you to team ${widget.teamName}",
                        "Team Invitation");
                  }
                }
                // ignore: use_build_context_synchronously
                AppAlert().showSuccessAlert(context,
                    TranslatedText().teamMember + TranslatedText().successAdd);
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeamMemberListPage(
                            idTeam: widget.idTeam,
                            teamName: widget.teamName,
                          )),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Icon(
                Icons.check_rounded,
                color: ColorPalette.white,
              ),
            )
          : null,
    );
  }
}
