import 'package:client/pages/home/home_page.dart';
import 'package:client/pages/user/create/create_user_page.dart';
import 'package:client/pages/user/update/update_user_controller.dart';
import 'package:client/pages/user/update/update_user_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'pages/home/home_page_controller.dart';
import 'pages/user/create/create_user_controller.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => HomeController(),
          dispose: (_, homeController) => homeController.dispose(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber[900]!),
          useMaterial3: true,
        ),
        initialRoute: "/",
        onGenerateRoute: (settings) {
          if (settings.name == UpdateUserPage.routeName) {
            final args = settings.arguments as UpdateUserArguments;

            return MaterialPageRoute(
              builder: (context) {
                return Provider(
                  create: (_) => UpdateUserController(args.user, Provider.of<HomeController>(context)),
                  dispose: (_, createUserController) => createUserController.dispose(),
                  child: UpdateUserPage(
                    user: args.user,
                  ),
                );
              },
            );
          }
          return null;
        },
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          CreateUserPage.routeName: (context) => Provider(
                create: (_) => CreateUserController(Provider.of<HomeController>(context)),
                dispose: (_, createUserController) => createUserController.dispose(),
                child: const CreateUserPage(),
              ),
        },
      ),
    );
  }
}
