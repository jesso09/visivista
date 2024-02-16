import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visivista/api/idea_api.dart';
import 'package:visivista/main.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/idea.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class EditIde extends StatefulWidget {
  const EditIde({super.key, required this.id});

  final int id;

  @override
  State<EditIde> createState() => _EditIdeState();
}

class _EditIdeState extends State<EditIde> {
  final TextEditingController tittleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController datePlanController = TextEditingController();
  IdeaApi ideaApi = IdeaApi();
  Idea? idea;
  late Future dataIdea;
  bool isLoading = true;

  @override
  void initState() {
    dataIdea = ideaApi.getIdea(widget.id);
    dataIdea.then((value) {
      setState(() {
        idea = value;
        tittleController.text = idea!.title;
        descriptionController.text = idea?.description ?? "";
        datePlanController.text =
            DateFormat('yyyy-MM-dd HH:mm').format(idea!.tglPelaksanaan);
        isLoading = false;
      });
    });
    super.initState();
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
                          //Title
                          Text(
                            TranslatedText().title,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          TextFormField(
                            maxLines: 5,
                            minLines: 1,
                            decoration: const InputDecoration(
                              labelText: "Title",
                            ),
                            textInputAction: TextInputAction.next,
                            controller: tittleController,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(height: 20),

                          //Description
                          Text(
                            TranslatedText().description +
                                TranslatedText().optional,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          TextFormField(
                            maxLines: 5,
                            minLines: 1,
                            decoration: const InputDecoration(
                              labelText: "Description",
                            ),
                            textInputAction: TextInputAction.next,
                            controller: descriptionController,
                            cursorColor: Theme.of(context).colorScheme.onPrimary,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(height: 20),

                          //Starting Date
                          Text(
                            TranslatedText().startDate,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Starting Date",
                            ),
                            textInputAction: TextInputAction.next,
                            controller: datePlanController,
                            readOnly: true,
                            style: Theme.of(context).textTheme.displaySmall,
                            onTap: () {
                              DateTimePicker.selectDateTime(
                                  context, datePlanController);
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
                                  IdeaApi()
                                      .editIdea(
                                    widget.id,
                                    tittleController.text,
                                    descriptionController.text,
                                    datePlanController.text,
                                  )
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
                                      GlobalItem.indexPage = 2;
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
