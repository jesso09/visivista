import 'package:flutter/material.dart';
import 'package:visivista/api/idea_api.dart';
import 'package:visivista/main.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class AddIde extends StatefulWidget {
  const AddIde({super.key});

  @override
  State<AddIde> createState() => _AddIdeState();
}

class _AddIdeState extends State<AddIde> {
  final TextEditingController tittleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController datePlanController = TextEditingController();

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
                    //Title
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

                    //Description
                    Text(
                      TranslatedText().description + TranslatedText().optional,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextFormField(
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                        labelText: TranslatedText().description + TranslatedText().optional,
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
                      decoration: InputDecoration(
                        labelText: TranslatedText().startDate,
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
                                .addIdea(
                              tittleController.text,
                              descriptionController.text,
                              datePlanController.text,
                            )
                                .then((value) {
                              if (value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Added",
                                      style: StyleText.boldBtnText,
                                    ),
                                    backgroundColor: ColorPalette.green,
                                  ),
                                );
                                GlobalItem.indexPage = 2;
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
