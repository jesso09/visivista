import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visivista/api/content_api.dart';
import 'package:visivista/api/idea_api.dart';
import 'package:visivista/api/teams_api.dart';
import 'package:visivista/main.dart';
import 'package:visivista/model/content.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/idea.dart';
import 'package:visivista/model/team_member.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/page/layout/content_view.dart';
import 'package:visivista/page/layout/new_content.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';
import 'dart:io';

class EditContent extends StatefulWidget {
  const EditContent({super.key, required this.id});

  final int id;

  @override
  State<EditContent> createState() => _EditContentState();
}

class _EditContentState extends State<EditContent> {
  final TextEditingController tittleController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  final TextEditingController hashtagController = TextEditingController();
  final TextEditingController votController = TextEditingController();
  final TextEditingController postScheduledController = TextEditingController();
  String? foto;
  String? video;
  ContentApi contentApi = ContentApi();
  late Future<Content> dataContent;
  bool isLoading = true;
  bool isContentPicked = false;
  bool isRequestFinished = true;
  String? selectedTeamName;
  String? contentTeam;
  TeamsApi teamsApi = TeamsApi();
  IdeaApi ideaApi = IdeaApi();
  late Future dataTeams;
  List<TeamMember> teamList = [];
  int selectedIdeaId = 0;
  List<Idea> itemList = [];
  String selectedOption = 'Enter Plan';
  late Future dataIde;

  @override
  void initState() {
    super.initState();
    dataContent = contentApi.getContent(widget.id);
    dataContent.then((value) {
      setState(() {
        tittleController.text = value.title ?? "";
        captionController.text = value.caption ?? "";
        hashtagController.text = value.hashtag ?? "";
        votController.text = value.voiceOverTeks ?? "";
        contentTeam = value.team;
        if (value.postScheduled != null) {
          postScheduledController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(value.postScheduled!);
        } else {
          postScheduledController.text = "";
        }
        isLoading = false;
      });
    });
    dataIde = ideaApi.getDataIdea();
    dataIde.then((value) {
      setState(() {
        itemList = value;
      });
    });
    dataTeams = teamsApi.indexTeamByMember();
    dataTeams.then((value) {
      setState(() {
        teamList = value;
      });
    });
  }

  List<DropdownMenuItem<String>> get dropDownMetode {
    List<DropdownMenuItem<String>> menuItems = [];

    for (int index = 0; index < teamList.length; index++) {
      menuItems.add(
        DropdownMenuItem(
          value: teamList[index].team!.teamName,
          child: Text(
              "${teamList[index].team!.teamName} - Owner : ${teamList[index].team!.user!.nama}"),
        ),
      );
    }

    if (teamList.isEmpty) {
      menuItems.add(
        const DropdownMenuItem(
          value: null,
          child: Text("You have no team"),
        ),
      );
    }

    return menuItems;
  }

  void changePicked() {
    setState(() {
      isContentPicked = true;
    });
  }

  Future<void> showDropdown(BuildContext context) async {
    final result = await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(10, 100, 0, 0),
      items: itemList.map((Idea idea) {
        return PopupMenuItem<Idea>(
          value: idea,
          child: Text(idea.title),
        );
      }).toList(),
    );

    if (result != null) {
      setState(() {
        // Handle the selected Idea
        selectedOption = result.title;
        captionController.text = result.description ?? "";
        tittleController.text = result.title;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const AppBarWithBack(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isContentPicked
                    // ignore: prefer_const_constructors
                    ? NewContent()
                    : ContentView(
                        id: widget.id,
                      ),
                Text(
                  "Edit Your Content",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles();
                    if (result == null) return;
                    if (GlobalItem.imagePick.isNotEmpty &&
                        File(GlobalItem.imagePick).existsSync()) {
                      File(GlobalItem.imagePick).deleteSync();
                    }

                    if (GlobalItem.videoPick.isNotEmpty &&
                        File(GlobalItem.videoPick).existsSync()) {
                      File(GlobalItem.videoPick).deleteSync();
                    }
                    final file = result.files.first;
                    if (file.extension == "jpg" ||
                        file.extension == "jpeg" ||
                        file.extension == "png") {
                      GlobalItem.imagePick = '';
                      GlobalItem.imagePick = file.path!;
                      GlobalItem.videoPick = '';
                      foto = file.path;
                      changePicked();
                    } else if (file.extension == "mp4") {
                      GlobalItem.videoPick = '';
                      GlobalItem.videoPick = file.path!;
                      GlobalItem.imagePick = '';
                      video = file.path!;
                      changePicked();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ColorPalette.black,
                    backgroundColor: ColorPalette.sandyBrown,
                    fixedSize: const Size(200, 50),
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_photo_alternate_rounded,
                        color: ColorPalette.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        TranslatedText().editFile,
                        style: StyleText.btnText,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      TranslatedText().selectIdea,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(width: 10),
                    PopupMenuButton<Idea>(
                      // initialValue:
                      //     itemList.isNotEmpty ? itemList.first : null,
                      itemBuilder: (BuildContext context) {
                        return itemList.map((Idea idea) {
                          return PopupMenuItem<Idea>(
                            value: idea,
                            child: Text(idea.title),
                          );
                        }).toList();
                      },
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: ColorPalette.secondary,
                          ),
                          child: const Icon(
                            Icons.arrow_drop_down,
                            color: ColorPalette.white,
                            size: 34,
                          )),
                      onSelected: (Idea selectedIdea) {
                        setState(() {
                          // Handle the selected Idea
                          selectedOption = selectedIdea.title;
                          selectedIdeaId = selectedIdea.id;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Form(
                  child: Theme(
                    data: ThemeData(
                      inputDecorationTheme:
                          Theme.of(context).inputDecorationTheme,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //title
                        Text(
                          TranslatedText().title,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        TextFormField(
                          maxLines: 5,
                          minLines: 1,
                          textInputAction: TextInputAction.next,
                          controller: tittleController,
                          cursorColor: Theme.of(context).colorScheme.onPrimary,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 20),

                        //caption
                        Text(
                          TranslatedText().caption,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        TextFormField(
                          maxLines: 5,
                          minLines: 1,
                          textInputAction: TextInputAction.next,
                          controller: captionController,
                          cursorColor: Theme.of(context).colorScheme.onPrimary,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 20),

                        //hashtags
                        Text(
                          TranslatedText().hashtag,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        TextFormField(
                          maxLines: 5,
                          minLines: 1,
                          textInputAction: TextInputAction.next,
                          controller: hashtagController,
                          cursorColor: Theme.of(context).colorScheme.onPrimary,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 20),

                        //Voice Over Teks
                        Text(
                          TranslatedText().voiceOT,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        TextFormField(
                          maxLines: 5,
                          minLines: 1,
                          textInputAction: TextInputAction.next,
                          controller: votController,
                          cursorColor: Theme.of(context).colorScheme.onPrimary,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 20),

                        //Teams
                        Text(
                          TranslatedText().team,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: contentTeam,
                            labelStyle:
                                Theme.of(context).textTheme.displaySmall,
                          ),
                          items: dropDownMetode,
                          value: selectedTeamName,
                          dropdownColor:
                              Theme.of(context).inputDecorationTheme.fillColor,
                          style: Theme.of(context).textTheme.displaySmall,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedTeamName = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        //Post Schedule
                        Text(
                          TranslatedText().datePost,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: postScheduledController,
                          readOnly: true,
                          style: Theme.of(context).textTheme.displaySmall,
                          onTap: () {
                            DateTimePicker.selectDateTime(
                                context, postScheduledController);
                          },
                        ),
                        const SizedBox(height: 14),
                        !isRequestFinished
                            ? FutureBuilder(
                                future:
                                    Future.delayed(const Duration(seconds: 5)),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Text(
                                      "Please wait we're still working on it",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              )
                            : const SizedBox(),

                        const SizedBox(height: 8),
                        if (!isRequestFinished)
                          const LinearProgressIndicator(
                            color: ColorPalette.secondary,
                            backgroundColor: ColorPalette.burntSienna,
                          ),
                        const SizedBox(height: 14),

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
                                setState(() {
                                  isRequestFinished = false;
                                });
                                contentApi
                                    .editContent(
                                  id: widget.id,
                                  idUser: GlobalItem.userID,
                                  idIdea: selectedIdeaId,
                                  photo: foto,
                                  video: video,
                                  title: tittleController.text,
                                  caption: captionController.text,
                                  hashtag: hashtagController.text,
                                  voiceOverTeks: votController.text,
                                  team: selectedTeamName ?? contentTeam,
                                  postScheduled: postScheduledController.text,
                                )
                                    .then((value) {
                                  if (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Content Edited Successfully",
                                          style: StyleText.boldBtnText,
                                        ),
                                        backgroundColor: ColorPalette.green,
                                      ),
                                    );
                                    setState(() {
                                      isRequestFinished = true;
                                    });
                                    GlobalItem.indexPage = 1;
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyHomePage()),
                                      (Route<dynamic> route) => false,
                                    );
                                  } else {
                                    setState(() {
                                      isRequestFinished = true;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Failed Edit Content",
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
                                backgroundColor: ColorPalette.secondary,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
