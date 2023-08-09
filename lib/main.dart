import 'package:flutter/material.dart';
import 'package:notes_app/app/auth/login.dart';
import 'package:notes_app/app/auth/signup.dart';
import 'package:notes_app/app/auth/success.dart';
import 'package:notes_app/app/home.dart';
import 'package:notes_app/app/notes/add.dart';
import 'package:notes_app/app/notes/edit.dart';
import 'package:shared_preferences/shared_preferences.dart';


late SharedPreferences sharedPref;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course PHP Rest API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: sharedPref.getString("id") == null ? "login" : "home",
      routes: {
        "login" : (context)=> const Login(),
        "signup" : (context)=> const SignUp(),
        "home" : (context)=> const Home(),
        "success" : (context)=> const Success(),
        "addnotes" : (context)=> const AddNotes(),
        "editnotes" : (context)=> const EditNotes(),
      },
    );
  }
}

