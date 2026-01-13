import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';
import 'package:tasky/screens/user_details_screen.dart';
import 'package:tasky/screens/welcome_screen.dart';
import 'package:tasky/widgets/custom_list_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String username;
  String? userImage;
  bool isLoading = true;
  String? motivationQuote;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    setState(() {
      username = PreferencesManager().getString('username') ?? '';
      motivationQuote = PreferencesManager().getString('motivation_quote');
      userImage = PreferencesManager().getString('user_image');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Center(
                  child: Text(
                    "My Profile",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              userImage == null
                                  ? AssetImage("assets/images/person.png")
                                  : FileImage(File(userImage!)),
                          radius: 60,
                          backgroundColor: Colors.transparent,
                        ),
                        GestureDetector(
                          onTap: () async {
                            showImageSourceDialog(context, (XFile file) {
                              _saveImage(file);
                              setState(() {
                                userImage = file.path;
                              });
                            });
                          },
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color:
                                    ThemeController.isDark()
                                        ? Colors.transparent
                                        : Color(0xFFD1DAD6),
                              ),
                            ),
                            child: Icon(Icons.camera_alt_outlined, size: 26),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      username,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      motivationQuote ?? 'One task at a time. One step closer.',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Profile Info",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 16),
              CustomListTile(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => UserDetailsScreen(
                            username: username,
                            motivationQuote: motivationQuote,
                          ),
                    ),
                  );
                  if (result != null && result) {
                    _loadUsername();
                  }
                },
                title: 'User Details',
                leadingImage: 'assets/images/profile.svg',
                trailing: CustomSvgPicture(
                  path: 'assets/images/arrow_right.svg',
                ),
              ),
              Divider(thickness: 1, color: Color(0xFF6E6E6E)),
              CustomListTile(
                onTap: () => null,
                title: 'Dark Mode',
                leadingImage: 'assets/images/dark.svg',
                trailing: ValueListenableBuilder(
                  valueListenable: ThemeController.notifier,
                  builder: (context, value, child) {
                    return Switch(
                      activeTrackColor: Color(0xFF15B86C),
                      value: value == ThemeMode.dark,
                      onChanged: (bool value) async {
                        ThemeController.toggle();
                      },
                    );
                  },
                ),
              ),
              Divider(thickness: 1, color: Color(0xFF6E6E6E)),
              CustomListTile(
                onTap: () async {
                  PreferencesManager().remove('tasks');
                  PreferencesManager().remove('username');
                  PreferencesManager().remove('motivation_quote');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                title: 'Log Out',
                leadingImage: 'assets/images/log_out.svg',
                trailing: CustomSvgPicture(
                  path: 'assets/images/arrow_right.svg',
                ),
              ),
            ],
          ),
        );
  }

  void _saveImage(XFile file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newFile = await File(file.path).copy("${appDir.path}/${file.name}");
    PreferencesManager().setString('user_image', newFile.path);
  }

  // void _showDateTime(BuildContext context) async{
  //  final selectedDate =await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1995),
  //     lastDate: DateTime.now().add(Duration(days: 356)),
  //   );
  //  showTimePicker(context: context, initialTime: TimeOfDay(hour: 12, minute: 0));
  // }

  // void _showButtonSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return ConstrainedBox(
  //         constraints: BoxConstraints(
  //           maxHeight: MediaQuery.of(context).size.height*0.9
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: ListView.builder(
  //             itemCount: 10,
  //             shrinkWrap: true,
  //             itemBuilder: (BuildContext context, int index) {
  //               return Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   height: 50,
  //                   color: Colors.red,
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

void showImageSourceDialog(
  BuildContext context,
  Function(XFile) selectedImage,
) {
  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text(
          "Choose Image Source",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        children: [
          SimpleDialogOption(
            onPressed: () async {
              Navigator.pop(context);
              XFile? image = await ImagePicker().pickImage(
                source: ImageSource.camera,
              );
              if (image != null) {
                selectedImage(image);
              }
            },
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.camera_alt_outlined),
                SizedBox(width: 8),
                Text("Camera"),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () async {
              Navigator.pop(context);
              XFile? image = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if (image != null) {
                selectedImage(image);
              }
            },
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.photo_library_outlined),
                SizedBox(width: 8),
                Text("Gallery"),
              ],
            ),
          ),
        ],
      );
    },
  );
}
