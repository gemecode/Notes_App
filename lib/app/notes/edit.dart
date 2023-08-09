// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/components/crud.dart';
import 'package:notes_app/components/customtextform.dart';
import 'package:notes_app/components/valid.dart';
import 'package:notes_app/constant/linkapi.dart';
import 'package:notes_app/main.dart';



class EditNotes extends StatefulWidget {
  final notes;
  const EditNotes({Key? key, this.notes}) : super(key: key);

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> with Crud{

  File? myFile;

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  bool isLoading = false;

  editNotes() async{
    if (formState.currentState!.validate()){
      isLoading = true;
      setState(() {});
      var response ;
      if (myFile == null){
        response = await postRequest(linkEditNotes, {
          "title" : title.text,
          "content" : content.text,
          "id" : widget.notes['notes_id'].toString(),
          "imagename" : widget.notes['notes_image'].toString(),
        },);
      }else{
        response = await postRequestWithFile(linkEditNotes, {
          "title" : title.text,
          "content" : content.text,
          "imagename" : widget.notes['notes_image'].toString(),
          "id" : widget.notes['notes_id'].toString(),
        },
            myFile!
        );
      }
      isLoading = false;
      setState(() {});
      if (response['status'] == "success"){
        Navigator.of(context).pushReplacementNamed("home");
      }else{

      }
    }
  }

  @override
  void initState() {
    title.text = widget.notes['notes_title'];
    content.text = widget.notes['notes_content'];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Notes"),
      ),
      body: isLoading == true ? const Center(child: CircularProgressIndicator(),) : Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formState,
          child: ListView(
            children: [

              CustomTextForm(
                hint: 'title',
                myController: title,
                validator: (val){
                  return validInput(val!, 1, 40);
                },
              ),

              CustomTextForm(
                hint: 'content',
                myController: content,
                validator: (val){
                  return validInput(val!, 10, 255);
                },
              ),

              const SizedBox(height: 20,),

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
              MaterialButton(
                onPressed: () async{
                  await editNotes();
                },
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text("Save"),
              )

            ],
          ),
        ),
      ),
    );
  }
}
