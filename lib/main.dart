// ignore_for_file: prefer_const_constructors

import 'package:better_bus/controller/appController.dart';
import 'package:better_bus/dao/busStopProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_it/get_it.dart';
import 'bottomBar.dart';
import 'constKey/appMenuKey.dart';
import 'dao/routeStopProvider.dart';
import 'router.dart';

GetIt getIt = GetIt.instance;
void main() {
  getIt.registerSingleton(AppController());
  getIt.registerSingleton(BusStopProvider());
  getIt.registerSingleton(RouteStopProvider());
  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Better Bus',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AppController appController;

  @override
  void initState() {
    super.initState();
    appController = getIt<AppController>();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 1));
      appController
          .init()
          .then((value) => setState(() {}))
          .onError((error, stackTrace) {
        appController.isError = true;
        appController.isLoading = false;
        appController.errorMessage = error.toString();
        setState(() {});
      });
    });
  }

  _changePage(String pageKey) {
    appController.currentPage = pageKey;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (appController.isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (appController.isError == true) {
      return Center(
        child: AlertDialog(
          title: const Text('Error'),
          content: Text(appController.errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Phoenix.rebirth(context),
              child: const Text('Restart'),
            ),
            if (appController.errorMessage == "Fail to get Bus data")
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  appController.isError = false;
                  setState(() {});
                },
                child: const Text('Contine with local data'),
              ),
          ],
        ),
      );
    }
    return Scaffold(
        bottomNavigationBar: NavBar(
          isElevated: true,
          isVisible: true,
          appController: appController,
          changePage: _changePage,
        ),
        body: SafeArea(
          child: PageRouter(
            appController: appController,
          ),
        ));
  }
}
