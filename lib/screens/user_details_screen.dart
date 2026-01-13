import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/widgets/custom_text_form_filed.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({
    super.key,
    required this.username,
    required this.motivationQuote,
  });

  final String? username;

  final String? motivationQuote;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController(text: widget.username);
    motivationQuoteController = TextEditingController(
      text: widget.motivationQuote,
    );
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  late final TextEditingController userNameController;

  late final TextEditingController motivationQuoteController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextFormFiled(
                        controller: userNameController,
                        hintText: widget.username ?? '',
                        title: 'User Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Your Name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      CustomTextFormFiled(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Your Motivation Quote';
                          }
                          return null;
                        },
                        controller: motivationQuoteController,
                        hintText: 'One task at a time. One step closer.',
                        title: 'Motivation Quote',
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 40),
                ),
                child: Text("Save Changes"),
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    await PreferencesManager().setString(
                      "motivation_quote",
                      motivationQuoteController.value.text,
                    );
                    await PreferencesManager().setString(
                      "username",
                      userNameController.value.text,
                    );
                    Navigator.of(context).pop(true);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

