// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/components/crud.dart';
import 'package:notes_app/components/customtextform.dart';
import 'package:notes_app/components/valid.dart';
import 'package:notes_app/constant/linkapi.dart';
import 'package:notes_app/main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final Crud _crud= Crud();
  bool isLoading = false;
  login() async{
    if(formState.currentState!.validate()){
      isLoading = true;
      setState(() {});
      var response = await _crud.postRequest(linkLogin, {
        "email" : email.text,
        "password" : password.text,
      });
      isLoading = false;
      setState(() {});
      if(response['status'] == "success"){
        sharedPref.setString("id", response['data']['id'].toString());
        sharedPref.setString("username", response['data']['username']);
        sharedPref.setString("email", response['data']['email']);
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      }else{
        AwesomeDialog(
          context: context,
          title: "تنبيه",
          body: const Text("البريد الإلكتروني او كلمة المرور خطأ او الحساب غير موجود \n"),
        ).show();

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(40),
        child: isLoading == true ?
        const Center(child: CircularProgressIndicator())
            : ListView(
          children: [
            Form(
              key: formState,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    SvgPicture.asset("assets/icons/notes.svg", width: 200, height: 400,),
                    const SizedBox(height: 20,),
                    CustomTextForm(
                      validator: (value){
                        return validInput(value!, 5, 40);
                      },
                      myController: email,
                      hint: "Email",
                    ),
                    const SizedBox(height: 20,),
                    CustomTextForm(
                      validator: (value){
                        return validInput(value!, 3, 10);
                      },
                      myController: password,
                      hint: "Password",
                    ),
                    const SizedBox(height: 20,),

                    MaterialButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                      onPressed: () async{
                        await login();
                      },
                      child: const Text("Login"),
                    ),
                    Container(height: 10,),
                    InkWell(
                        onTap: (){
                          Navigator.of(context).pushNamed("signup");
                          },
                        child: const Text("Sign Up")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
