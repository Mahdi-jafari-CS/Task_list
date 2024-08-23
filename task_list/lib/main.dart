import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data.dart';
import 'package:task_list/edit.dart';

const taskBoxName = 'task';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: primaryVariantColor));
  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794cff);
const Color primaryVariantColor = Color(0xff5C0AFF);
const secondaryTextColor = Color(0xffAFBED0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0x0ff1d28c);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
              headlineSmall: TextStyle(fontWeight: FontWeight.bold))),
          inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(color: secondaryTextColor),
              iconColor: secondaryTextColor,
              border: InputBorder.none),
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: const ColorScheme.light(
            primary: primaryColor,
            primaryContainer: primaryVariantColor,
            surface: Color(0xffF3F5F8),
            onSurface: primaryTextColor,
            secondary: primaryColor,
            onSecondary: Colors.white,
          ),
          useMaterial3: false,
        ),
        home: const HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TaskEntity>(taskBoxName);
    final themedata = Theme.of(context);
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditTaskScreen(task: TaskEntity())));
          },
          label: const Row(
              children: [Text('Create Task'), Icon(CupertinoIcons.add)]),
        ),
        body: Column(children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              themedata.colorScheme.primary,
              themedata.colorScheme.primaryContainer
            ])),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 24, 12, 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Todo List',
                        style: themedata.textTheme.headlineSmall!
                            .apply(color: themedata.colorScheme.onPrimary),
                      ),
                      Icon(
                        CupertinoIcons.share,
                        color: themedata.colorScheme.onPrimary,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 38,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(19),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                          )
                        ]),
                    child: const TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(CupertinoIcons.search),
                        label: Text('Search Tasks'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Box<TaskEntity>>(
                valueListenable: box.listenable(),
                builder: (context, box, child) {
                  return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      itemCount: box.values.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Today',
                                      style: themedata.textTheme.headlineSmall!
                                          .apply(fontSizeFactor: 0.8),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      height: 3,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(1.5),
                                        color: primaryColor,
                                      ),
                                    )
                                  ]),
                              MaterialButton(
                                color: const Color(0xffEAEFF5),
                                textColor: secondaryTextColor,
                                elevation: 0,
                                onPressed: () {},
                                child: const Row(
                                  children: [
                                    Text('Delete All'),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Icon(
                                      CupertinoIcons.delete,
                                      size: 18,
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        } else {
                          final TaskEntity task =
                              box.values.toList()[index - 1];
                          return TaskItem(
                            task: task,
                          );
                        }
                      });
                }),
          ),
        ]));
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: () {
        setState(() {
          widget.task.isCompleted = !widget.task.isCompleted;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.only(left: 16, right: 16),
        height: 84,
        decoration: BoxDecoration(
          color: themeData.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          MyCheckbox(value: widget.task.isCompleted),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              widget.task.name,
              style: TextStyle(
                  fontSize: 16,
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : null),
            ),
          ),
        ]),
      ),
    );
  }
}

class MyCheckbox extends StatelessWidget {
  final bool value;

  const MyCheckbox({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border:
              !value ? Border.all(color: secondaryTextColor, width: 2) : null,
          color: value ? themeData.colorScheme.primary : null,
        ),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                size: 16,
                color: themeData.colorScheme.onPrimary,
              )
            : null);
  }
}
