import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final controller;
  final String hinttext;
  final bool obsecuretext;
  final bool suffixIcon;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hinttext,
    required this.obsecuretext,
    required this.suffixIcon,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obsecuretext;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller,
            style: TextStyle(
              fontSize: 18,
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
            obscureText: _obscureText,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 45, 84, 135),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 17, 72, 140),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 255, 0, 0),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: Color(0xFF91ABCE),
              filled: true,
              suffixIcon: widget.suffixIcon
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Color.fromARGB(255, 79, 100, 119),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              hintText: widget.hinttext,
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
