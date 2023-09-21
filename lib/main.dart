import 'package:flutter/material.dart';
import 'package:todo_app/pages/notes_home.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData()
              .copyWith(backgroundColor: Colors.grey)),
      home: const NotesHome(),
    ),
  );
}
