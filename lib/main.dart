import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywork/main_page.dart';
import 'package:mywork/setting_bloc.dart';
import 'package:mywork/tomato_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tomato App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TomatoRecordBloc(),
          ),
          BlocProvider(
            create: (context) => ActiveTomatoBloc(),
          ),
          BlocProvider(
            create: (context) => SettingBloc(),
          )
        ],
        child: MainPage(),
      ),
    );
  }
}
