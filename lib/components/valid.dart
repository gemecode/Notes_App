import 'package:notes_app/constant/message.dart';

validInput(String value, int min, int max){
  if(value.length > max){
    return "$messageInputMax $max";
  }
  if(value.isEmpty){
    return messageInputEmpty;
  }
  if(value.length < min){
    return "$messageInputMin $min";
  }
}