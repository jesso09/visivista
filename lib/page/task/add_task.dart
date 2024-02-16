import 'package:flutter/material.dart';
import 'package:visivista/api/task_api.dart';
import 'package:visivista/api/teams_api.dart';
import 'package:visivista/main.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/team_member.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController tittleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startController = TextEditingController();
  final TextEditingController actuatorController = TextEditingController();
  final TextEditingController endingController = TextEditingController();
  String? selectedTeam;
  bool selectedFromTeam = false;
  String? selectedUser;
  TeamsApi teamsApi = TeamsApi();
  late Future dataTeams;
  late Future dataTeamMember;
  List<TeamMember> teamList = [];
  List<TeamMember> memberList = [];

  @override
  void initState() {
    dataTeams = teamsApi.indexTeamByMember();
    dataTeams.then((value) {
      setState(() {
        teamList = value;
        selectedUser = "Manual";
      });
    });
    super.initState();
  }

  List<DropdownMenuItem<String>> get dropDownMetode {
    List<DropdownMenuItem<String>> menuItems = [];

    for (int index = 0; index < teamList.length; index++) {
      menuItems.add(
        DropdownMenuItem(
          value: teamList[index].team!.id.toString(),
          child: Text(
              "${teamList[index].team!.teamName} - Owner : ${teamList[index].team!.user!.nama}"),
        ),
      );
    }
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropDownMember {
    List<DropdownMenuItem<String>> memberItem = [];
    if (selectedFromTeam == true) {
      dataTeamMember = teamsApi.indexMemberByTeam(int.parse(selectedTeam!));
      dataTeamMember.then((value) {
        setState(() {
          memberList = value;
          selectedFromTeam = false;
        });
      });
    }
    memberItem.add(
      const DropdownMenuItem(
        value: "Manual",
        child: Text("Input Manualy"),
      ),
    );
    for (int i = 0; i < memberList.length; i++) {
      memberItem.add(
        DropdownMenuItem(
          value: memberList[i].user!.id.toString(),
          child: Text(memberList[i].user!.nama),
        ),
      );
    }

    return memberItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const AppBarWithBack(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              child: Theme(
                data: ThemeData(
                  inputDecorationTheme: Theme.of(context).inputDecorationTheme,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //tittle
                    Text(
                      TranslatedText().title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextFormField(
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                        labelText: TranslatedText().title,
                      ),
                      textInputAction: TextInputAction.next,
                      controller: tittleController,
                      cursorColor: Theme.of(context).colorScheme.onPrimary,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 20),

                    //description
                    Text(
                      TranslatedText().description,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextFormField(
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                        labelText: TranslatedText().description,
                      ),
                      textInputAction: TextInputAction.next,
                      controller: descriptionController,
                      cursorColor: Theme.of(context).colorScheme.onPrimary,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 20),

                    //actuator
                    Text(
                      TranslatedText().actuator,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: TranslatedText().selectedFromTeam,
                      ),
                      items: dropDownMetode,
                      value: selectedTeam,
                      dropdownColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      style: Theme.of(context).textTheme.displaySmall,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedTeam = newValue;
                          selectedFromTeam = true;
                          selectedUser = null;
                        });
                      },
                    ),
                    const SizedBox(height: 5),
                    selectedTeam != null
                        ? DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: TranslatedText().selectedUser,
                            ),
                            items: dropDownMember,
                            value: selectedUser,
                            dropdownColor: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            style: Theme.of(context).textTheme.displaySmall,
                            onChanged: (String? newValue) {
                              setState(() {
                                if (newValue == "Manual") {
                                  selectedFromTeam = false;
                                  selectedTeam = null;
                                }
                                selectedUser = newValue;
                              });
                            },
                          )
                        : TextFormField(
                            maxLines: 5,
                            minLines: 1,
                            decoration: InputDecoration(
                              labelText: TranslatedText().actuator,
                            ),
                            textInputAction: TextInputAction.next,
                            controller: actuatorController,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                    const SizedBox(height: 20),

                    //Starting Date
                    Text(
                      TranslatedText().startDate,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: TranslatedText().startDate,
                      ),
                      textInputAction: TextInputAction.next,
                      controller: startController,
                      readOnly: true,
                      style: Theme.of(context).textTheme.displaySmall,
                      onTap: () {
                        DateTimePicker.selectDateTime(context, startController);
                      },
                    ),
                    const SizedBox(height: 20),

                    //ending date
                    Text(
                      TranslatedText().endDate,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: TranslatedText().endDate,
                      ),
                      textInputAction: TextInputAction.next,
                      controller: endingController,
                      readOnly: true,
                      style: Theme.of(context).textTheme.displaySmall,
                      onTap: () {
                        DateTimePicker.selectDateTime(
                            context, endingController);
                      },
                    ),
                    const SizedBox(height: 45),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //cancel btn
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: ColorPalette.black,
                            backgroundColor: ColorPalette.red,
                            fixedSize: const Size(110, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            TranslatedText().cancel,
                            style: StyleText.btnText,
                          ),
                        ),
                        const SizedBox(width: 10),
                        //save btn
                        ElevatedButton(
                          onPressed: () {
                            String? actuatorID;
                            if (selectedUser == "Manual") {
                              selectedUser == null;
                              selectedTeam == "";
                            } else if (selectedUser != "Manual") {
                              actuatorController.text = "";
                              actuatorID = selectedUser;
                            }
                            TaskApi()
                                .addTask(
                              actuatorID,
                              selectedTeam,
                              tittleController.text,
                              descriptionController.text,
                              actuatorController.text,
                              startController.text,
                              endingController.text,
                            )
                                .then((value) {
                              if (value) {
                                if (actuatorID != null) {
                                  if (int.parse(actuatorID) !=
                                          GlobalItem.userID &&
                                      actuatorID != "") {
                                    TeamsApi().sendNotification(
                                        int.parse(selectedTeam!),
                                        int.parse(actuatorID),
                                        "Hey, There is a new task was made for you",
                                        "New Task");
                                  }
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Added",
                                      style: StyleText.boldBtnText,
                                    ),
                                    backgroundColor: ColorPalette.green,
                                  ),
                                );
                                GlobalItem.indexPage = 3;
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MyHomePage()),
                                  (Route<dynamic> route) => false,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Failed adding data",
                                      style: StyleText.boldBtnText,
                                    ),
                                    backgroundColor: ColorPalette.red,
                                  ),
                                );
                              }
                            });
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
