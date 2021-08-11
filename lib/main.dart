import 'package:bloc/bloc.dart';
import 'package:bmi_calculator/layout/home_layout.dart';
import 'package:bmi_calculator/shared/bloc_observer.dart';
import 'package:bmi_calculator/z_screens/bmi/homeScreen.dart';
import 'package:flutter/material.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
