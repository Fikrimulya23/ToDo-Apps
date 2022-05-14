import 'package:flutter/material.dart';
import 'package:todo_list/helper/sql_helper.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/pages/add_todo_page.dart';
import 'package:todo_list/pages/detail_todo_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // All journals
  final List<ToDo> _toDo = [];

  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();

    for (var element in data) {
      _toDo.add(ToDo.fromMap(element));
    }
    if (!mounted) return;
    setState(() {});
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    _refreshJournals();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Detroit'));
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ToDo List",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /* Route route =
              MaterialPageRoute(builder: (context) => const AddToDoPage());
          Navigator.push(context, route).then(onGoBack); */
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return AddToDoPage();
            },
          ));
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
        child: (_toDo.isEmpty)
            ? Center(
                child: Text("Empty data"),
              )
            : Container(
                // color: Colors.black.withOpacity(0.85),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      GridView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _toDo.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return DetailToDoPage(
                                          id: _toDo[index].id);
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.2),
                                    width: 3,
                                  ),
                                ),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _toDo[index].title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      _toDo[index].description,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      _toDo[index].date,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      _toDo[index].time,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Expanded(child: SizedBox()),
                                    // SizedBox.expand(),
                                    Text(
                                      _toDo[index].location,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => HomePage()),
    );
  }
}
