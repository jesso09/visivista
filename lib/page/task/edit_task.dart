import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visivista/api/task_api.dart';
import 'package:visivista/api/teams_api.dart';
import 'package:visivista/main.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/task.dart';
import 'package:visivista/model/team_member.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class EditTask extends StatefulWidget {
  const EditTask({super.key, required this.id});

  final int id;

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final TextEditingController tittleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startController = TextEditingController();
  final TextEditingController actuatorController = TextEditingController();
  final TextEditingController endingController = TextEditingController();
  TaskApi taskApi = TaskApi();
  Task? task;
  late Future dataTask;
  bool isLoading = true;
  String? selectedTeam;
  bool selectedFromTeam = false;
  String? selectedUser;
  TeamsApi teamsApi = TeamsApi();
  late Future dataTeams;
  late Future dataTeamMember;
  List<TeamMember> teamList = [];
  List<TeamMember> memberList = [];
  String? actuatorID;
  String? teamId;
  String? labelUser;

  @override
  void initState() {
    dataTask = taskApi.getTask(widget.id);
    dataTask.then((value) {
      setState(() {
        task = value;
        tittleController.text = task!.title;
        descriptionController.text = task!.description;
        actuatorController.text =
            task?.actuator ?? task?.actuatorUser?.nama ?? "";
        actuatorID = task?.idActuator;
        if (task?.idTeams != null) {
          selectedFromTeam = true;
          selectedTeam = task?.idTeams.toString();
          labelUser = task?.actuatorUser?.nama;
        }
        teamId = task?.idTeams ?? "";
        startController.text =
            DateFormat('yyyy-MM-dd HH:mm').format(task!.start);
        endingController.text =
            DateFormat('yyyy-MM-dd HH:mm').format(task!.end);
        isLoading = false;
        selectedUser = "Manual";
      });
    });
    dataTeams = teamsApi.indexTeamByMember();
    dataTeams.then((value) {
      setState(() {
        teamList = value;
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
      body: isLoading
          ? const LoadingPage()
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    child: Theme(
                      data: ThemeData(
                        inputDecorationTheme:
                            Theme.of(context).inputDecorationTheme,
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
                            decoration: const InputDecoration(
                                labelText: "Title",
                                labelStyle: StyleText.formLabelStyle),
                            textInputAction: TextInputAction.next,
                            controller: tittleController,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
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
                            decoration: const InputDecoration(
                                labelText: "Description",
                                labelStyle: StyleText.formLabelStyle),
                            textInputAction: TextInputAction.next,
                            controller: descriptionController,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
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
                              labelText: labelUser ?? TranslatedText().selectedUser,
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
                                  decoration: const InputDecoration(
                                    labelText: "Actuator",
                                  ),
                                  textInputAction: TextInputAction.next,
                                  controller: actuatorController,
                                  cursorColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                          const SizedBox(height: 20),

                          //Starting Date
                          Text(
                            TranslatedText().startDate,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Start Date",
                                labelStyle: StyleText.formLabelStyle),
                            textInputAction: TextInputAction.next,
                            controller: startController,
                            readOnly: true,
                            style: Theme.of(context).textTheme.displaySmall,
                            onTap: () {
                              DateTimePicker.selectDateTime(
                                  context, startController);
                            },
                          ),
                          const SizedBox(height: 20),

                          //ending date
                          Text(
                            TranslatedText().endDate,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Ending Date",
                                labelStyle: StyleText.formLabelStyle),
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
                                  if (selectedUser == "Manual") {
                                    actuatorID = "";
                                    teamId = "";
                                  } else if (selectedUser != "Manual") {
                                    actuatorController.text = "";
                                    teamId = selectedTeam.toString();
                                    actuatorID = selectedUser;
                                  }
                                  TaskApi()
                                      .editTask(
                                          widget.id,
                                          actuatorID,
                                          teamId,
                                          tittleController.text,
                                          descriptionController.text,
                                          actuatorController.text,
                                          startController.text,
                                          endingController.text)
                                      .then((value) {
                                    if (value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Data edited successfully",
                                            style: StyleText.boldBtnText,
                                          ),
                                          backgroundColor: ColorPalette.green,
                                        ),
                                      );
                                      GlobalItem.indexPage = 3;
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyHomePage()),
                                        (Route<dynamic> route) => false,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Failed editing data",
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
