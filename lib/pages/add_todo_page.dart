import 'package:flutter/material.dart';
import 'package:todo_list/helper/sql_helper.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/pages/home_page.dart';
import 'package:todo_list/widgets/container_date_picker.dart';
import 'package:todo_list/widgets/container_location_picker.dart';
import 'package:todo_list/widgets/container_textfield.dart';
import 'package:todo_list/widgets/containert_time_picker.dart';

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({Key? key}) : super(key: key);

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController =
        TextEditingController();
    final TextEditingController _dateController = TextEditingController();
    final TextEditingController _timeController = TextEditingController();
    final TextEditingController _locationController = TextEditingController();

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
                      if (_titleController.text.isNotEmpty ||
                          _descriptionController.text.isNotEmpty ||
                          _dateController.text.isNotEmpty ||
                          _timeController.text.isNotEmpty ||
                          _locationController.text.isNotEmpty) {
                        print(_locationController.text);

                        ToDo _items = ToDo(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          date: _dateController.text,
                          time: _timeController.text,
                          location: _locationController.text,
                        );
                        await SQLHelper.createItem(_items);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (context) {
                            return HomePage();
                          },
                        ), (route) => false);
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text((_titleController.text.isEmpty)
                                    ? "Title cant be empty"
                                    : (_descriptionController.text.isEmpty)
                                        ? "Description cant be empty"
                                        : (_dateController.text.isEmpty)
                                            ? "Date cant be empty"
                                            : (_timeController.text.isEmpty)
                                                ? "Time cant be empty"
                                                : (_locationController
                                                        .text.isEmpty)
                                                    ? "Location cant be empty"
                                                    : ""),
                                content: Text("Please fill all the fields"),
                              );
                            });
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
