import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_list/helper/sql_helper.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/pages/home_page.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
  final TextEditingController _timeController = TextEditingController();

  void _getData() async {
    final data = await SQLHelper.getItem(widget.id);

    for (var element in data) {
      _todo.add(ToDo.fromMap(element));
    }
    if (mounted) setState(() {});
  }

  /* void onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(onPressed: () {}, child: const Text('OK')),
        ],
      ),
    );
  } */
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timeController.clear();
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
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        actions: [
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await flutterLocalNotificationsPlugin
                                    .zonedSchedule(
                                        0,
                                        _todo[0].title,
                                        _todo[0].description,
                                        tz.TZDateTime.now(tz.local).add(
                                          Duration(
                                            seconds: int.parse(
                                              _timeController.text,
                                            ),
                                          ),
                                        ),
                                        NotificationDetails(
                                            android: AndroidNotificationDetails(
                                                _todo[0].title,
                                                _todo[0].description,
                                                channelDescription:
                                                    _todo[0].description)),
                                        androidAllowWhileIdle: true,
                                        uiLocalNotificationDateInterpretation:
                                            UILocalNotificationDateInterpretation
                                                .absoluteTime);
                              },
                              child: Text("OK"))
                        ],
                        title: const Text("Remind me in: "),
                        content: TextField(
                          controller: _timeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ], // Only num
                          decoration: const InputDecoration(
                            suffixText: "Seconds",
                          ),
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.notifications)),
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
              ),
      ),
    );
  }
}
