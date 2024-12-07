import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {

  String? labelText;
  TextEditingController? controller;
  TextInputType? keyboardType;
  bool obscureText;
  final FocusNode? focusNode;


   MyTextField({
     super.key,
     required this.labelText,
     required this.controller,
     required this.keyboardType,
     required this.obscureText,
     required this.focusNode,

   });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
              BorderSide(color:Theme.of(context).colorScheme.tertiary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color:Theme.of(context).colorScheme.primary)
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
        )
      ),
    );
  }
}
