// ignore_for_file: file_names
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:visivista/api/base_url.dart';
import 'package:visivista/api/user_api.dart';
import 'package:visivista/main.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/user.dart';
import 'package:visivista/page/layout/app_bar.dart';
import 'package:visivista/page/layout/loading_page.dart';
import 'package:visivista/style/alerts.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  UserApi userApi = UserApi();
  User? user;
  late Future dataUser;
  bool isLoading = true;
  String foto = "";
  String baseUrl = GlobalApi.getBaseUrl();
  bool isPhotoPicked = false;
  bool closePressed = false;

  @override
  void initState() {
    dataUser = userApi.getDataUser().then((value) {
      setState(() {
        user = value;
        if (user?.profilePict != null) {
          foto = "${baseUrl}user/userPict/${user!.profilePict}";
          // foto = '${baseUrl}userPict/${user?.profilePict}';
        }
        namaController.text = user?.nama ?? "";
        emailController.text = user?.email ?? "";
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
              child: Center(
              child: Column(children: [
                const SizedBox(height: 20),
                SizedBox(
                  width: 350,
                  child: Form(
                      child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 170,
                          height: 170,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: Stack(
                            children: [
                              !isPhotoPicked
                                  ? ClipOval(
                                      child: user?.profilePict == null
                                          ? Image.asset(
                                              "assets/background/pp_default.png",
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              foto,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                              headers: {
                                                'Authorization':
                                                    'Bearer ${GlobalItem.userToken}',
                                              },
                                            ),
                                    )
                                  : ClipOval(
                                      child: foto != ""
                                          ? Image.file(
                                              File(foto),
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              "assets/background/pp_default.png",
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 37,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorPalette.blue,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: ColorPalette.white,
                                    onPressed: () async {
                                      final result = await FilePicker.platform
                                          .pickFiles(type: FileType.image);
                                      if (result == null) return;
                                      final file =
                                          File(result.files.single.path!);
                                      setState(() {
                                        foto = file.path;
                                        isPhotoPicked = true;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  width: 37,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorPalette.red,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.close_rounded),
                                    color: ColorPalette.white,
                                    onPressed: () {
                                      setState(() {
                                        closePressed = true;
                                        foto = "";
                                        isPhotoPicked = true;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Theme(
                          data: ThemeData(
                              inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: ColorPalette.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: ColorPalette.black,
                                width: 2,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: ColorPalette.black,
                                width: 2,
                              ),
                            ),
                          )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //name
                              const Text(
                                "Name",
                                style: StyleText.formTitle,
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                cursorColor: Colors.grey.withOpacity(1),
                                controller: namaController,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 20),

                              //email
                              const Text(
                                "Email",
                                style: StyleText.formTitle,
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                cursorColor: Colors.grey.withOpacity(1),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                                controller: emailController,
                              ),
                              const SizedBox(height: 20),
                            ],
                          )),
                    ],
                  )),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if (closePressed) {
                      userApi.deleteProfilePict(closePressed);
                    }
                    userApi
                        .edit(
                      idUser: user!.id,
                      photo: isPhotoPicked ? foto : null,
                      nama: namaController.text,
                      email: emailController.text,
                      closePressed: closePressed,
                    )
                        .then((value) {
                      if (value) {
                        AppAlert().showSuccessAlert(
                            context, TranslatedText().successEditProfile);
                        GlobalItem.indexPage = 4;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyHomePage()),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        AppAlert().showFailedAlert(
                            context, TranslatedText().failEditProfile);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Save",
                    style: StyleText.btnText,
                  ),
                ),
              ]),
            )),
    );
  }
}
