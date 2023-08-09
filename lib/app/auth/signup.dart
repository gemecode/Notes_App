// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/components/crud.dart';
import 'package:notes_app/components/customtextform.dart';
import 'package:notes_app/components/valid.dart';
import 'package:notes_app/constant/linkapi.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final Crud _crud = Crud();
  bool isLoading = false;

  signUp() async{
    if(formState.currentState!.validate()){
      isLoading = true;
      setState(() {});
      var response = await
      _crud.postRequest(linkSignUp, {
        "username" : username.text,
        "email" : email.text,
        "password" : password.text,
      });
      isLoading = false;
      setState(() {});
      if(response['status'] == "success"){
        Navigator.of(context).pushNamedAndRemoveUntil("success", (route) => false);
      }else{
        print("signup fail");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true ? const Center(child: CircularProgressIndicator())
          : Container(
        padding: const EdgeInsets.all(40),
        child: ListView(
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
                        return validInput(value!, 3, 20);
                      },
                      myController: username,
                      hint: "Username",
                    ),
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
                      onPressed: () async {
                        await signUp();
                      },
                      child: const Text("Sign up"),
                    ),
                    Container(height: 10,),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushNamed("login");
                      },
                        child: const Text("Login")),
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
