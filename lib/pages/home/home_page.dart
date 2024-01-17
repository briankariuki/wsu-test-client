import 'package:client/model/healthcheck.dart';
import 'package:client/model/user.dart';
import 'package:client/pages/home/home_page_controller.dart';
import 'package:client/pages/user/update/update_user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page_state.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> users = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final homeController = Provider.of<HomeController>(context);

    homeController.message$.listen((message) {
      if (message is HomeSuccessMessage && message.message != "") {
        final snackBar = SnackBar(
          content: Text(message.message),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      if (message is HomeErrorMessage) {
        final snackBar = SnackBar(
          content: Text(message.message),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      if (message is HomeInvalidInformationMessage) {
        const snackBar = SnackBar(
          content: Text("Invalid user information. Try again"),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
    });

    homeController.users$.listen((List<User> data) {
      setState(() {
        users.addAll(data);
      });
    });

    homeController.deletedUser$.listen((User data) {
      setState(() {
        users = users.where((user) => user.id != data.id).toList();
      });
    });

    homeController.updatedUser$.listen((User data) {
      setState(() {
        users = users.where((user) => user.id != data.id).toList();
      });

      int index = users.indexWhere((user) => user.id == data.id);

      if (index == -1) {
        setState(() {
          users.add(data);
        });
      } else {
        setState(() {
          users[index] = data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome \nto your users hub',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  'You can add new users to your list, update existing users or check if the system is working',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(
              height: 36.0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: SizedBox.square(
                      dimension: 24.0,
                      child: Icon(
                        Icons.network_cell,
                        size: 32.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 32.0,
                  ),
                  Expanded(
                    child: StreamBuilder<Healthcheck>(
                        stream: homeController.healthcheck$,
                        builder: (context, snapshot1) {
                          return StreamBuilder<bool>(
                              stream: homeController.isCheckingApi$,
                              builder: (context, snapshot2) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Healthcheck: ${snapshot1.hasData == true ? "API is active" : snapshot2.data == true ? "Checking" : "API is inactive"}',
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(
                                      height: 2.0,
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Last updated at: ${snapshot1.hasData == true ? snapshot1.data!.date : snapshot2.data == true ? "" : "unknown"}',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  color: Colors.black54,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(24.0, 40.0),
                                        backgroundColor: Colors.amber[800],
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () => homeController.checkApiStatus(),
                                      child: Text(snapshot2.data == true ? 'Checking...' : 'Check'),
                                    ),
                                  ],
                                );
                              });
                        }),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            const Divider(
              color: Colors.black12,
              thickness: 0.8,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My users',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      'Your registered users',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black54),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(24.0, 40.0),
                  ),
                  onPressed: () => Navigator.of(context).pushNamed("/create-user"),
                  child: const Text('New User'),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            users.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      return UserTile(
                        user: users[index],
                        onDelete: (user) => homeController.deleteUser(user),
                      );
                    },
                  )
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: Text('No users found')),
                  ),
            StreamBuilder<bool>(
              stream: homeController.isFetchingUsers$,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return const UserTileLoading();
                        },
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final User user;
  final Function(User) onDelete;
  const UserTile({super.key, required this.user, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      isThreeLine: true,
      leading: CircleAvatar(
        radius: 24.0,
        child: Text(user.avatar),
      ),
      title: Text("${user.firstName!} ${user.lastName!}"),
      subtitle: Text(
        user.email!,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black54),
      ),
      trailing: IconButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (_) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Text(
                  'User Actions',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const Divider(
                color: Colors.black12,
                thickness: 0.8,
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(
                    context,
                    UpdateUserPage.routeName,
                    arguments: UpdateUserArguments(user),
                  );
                },
                title: const Text('Update User'),
                subtitle: Text(
                  'Change the user entry details',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black54),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  onDelete(user);
                },
                title: const Text('Delete User'),
                subtitle: Text(
                  'Remove the user from the list',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black54),
                ),
              ),
              const SizedBox(
                height: 48.0,
              )
            ],
          ),
        ),
        icon: const Icon(
          Icons.more_vert,
        ),
      ),
    );
  }
}

class UserTileLoading extends StatelessWidget {
  const UserTileLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      leading: const CircleAvatar(
        radius: 24.0,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnconstrainedBox(
            child: Container(
              height: 6.0,
              width: 200.0,
              decoration: BoxDecoration(
                color: Colors.amber[900]?.withOpacity(0.16),
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          UnconstrainedBox(
            child: Container(
              height: 5.0,
              width: 120.0,
              decoration: BoxDecoration(
                color: Colors.amber[900]?.withOpacity(0.16),
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
