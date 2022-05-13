import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContainerTimePicker extends StatefulWidget {
  const ContainerTimePicker({
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
  State<ContainerTimePicker> createState() => _ContainerTimePickerState();
}

class _ContainerTimePickerState extends State<ContainerTimePicker> {
  late String date;
  late TimeOfDay? selectedTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedTime = (widget._controller.text.isNotEmpty)
        ? TimeOfDay(
            hour: int.parse(widget._controller.text.substring(0, 2)),
            minute: int.parse(widget._controller.text.substring(3, 5)))
        : TimeOfDay.now();
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
        onTap: () async {
          selectedTime = await showTimePicker(
              context: context,
              initialTime: (selectedTime) as TimeOfDay,
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: child as Widget);
              });
          setState(() {
            String _time = DateFormat.Hm().format(
                DateTime(0, 0, 0, selectedTime!.hour, selectedTime!.minute));
            widget._controller.text = _time;
          });
        },
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
