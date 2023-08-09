// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/components/crud.dart';
import 'package:notes_app/components/customtextform.dart';
import 'package:notes_app/components/valid.dart';
import 'package:notes_app/constant/linkapi.dart';
import 'package:notes_app/main.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> with Crud {
  File? myFile;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  bool isLoading = false;

  addNotes() async {
    if(myFile == null) return AwesomeDialog(context: context, title: "هام", body: Text("الرجاء اضافة الصوره الخاصه بالملاحظه"))..show();
    if (formState.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await postRequestWithFile(linkAddNotes, {
        "title": title.text,
        "content": content.text,
        "id": sharedPref.getString("id"),
      },
        myFile!
      );
      isLoading = false;
      setState(() {});
      if (response['status'] == "success") {
        Navigator.of(context).pushReplacementNamed("home");
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Notes"),
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formState,
                child: ListView(
                  children: [
                    CustomTextForm(
                      hint: 'title',
                      myController: title,
                      validator: (val) {
                        return validInput(val!, 1, 40);
                      },
                    ),
                    CustomTextForm(
                      hint: 'content',
                      myController: content,
                      validator: (val) {
                        return validInput(val!, 10, 255);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                                  height: 120,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Please choose Image", style: TextStyle(fontSize: 22),),
                                      ),
                                      InkWell(
                                        onTap: () async{
                                          XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                          Navigator.of(context).pop();
                                          myFile = File(xFile!.path);
                                          setState(() {});
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          child: const Text(
                                            "From Gallery",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),

                                      InkWell(
                                        onTap: () async{
                                          XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
                                          Navigator.of(context).pop();
                                          myFile = File(xFile!.path);
                                          setState(() {});
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          child: const Text(
                                            "From Camera",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ));
                      },
                      color: myFile == null ? Colors.blue : Colors.green,
                      textColor: Colors.white,
                      child: const Text("Choose Image"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        await addNotes();
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: const Text("Add"),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
