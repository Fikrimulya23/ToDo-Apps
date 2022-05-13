import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/pages/maps_page.dart';

class ContainerLocationPicker extends StatefulWidget {
  const ContainerLocationPicker({
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
  State<ContainerLocationPicker> createState() =>
      _ContainerLocationPickerState();
}

class _ContainerLocationPickerState extends State<ContainerLocationPicker> {
  // late String date;
  // TimeOfDay? selectedTime = TimeOfDay.now();

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
      ),
      child: TextFormField(
        validator: ((value) {
          if (value!.isEmpty) {
            null;
          }
        }),
        maxLines: widget.maxlines,
        controller: widget._controller,
        readOnly: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MapsPage(
                  controller: widget._controller,
                );
              },
            ),
          );
        },
        decoration: InputDecoration(
          fillColor: Colors.grey.shade100,
          filled: true,
          hintText: widget.text,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
