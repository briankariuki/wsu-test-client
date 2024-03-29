import 'package:client/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'update_user_controller.dart';
import 'update_user_state.dart';

class UpdateUserArguments {
  final User user;

  UpdateUserArguments(this.user);
}

class UpdateUserPage extends StatefulWidget {
  static const String routeName = '/update-user';

  final User user;

  const UpdateUserPage({super.key, required this.user});

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  final emailFocusNode = FocusNode();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();

  final emailTextController = TextEditingController();
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    emailTextController.text = widget.user.email!;
    firstNameTextController.text = widget.user.firstName!;
    lastNameTextController.text = widget.user.lastName!;
  }

  @override
  void dispose() {
    firstNameFocusNode.dispose();
    emailFocusNode.dispose();
    lastNameFocusNode.dispose();

    lastNameTextController.dispose();
    emailTextController.dispose();
    firstNameTextController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final updateUserController = Provider.of<UpdateUserController>(context);

    updateUserController.message$.distinct().listen((message) {
      if (message is UpdateUserSuccessMessage) {
        const snackBar = SnackBar(
          content: Text("You updated the user successfully"),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      if (message is UpdateUserErrorMessage) {
        const snackBar = SnackBar(
          content: Text("Something went wrong updating the user. Try again"),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      if (message is UpdateUserInvalidInformationMessage) {
        const snackBar = SnackBar(
          content: Text("Invalid user information. Try again"),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final updateUserController = Provider.of<UpdateUserController>(context);

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Update \na new user',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  'Complete the form below to Update a new user',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(
              height: 40.0,
            ),
            StreamBuilder<String?>(
              stream: updateUserController.firstNameError$,
              builder: (context, snapshot) {
                return TextField(
                  controller: firstNameTextController,
                  onChanged: updateUserController.firstNameChanged,
                  autocorrect: true,
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsetsDirectional.only(end: 8.0),
                      child: Icon(Icons.person),
                    ),
                    labelText: 'First Name',
                    errorText: snapshot.data,
                  ),
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 16.0),
                  focusNode: firstNameFocusNode,
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(lastNameFocusNode);
                  },
                  textInputAction: TextInputAction.next,
                );
              },
            ),
            StreamBuilder<String?>(
              stream: updateUserController.lastNameError$,
              builder: (context, snapshot) {
                return TextField(
                  controller: lastNameTextController,
                  onChanged: updateUserController.lastNameChanged,
                  autocorrect: true,
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsetsDirectional.only(end: 8.0),
                      child: Icon(Icons.person),
                    ),
                    labelText: 'Last Name',
                    errorText: snapshot.data,
                  ),
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 16.0),
                  focusNode: lastNameFocusNode,
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(emailFocusNode);
                  },
                  textInputAction: TextInputAction.next,
                );
              },
            ),
            StreamBuilder<String?>(
              stream: updateUserController.emailError$,
              builder: (context, snapshot) {
                return TextField(
                  controller: emailTextController,
                  onChanged: updateUserController.emailChanged,
                  autocorrect: true,
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsetsDirectional.only(end: 8.0),
                      child: Icon(Icons.email),
                    ),
                    labelText: 'Email',
                    errorText: snapshot.data,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 16.0),
                  focusNode: emailFocusNode,
                  onSubmitted: (_) {
                    FocusScope.of(context).unfocus();
                  },
                  textInputAction: TextInputAction.next,
                );
              },
            ),
            const SizedBox(
              height: 24.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  200.0,
                  48.0,
                ),
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                updateUserController.updateUser();
              },
              child: StreamBuilder<bool>(
                  stream: updateUserController.isFetching$,
                  builder: (context, snapshot) {
                    return snapshot.data == true
                        ? const RepaintBoundary(
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Update User');
                  }),
            )
          ],
        ),
      ),
    );
  }
}
