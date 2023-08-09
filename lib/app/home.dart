// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:notes_app/app/notes/edit.dart';
import 'package:notes_app/components/cardnote.dart';
import 'package:notes_app/components/crud.dart';
import 'package:notes_app/constant/linkapi.dart';
import 'package:notes_app/main.dart';
import 'package:notes_app/model/notemodel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with Crud {
  getNotes()async{
    var response = await postRequest(linkViewNotes, {
      "id" : sharedPref.getString("id"),
    });
    return response;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(onPressed: (){
            sharedPref.clear();
            Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
          }, icon: const Icon(Icons.exit_to_app))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushNamed("addnotes");
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding:  const EdgeInsets.all(10),
        child: ListView(
          children: [
            FutureBuilder(
                future: getNotes(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
              if (snapshot.hasData){
                if(snapshot.data['status'] == 'fail'){
                  return const Center(child: Text("لا يوجد ملاحظات", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),));
                }
                return ListView.builder(
                    itemCount: snapshot.data['data'].length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i){
                  return CardNotes(
                      onDelete: () async{
                        var response = await postRequest(linkDeleteNotes, {
                          "id" : snapshot.data['data'][i]['notes_id'].toString(),
                          "imagename" : snapshot.data['data'][i]['notes_image'].toString(),
                        });
                        if(response['status'] == "success"){
                          Navigator.of(context).pushReplacementNamed("home");
                        }
                        },
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditNotes(
                          notes: snapshot.data['data'][i],
                        )));
                      },
                      noteModel: NoteModel.fromJson(snapshot.data['data'][i]),
                  );

                });
              }
              if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: Text("Loading..."),);
              }
              return const Center(child: Text("Loading..."),);
            })
          ],
        ),
      ),
    );
  }
}


