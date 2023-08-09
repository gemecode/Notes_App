import 'package:flutter/material.dart';

class Success extends StatefulWidget {
  const Success({Key? key}) : super(key: key);

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "تم انشاء الحساب بنجاح الان يمكنك تسجيل الدخول",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 20,),
          MaterialButton(
            textColor: Colors.white,
            color: Colors.blue,
            onPressed: (){
              Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false,);
          },
            child: const Text("تسجيل الدخول"),
          ),
              
        ],
      ),
    );
  }
}
