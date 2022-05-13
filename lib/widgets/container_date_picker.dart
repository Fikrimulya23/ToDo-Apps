import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContainerDatePicker extends StatefulWidget {
  const ContainerDatePicker({
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
  State<ContainerDatePicker> createState() => _ContainerDatePickerState();
}

class _ContainerDatePickerState extends State<ContainerDatePicker> {
  late DateTime selectedDate;
  late String date;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    ).then((value) {
      if (value != null) {
        setState(() {
          date = value.toString();
          String formattedDate = DateFormat('yyyy-MM-dd').format(value);
          widget._controller.text = formattedDate;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate = (widget._controller.text.isNotEmpty)
        ? DateTime.parse(widget._controller.text)
        : DateTime.now();
  }

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

        onTap: () => _selectDate(context),

        // keyboardType: TextInputType.emailAddress,
        // textInputAction: TextInputAction.next,
        // cursorColor: Colors.black,
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
