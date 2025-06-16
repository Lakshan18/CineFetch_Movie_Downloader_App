import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hinttext;
  final bool obsecuretext;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hinttext,
    required this.obsecuretext,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   textfieldinfo,
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontFamily: "Quicksand",
          //     fontWeight: FontWeight.w500,
          //     color: Color(0xFFA2CFF6),
          //   ),
          // ),
          TextField(
            controller: controller,
            style: TextStyle(
              fontSize: 18,
              fontFamily: "Quicksand",
              color: Color(0xFF1A1A1A),
            ),
            obscureText: obsecuretext,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 45, 84, 135)),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 17, 72, 140)),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 255, 0, 0)),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: Color(0xFF91ABCE),
              filled: true,
              hintText: hinttext,
              hintStyle: TextStyle(
                fontSize: 18,
                fontFamily: "Quicksand",
                color: Color.fromARGB(255, 79, 100, 119),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
