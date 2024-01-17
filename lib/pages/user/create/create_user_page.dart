import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'create_user_controller.dart';
import 'create_user_state.dart';

class CreateUserPage extends StatefulWidget {
  static const String routeName = '/create-user';

  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final emailFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final createUserController = Provider.of<CreateUserController>(context);

    createUserController.message$.distinct().listen((message) {
      if (message is CreateUserSuccessMessage) {
        const snackBar = SnackBar(
          content: Text("You created the user successfully"),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      if (message is CreateUserErrorMessage) {
        const snackBar = SnackBar(
          content: Text("Something went wrong creating the user. Try again"),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      if (message is CreateUserInvalidInformationMessage) {
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
    final createUserController = Provider.of<CreateUserController>(context);

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
                  'Create \na new user',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  'Complete the form below to create a new user',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(
              height: 40.0,
            ),
            StreamBuilder<String?>(
              stream: createUserController.nameError$,
              builder: (context, snapshot) {
                return TextField(
                  onChanged: createUserController.nameChanged,
                  autocorrect: true,
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsetsDirectional.only(end: 8.0),
                      child: Icon(Icons.person),
                    ),
                    labelText: 'Name',
                    errorText: snapshot.data,
                  ),
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 16.0),
                  focusNode: nameFocusNode,
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(emailFocusNode);
                  },
                  textInputAction: TextInputAction.next,
                );
              },
            ),
            StreamBuilder<String?>(
              stream: createUserController.emailError$,
              builder: (context, snapshot) {
                return TextField(
                  onChanged: createUserController.emailChanged,
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
                    FocusScope.of(context).requestFocus(phoneNumberFocusNode);
                  },
                  textInputAction: TextInputAction.next,
                );
              },
            ),
            StreamBuilder<String?>(
              stream: createUserController.phoneNumberError$,
              builder: (context, snapshot) {
                return TextField(
                  onChanged: createUserController.phoneNumberChanged,
                  autocorrect: true,
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsetsDirectional.only(end: 8.0),
                      child: Icon(Icons.phone),
                    ),
                    labelText: 'Phone Number',
                    errorText: snapshot.data,
                  ),
                  keyboardType: TextInputType.phone,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 16.0),
                  focusNode: phoneNumberFocusNode,
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
                createUserController.createUser();
              },
              child: StreamBuilder<bool>(
                  stream: createUserController.isFetching$,
                  builder: (context, snapshot) {
                    return snapshot.data == true
                        ? const RepaintBoundary(
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Create User');
                  }),
            )
          ],
        ),
      ),
    );
  }
}
