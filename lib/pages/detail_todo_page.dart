import 'package:flutter/material.dart';
import 'package:todo_list/helper/sql_helper.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/pages/edit_todo_page.dart';
import 'package:todo_list/pages/home_page.dart';

class DetailToDoPage extends StatefulWidget {
  const DetailToDoPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int? id;

  @override
  State<DetailToDoPage> createState() => _DetailToDoPageState();
}

class _DetailToDoPageState extends State<DetailToDoPage> {
  final List<ToDo> _todo = [];

  void _getData() async {
    final data = await SQLHelper.getItem(widget.id);
    setState(() {
      for (var element in data) {
        _todo.add(ToDo.fromMap(element));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail",
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return EditToDoPage(toDo: _todo[0]);
                  },
                ),
              );
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              SQLHelper.deleteItem(_todo[0].id as int);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false);
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: SafeArea(
          child: (_todo.isEmpty)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("*ambil data berdasarkan ID"),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Title",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        Text(_todo[0].title),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Description",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        Text(_todo[0].description),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Date",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        Text(_todo[0].date),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Time",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        Text(_todo[0].time),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Location Coordinate",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        Text(_todo[0].location),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }
}
