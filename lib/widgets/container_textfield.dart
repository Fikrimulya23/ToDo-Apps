import 'package:flutter/material.dart';

class ContainerTextField extends StatelessWidget {
  const ContainerTextField({
    Key? key,
    required TextEditingController controller,
    required this.text,
    required this.icon,
    required this.maxlines,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final IconData icon;
  final String text;
  final int maxlines;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 19),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.black.withOpacity(0.3),
          width: 2,
        ),
        /* boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            offset: const Offset(2, 2),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ], */
      ),
      child: TextFormField(
        validator: ((value) {
          if (value!.isEmpty) {
            null;
          }
        }),
        maxLines: maxlines,
        controller: _controller,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          fillColor: Colors.grey.shade100,
          filled: true,
          hintText: text,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
