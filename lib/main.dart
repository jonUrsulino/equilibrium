import 'package:equilibrium/data/data_source/model/player_store.dart';
import 'package:equilibrium/domain/di/di.dart';
import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/home/business_logic/home_bloc.dart';
import 'package:equilibrium/navigator/di/di_nav.dart';
import 'package:equilibrium/presentation/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_persistence/simple_persistence.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DI.initializeNavigatorDependencies();
  DiDomain.initializeDomainDependencies();
  PersistenceManager.I.register(Player.fromMap);
  PersistenceManager.I.register(PresencePlayer.fromMap);

  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc(
          controllerManager: GetIt.I.get(),
          repository: GetIt.I.get(),
          coach: GetIt.I.get(),
          settings: GetIt.I.get(),
        ),)
      ],
      child: const MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: Pages.routes,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        secondaryHeaderColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
    );
  }
}
