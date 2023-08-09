import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hint;
  final String? Function(String?) validator;
  final TextEditingController myController;
  const CustomTextForm({Key? key, required this.hint, required this.myController, required this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: validator,
        controller: myController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          hintText: hint,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(10)
            ),
            borderSide: BorderSide(color: Colors.black, width: 1)
          ),
        ),

      ),
    );
  }
}
