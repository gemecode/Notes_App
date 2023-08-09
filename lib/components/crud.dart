// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




String _basicAuth = 'Basic ${base64Encode(utf8.encode('gemecode:gemecode12345'))}';
Map<String, String> myheaders = {'authorization': _basicAuth};



class Crud{

  getRequest(String url) async{
    try{
      var response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        var responseBody = jsonDecode(response.body);
        return responseBody;
      }else{
        print("Error ${response.statusCode}");
      }
    }catch(e){
      print("Error Catch ( $e )");
    }
  }

  postRequest(String url, Map data) async{
    print("########### url= $url");
    print("########### data= $data");

    // await Future.delayed(const Duration(seconds: 2));
    try{
      var response = await http.post(Uri.parse(url), body: data, headers: myheaders);  // headers: myheaders
      print("########### data= $response");


      if(response.statusCode == 200){
        var responseBody = jsonDecode(response.body);
        return responseBody;
      }else{
        print("Error ${response.statusCode}");
      }
    }catch(e){
      print("Error Catch$e");
    }
  }


  postRequestWithFile(String url , Map data , File file) async{
    var request = http.MultipartRequest("POST", Uri.parse(url));
    var length = await file.length();
    var stream = http.ByteStream(file.openRead());
    var multipartFile = http.MultipartFile("file", stream, length, filename: basename(file.path));
    request.headers.addAll(myheaders);
    request.files.add(multipartFile);

    data.forEach((key, value) {
      request.fields[key] = value;
    });

    var myRequest = await request.send();
    var response = await http.Response.fromStream(myRequest);
    if (myRequest.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      print("Error ${myRequest.statusCode}");
    }
  }

}