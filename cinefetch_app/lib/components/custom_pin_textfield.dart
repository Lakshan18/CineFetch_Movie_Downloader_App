import 'package:flutter/material.dart';

class MyPinTextField extends StatefulWidget {
  final controller;
  final String textfieldinfo;
  final String hinttext;
  final bool obsecuretext;
  final bool suffixIcon;

  const MyPinTextField({
    super.key,
    required this.controller,
    required this.hinttext,
    required this.textfieldinfo,
    required this.obsecuretext,
    required this.suffixIcon,
  });

  @override
  State<MyPinTextField> createState() => _MyPinTextFieldState();
}

class _MyPinTextFieldState extends State<MyPinTextField> {
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
          Text(
            widget.textfieldinfo,
            style: TextStyle(
              fontSize: 15,
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 255, 253, 120),
            ),
          ),
          const SizedBox(height: 15.0),
          TextField(
            controller: widget.controller,
            style: TextStyle(
              fontSize: 18,
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
            obscureText: _obscureText,
            maxLength: 6,
            keyboardType: TextInputType.number,
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
