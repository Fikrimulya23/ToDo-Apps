import 'package:flutter/material.dart';
import 'package:todo_list/helper/sql_helper.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/pages/home_page.dart';
import 'package:todo_list/widgets/container_date_picker.dart';
import 'package:todo_list/widgets/container_location_picker.dart';
import 'package:todo_list/widgets/container_textfield.dart';
import 'package:todo_list/widgets/containert_time_picker.dart';

class EditToDoPage extends StatefulWidget {
  const EditToDoPage({
    Key? key,
    required this.toDo,
  }) : super(key: key);

  final ToDo toDo;

  @override
  State<EditToDoPage> createState() => _EditToDoPageState();
}

class _EditToDoPageState extends State<EditToDoPage> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController _titleController =
        TextEditingController(text: widget.toDo.title);
    final TextEditingController _descriptionController =
        TextEditingController(text: widget.toDo.description);
    final TextEditingController _dateController =
        TextEditingController(text: widget.toDo.date);
    final TextEditingController _timeController =
        TextEditingController(text: widget.toDo.time);
    final TextEditingController _locationController =
        TextEditingController(text: widget.toDo.location);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add ToDo",
        ),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                ContainerTextField(
                  controller: _titleController,
                  icon: Icons.person,
                  text: "Title",
                  maxlines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                ContainerTextField(
                  controller: _descriptionController,
                  icon: Icons.person,
                  text: "Description",
                  maxlines: 4,
                ),
                const SizedBox(
                  height: 10,
                ),
                ContainerDatePicker(
                  controller: _dateController,
                  icon: Icons.person,
                  text: "yyyy-m-d",
                  maxlines: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                ContainerTimePicker(
                  controller: _timeController,
                  icon: Icons.person,
                  text: "--:--",
                  maxlines: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                ContainerLocationPicker(
                  controller: _locationController,
                  text: "Location",
                  icon: Icons.location_on,
                  maxlines: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        print(_locationController.text);

                        ToDo _items = ToDo(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          date: _dateController.text,
                          time: _timeController.text,
                          location: _locationController.text,
                        );
                        print(_items.title);
                        await SQLHelper.updateItem(_items);
                        /* Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (context) {
                            return HomePage();
                          },
                        ), (route) => false); */
                      } else {
                        print("not validate");
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
